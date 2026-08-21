#!/usr/bin/env bash
# 秘密管理 v2 初始化脚本（跨 NixOS / macOS / Fedora）。
#
# 设计：
#   1. 不生成新的 age key，优先复用现有 SSH 密钥作为 sops 解密身份：
#      - NixOS/macOS：/etc/ssh/ssh_host_ed25519_key
#      - 其他系统（Fedora/Steam Deck）：~/.ssh/id_ed25519
#   2. 密文拆分：
#      - secrets/common/secrets.yaml      所有机器共享（API key 等）
#      - secrets/hosts/<user>@<host>/secrets.yaml  当前机器专属
#   3. sops/age/ssh-to-age 依赖获取优先级：
#      - 系统已安装
#      - dotfiles flake 锁定包（走 flake.nix 的 SJTU 镜像配置）
#      - dnf / brew
set -euo pipefail

REPO_DIR="${DOTFILES_REPO:-$HOME/dotfiles}"
SECRETS_SRC_DIR="${DOTFILES_SECRETS_DIR:-$HOME/.config/dotfiles/secrets}"

# machines/ 注册表使用不带 .local 的规范主机名。
# 优先 SOPS_IDENTITY 覆盖；macOS 用 LocalHostName，避免 hostname 返回 xxx.local。
if [ -n "${SOPS_IDENTITY:-}" ]; then
  IDENTITY="$SOPS_IDENTITY"
else
  USER_NAME="$(whoami)"
  if [ "$(uname -s)" = "Darwin" ] && command -v scutil >/dev/null 2>&1; then
    HOST_NAME="$(scutil --get LocalHostName)"
  elif [ -r /etc/hostname ] && [ -s /etc/hostname ]; then
    HOST_NAME="$(cat /etc/hostname)"
  else
    HOST_NAME="$(hostname)"
  fi
  IDENTITY="${USER_NAME}@${HOST_NAME}"
fi
SOPS_CONFIG="$REPO_DIR/.sops.yaml"
COMMON_YAML="$REPO_DIR/secrets/common/secrets.yaml"
HOST_DIR="$REPO_DIR/secrets/hosts/$IDENTITY"
HOST_YAML="$HOST_DIR/secrets.yaml"

# ---------------------------------------------------------------------------
# 工具执行器
# ---------------------------------------------------------------------------
has_cli_tools() {
  command -v sops >/dev/null 2>&1
}

sops_exec() {
  if has_cli_tools; then
    "$@"
    return
  fi

  if command -v nix >/dev/null 2>&1 && [ -f "$REPO_DIR/flake.nix" ]; then
    nix shell \
      "$REPO_DIR#age" \
      "$REPO_DIR#sops" \
      "$REPO_DIR#ssh-to-age" \
      -c "$@"
    return
  fi

  if command -v dnf >/dev/null 2>&1; then
    echo "==> dnf 安装 age/sops"
    sudo dnf install -y age sops
  elif command -v brew >/dev/null 2>&1; then
    echo "==> brew 安装 age/sops"
    brew install age sops
  fi

  if has_cli_tools; then
    "$@"
    return
  fi

  echo "ERROR: 需要 sops 与 ssh-to-age。可安装 Nix 后重跑，或手工安装。" >&2
  exit 1
}

ssh_to_age() {
  if command -v ssh-to-age >/dev/null 2>&1; then
    ssh-to-age "$@"
  elif command -v nix >/dev/null 2>&1 && [ -f "$REPO_DIR/flake.nix" ]; then
    nix shell "$REPO_DIR#ssh-to-age" -c ssh-to-age "$@"
  else
    echo "ERROR: 找不到 ssh-to-age（需要 Nix 或手工安装）" >&2
    exit 1
  fi
}

# ---------------------------------------------------------------------------
# 选择并确保 SSH 解密身份。
# 系统级 sops 用 host key；home-manager sops 用用户 key。
# NixOS/macOS 会把两者都登记为 recipient；standalone 只登记用户 key。
# ---------------------------------------------------------------------------
ensure_host_key() {
  HOST_KEY="/etc/ssh/ssh_host_ed25519_key"
  HOST_PUB="$HOST_KEY.pub"
  if [ ! -f "$HOST_KEY" ]; then
    echo "==> 生成系统 SSH host key"
    if [ "$(id -u)" -eq 0 ]; then
      ssh-keygen -A
    else
      sudo ssh-keygen -A
    fi
  fi
  printf '%s\n' "$HOST_PUB"
}

ensure_user_key() {
  USER_KEY="$HOME/.ssh/id_ed25519"
  USER_PUB="$USER_KEY.pub"
  if [ ! -f "$USER_KEY" ]; then
    echo "==> 生成用户 SSH key（home-manager sops 解密用，无 passphrase）"
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -q -t ed25519 -a 100 -N "" -C "$IDENTITY" -f "$USER_KEY"
  fi
  printf '%s\n' "$USER_PUB"
}

SSH_PUB_KEYS=()
SSH_KEY_LABELS=()
if [ -n "${SOPS_SSH_PUBLIC_KEYS:-}" ]; then
  IFS=, read -r -a SSH_PUB_KEYS <<<"$SOPS_SSH_PUBLIC_KEYS"
  for idx in "${!SSH_PUB_KEYS[@]}"; do
    SSH_KEY_LABELS+=("key${idx}")
  done
elif [ -n "${SOPS_SSH_PRIVATE_KEY:-}" ]; then
  SSH_PUB_KEYS+=("${SOPS_SSH_PUBLIC_KEY:-${SOPS_SSH_PRIVATE_KEY}.pub}")
  SSH_KEY_LABELS+=("user")
elif command -v nixos-rebuild >/dev/null 2>&1 \
  || [ -f /etc/NIXOS ] \
  || [ "$(uname -s)" = "Darwin" ]; then
  SSH_PUB_KEYS+=("$(ensure_host_key)")
  SSH_KEY_LABELS+=("host")
  SSH_PUB_KEYS+=("$(ensure_user_key)")
  SSH_KEY_LABELS+=("user")
else
  SSH_PUB_KEYS+=("$(ensure_user_key)")
  SSH_KEY_LABELS+=("user")
fi

AGE_RECIPIENTS=()
for pub in "${SSH_PUB_KEYS[@]}"; do
  if [ ! -f "$pub" ]; then
    echo "ERROR: 找不到 SSH 公钥 $pub" >&2
    exit 1
  fi
  AGE_RECIPIENTS+=("$(ssh_to_age -i "$pub")")
  echo "==> recipient: $pub -> ${AGE_RECIPIENTS[-1]}"
done

AGE_RECIPIENTS_CSV="$(IFS=,; echo "${AGE_RECIPIENTS[*]}")"
AGE_LABELS_CSV="$(IFS=,; echo "${SSH_KEY_LABELS[*]}")"

# ---------------------------------------------------------------------------
# 维护 .sops.yaml：
#   - 每个 recipient 使用独立的 YAML anchor（sops updatekeys 要求）
#   - common 规则引用所有机器 anchor
#   - 每台机器有自己的 host 专属 creation_rule
# ---------------------------------------------------------------------------
if [ ! -f "$SOPS_CONFIG" ]; then
  cp "$REPO_DIR/sops.yaml.example" "$SOPS_CONFIG"
fi

ANCHOR="$(printf '%s' "$IDENTITY" | tr -c 'A-Za-z0-9_' '_')"
python3 - "$SOPS_CONFIG" "$IDENTITY" "$ANCHOR" "$AGE_RECIPIENTS_CSV" "$AGE_LABELS_CSV" <<'PY'
import pathlib
import re
import sys

cfg_path = pathlib.Path(sys.argv[1])
identity = sys.argv[2]
anchor_base = sys.argv[3]
recipients = [r.strip() for r in sys.argv[4].split(",") if r.strip()]
labels = sys.argv[5].split(",") if len(sys.argv) > 5 and sys.argv[5] else []
text = cfg_path.read_text()

header = """# sops 配置文件（仅含公钥，可安全提交）。
#
# 约定：
#   - 每个 age recipient 使用独立的 YAML anchor；
#   - common 密文允许所有机器解密；
#   - 机器专属密文只允许对应机器的 keys。
#
# 添加新机器后，需要在任一已授权机器上运行：
#   sops updatekeys secrets/common/secrets.yaml
"""

# 1. 读取既有 anchor（其他机器的 recipient），剔除当前机器的旧 anchor
anchors = {}
for line in text.splitlines():
    m = re.match(r"^\s*-\s*&([A-Za-z0-9_]+)\s+(age1[0-9a-zA-Z]+)\s*$", line)
    if m:
        anchors[m.group(1)] = m.group(2)

anchors = {
    name: rec
    for name, rec in anchors.items()
    if not name.startswith(anchor_base + "_")
}
has_existing_anchors = bool(anchors)

# 2. 加入当前机器的 host/user recipients
for idx, recipient in enumerate(recipients):
    label = labels[idx] if idx < len(labels) else f"key{idx}"
    anchors[f"{anchor_base}_{label}"] = recipient

# 3. 生成 keys 段与 common 规则
keys_block = ["keys:", "  - &hosts:"]
keys_block += [f"      - &{name} {rec}" for name, rec in anchors.items()]

common_refs = "\n".join(f"          - *{name}" for name in anchors)

# 4. 保留其他机器的 host 规则，删除当前机器的旧 host 规则。
#    若旧文件是首次从模板复制的（没有任何 age anchor），则丢弃模板规则。
rules_tail = ""
if has_existing_anchors and "creation_rules:" in text:
    rules_tail = text.split("creation_rules:", 1)[1]
# 旧 common 规则与当前机器的 host 规则都由本脚本重新生成
rules_tail = re.sub(
    r"(?ms)^  - path_regex: \^secrets/common/secrets\\\.yaml\$.*?(?=^  - path_regex:|\Z)",
    "",
    rules_tail,
)
rules_tail = re.sub(
    rf"(?ms)^  - path_regex: \^secrets/hosts/{re.escape(identity)}/secrets\\\.yaml\$.*?(?=^  - path_regex:|\Z)",
    "",
    rules_tail,
)
rules_tail = rules_tail.rstrip()

current_rule = f"""  - path_regex: ^secrets/hosts/{identity}/secrets\\.yaml$
    key_groups:
      - age:
"""
current_rule += "\n".join(f"          - *{name}" for name in anchors if name.startswith(anchor_base + "_"))

new_text = header + "\n" + "\n".join(keys_block) + "\n\ncreation_rules:\n" + f"""  - path_regex: ^secrets/common/secrets\\.yaml$
    key_groups:
      - age:
{common_refs}
""" + rules_tail + "\n\n" + current_rule + "\n"

cfg_path.write_text(new_text)
PY
echo "==> 已更新 $SOPS_CONFIG"

# ---------------------------------------------------------------------------
# 加密 common 密文
# ---------------------------------------------------------------------------
mkdir -p "$(dirname "$COMMON_YAML")"

tmp_json="$(mktemp)"
python3 - "$SECRETS_SRC_DIR" "$tmp_json" <<'PY'
import json
import pathlib
import sys

src = pathlib.Path(sys.argv[1])
out = pathlib.Path(sys.argv[2])

def read(name):
    path = src / name
    if not path.exists():
        return None
    return path.read_text().strip()

values = {
    "deepseek-api-key": read("deepseek_api_key"),
    "glm-api-key": read("glm_api_key"),
}
values = {k: v for k, v in values.items() if v is not None}
if not values:
    values = {
        "_placeholder": "no plaintext API keys found; add deepseek-api-key/glm-api-key",
    }
out.write_text(json.dumps(values))
PY

if [ -f "$COMMON_YAML" ]; then
  echo "==> $COMMON_YAML 已存在，不覆盖"
  echo "    若当前机器无法解密，请在已授权机器上执行："
  echo "      cd $REPO_DIR && sops updatekeys secrets/common/secrets.yaml"
  echo "    或："
  echo "      cd $REPO_DIR && sops --add-age '$AGE_RECIPIENTS_CSV' --in-place secrets/common/secrets.yaml"
else
  (
    cd "$REPO_DIR"
    sops_exec sops \
      --config .sops.yaml \
      --encrypt \
      --age "$AGE_RECIPIENTS_CSV" \
      --input-type json \
      --output-type yaml \
      --encrypted-regex '^(deepseek-api-key|glm-api-key)$' \
      --filename-override secrets/common/secrets.yaml \
      "$tmp_json"
  ) > "$COMMON_YAML"
  if [ ! -s "$COMMON_YAML" ]; then
    echo "ERROR: $COMMON_YAML 生成为空" >&2
    exit 1
  fi
  chmod 644 "$COMMON_YAML"
  echo "==> 已生成 $COMMON_YAML"
fi

# ---------------------------------------------------------------------------
# 加密 host 密文
# ---------------------------------------------------------------------------
mkdir -p "$HOST_DIR"

if [ -f "$HOST_YAML" ]; then
  echo "==> $HOST_YAML 已存在，不覆盖"
else
  host_json="$(mktemp)"
  printf '{"_placeholder":"host-specific secrets for %s"}' "$IDENTITY" > "$host_json"
  (
    cd "$REPO_DIR"
    sops_exec sops \
      --config .sops.yaml \
      --encrypt \
      --age "$AGE_RECIPIENTS_CSV" \
      --input-type json \
      --output-type yaml \
      --encrypted-regex '.*' \
      --filename-override "secrets/hosts/${IDENTITY}/secrets.yaml" \
      "$host_json"
  ) > "$HOST_YAML"
  rm -f "$host_json"
  if [ ! -s "$HOST_YAML" ]; then
    echo "ERROR: $HOST_YAML 生成为空" >&2
    exit 1
  fi
  chmod 644 "$HOST_YAML"
  echo "==> 已生成 $HOST_YAML"
fi

rm -f "$tmp_json"

echo
echo "==> 完成"
echo "请提交："
echo "  .sops.yaml"
echo "  secrets/common/secrets.yaml"
echo "  secrets/hosts/$IDENTITY/secrets.yaml"
echo
echo "明文密钥仍只保存在：$SECRETS_SRC_DIR"
echo "恢复/授权新机器：把其 SSH 公钥转成 age recipient 加入 .sops.yaml 的 &hosts，"
echo "然后在已授权机器上运行：cd $REPO_DIR && sops updatekeys secrets/common/secrets.yaml"

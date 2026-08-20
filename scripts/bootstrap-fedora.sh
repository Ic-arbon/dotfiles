#!/usr/bin/env bash
# Fedora OB714 首次引导：
#   1. 校验身份必须是 tyd@OB714
#   2. 安装 Nix（Determinate Systems installer）
#   3. 生成 sops age 私钥（仓库外）
#   4. 部署 standalone home-manager 配置
set -euo pipefail

EXPECTED_USER="tyd"
EXPECTED_HOST="OB714"
EXPECTED_ID="${EXPECTED_USER}@${EXPECTED_HOST}"

actual_user="$(whoami)"
actual_host="$(hostname)"
actual_id="${actual_user}@${actual_host}"

if [[ "$actual_id" != "$EXPECTED_ID" ]]; then
  echo "身份不匹配：当前是 $actual_id，本脚本只允许在 $EXPECTED_ID 上运行" >&2
  exit 1
fi

echo "==> 身份校验通过：$actual_id"

if ! command -v nix >/dev/null 2>&1; then
  echo "==> 安装 Nix（Determinate Systems）"
  curl --proto '=https' --tlsv1.2 -sSf -L \
    https://install.determinate.systems/nix | sh -s -- install --no-confirm
  # 当前 shell 重新加载 nix 环境
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

command -v nix >/dev/null 2>&1 || {
  echo "Nix 安装后仍未找到，请重新登录后再运行本脚本" >&2
  exit 1
}

echo "==> 准备仓库外的密钥目录"
mkdir -p "$HOME/.config/dotfiles/secrets"
chmod 700 "$HOME/.config/dotfiles/secrets"
if [ ! -f "$HOME/.config/dotfiles/secrets/deepseek_api_key" ]; then
  echo "WARN: 缺少 ~/.config/dotfiles/secrets/deepseek_api_key（shell 别名将不可用）" >&2
fi
if [ ! -f "$HOME/.config/dotfiles/secrets/glm_api_key" ]; then
  echo "WARN: 缺少 ~/.config/dotfiles/secrets/glm_api_key（shell 别名将不可用）" >&2
fi

echo "==> 准备 sops 解密身份（用户 SSH key）"
SSH_KEY="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY" ]; then
  echo "生成 SSH key：$SSH_KEY"
  ssh-keygen -t ed25519 -a 100 -C "tyd@OB714" -f "$SSH_KEY"
else
  echo "已存在 SSH key，跳过生成"
fi

echo "==> 初始化 sops 密文（common + host）"
"$HOME/dotfiles/scripts/setup-sops.sh"

echo "==> 部署 OB714 home-manager 配置"
nix run github:nix-community/home-manager/release-25.11 -- \
  switch -b backup --flake "$HOME/dotfiles#tyd@OB714"

echo "==> 完成"
echo "新机器的 age recipient 已写入 .sops.yaml；请在已授权机器上运行："
echo "  sops updatekeys ~/dotfiles/secrets/common/secrets.yaml"

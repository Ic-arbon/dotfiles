#!/usr/bin/env bash
# 检查 repo 内 secrets/ 只允许存在 SOPS 密文目录结构：
#   - README.md
#   - common/secrets.yaml
#   - hosts/<identity>/secrets.yaml
# 其他文件（尤其明文密钥）视为泄漏并拒绝提交。
set -euo pipefail

SECRETS_DIR="${1:-./secrets}"

if [ ! -d "$SECRETS_DIR" ]; then
  exit 0
fi

is_allowed() {
  local rel="$1"
  case "$rel" in
    README.md) return 0 ;;
    common/secrets.yaml) return 0 ;;
    hosts/*/secrets.yaml) return 0 ;;
    *) return 1 ;;
  esac
}

failed=0
while IFS= read -r -d '' file; do
  rel="${file#"$SECRETS_DIR"/}"
  if ! is_allowed "$rel"; then
    echo "BLOCKED: secrets/ 中不允许存在明文密钥文件: $rel" >&2
    echo "允许的结构：README.md、common/secrets.yaml、hosts/<identity>/secrets.yaml" >&2
    echo "明文密钥应放在仓库外：~/.config/dotfiles/secrets/" >&2
    failed=1
  fi
done < <(find "$SECRETS_DIR" -type f -print0)

exit "$failed"

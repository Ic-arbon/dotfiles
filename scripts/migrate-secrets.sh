#!/usr/bin/env bash
# 将 dotfiles 仓库中的明文密钥迁移到仓库外。
# 目标目录默认 $HOME/.config/dotfiles/secrets，可用 DOTFILES_SECRETS_DIR 覆盖。
#
# 安全策略：
#   - 已存在同名目标文件时，仅当内容一致才删除旧文件；否则拒绝覆盖，由你手工处理。
#   - 迁移完成后校验 repo 内不再有这些明文文件。
set -euo pipefail

REPO_DIR="${DOTFILES_REPO:-$HOME/dotfiles}"
SRC_DIR="$REPO_DIR/secrets"
DST_DIR="${DOTFILES_SECRETS_DIR:-$HOME/.config/dotfiles/secrets}"

declare -a SECRET_FILES=(
  deepseek_api_key
  glm_api_key
)

mkdir -p "$DST_DIR"
chmod 700 "$DST_DIR"

migrated=0
for name in "${SECRET_FILES[@]}"; do
  src="$SRC_DIR/$name"
  dst="$DST_DIR/$name"

  if [ ! -f "$src" ]; then
    echo "skip: $src 不存在"
    continue
  fi

  if [ -f "$dst" ]; then
    if cmp -s "$src" "$dst"; then
      echo "same: $name（目标已存在且内容一致，删除旧文件）"
      rm -f "$src"
      migrated=1
    else
      echo "CONFLICT: $dst 已存在且与 $src 内容不同，请手工处理" >&2
      exit 1
    fi
  else
    mv "$src" "$dst"
    migrated=1
  fi

  chmod 600 "$dst"
  echo "moved: $name -> $dst"
done

if [ "$migrated" -eq 1 ]; then
  echo "OK: 明文密钥已迁移到 $DST_DIR"
else
  echo "OK: repo 内没有需要迁移的明文密钥"
fi

# 校验：repo 内不应再出现这些明文文件。
for name in "${SECRET_FILES[@]}"; do
  if [ -f "$SRC_DIR/$name" ]; then
    echo "ERROR: $SRC_DIR/$name 仍然存在" >&2
    exit 1
  fi
done

# repo 内只允许 SOPS 密文目录结构（README/common/hosts）。
if [ -d "$SRC_DIR" ]; then
  "$REPO_DIR/scripts/check-no-plaintext-secrets.sh" "$SRC_DIR"
fi

echo "verify: repo secrets/ 检查通过"

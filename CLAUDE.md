# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 构建和部署命令

```bash
# NixOS 系统配置
sudo nixos-rebuild switch --flake ~/dotfiles#tydsG16    # 游戏本配置
sudo nixos-rebuild switch --flake ~/dotfiles#celestia   # 台式机配置
sudo nixos-rebuild switch --flake ~/dotfiles#proxy      # 代理服务器配置
sudo nixos-rebuild switch --flake ~/dotfiles#seafile    # 文件服务器配置

# macOS 系统配置
darwin-rebuild switch --flake ~/dotfiles#tydsMBA

# 独立 home-manager 配置
home-manager switch -b backup --flake ~/dotfiles#deck@steam-deck
home-manager switch -b backup --flake ~/dotfiles#tyd@OB714   # Fedora
```

### 便捷更新命令

```bash
update  # 由当前机器的 identity 自动选择部署命令
```

### 开发和调试

```bash
nix fmt
nix flake check
nix flake show
```

## 代码架构

基于 Nix Flakes 的多平台统一配置，支持 NixOS、nix-darwin、standalone home-manager（Fedora/Steam Deck）。

### 核心设计

1. **机器清单是唯一注册点**：`machines/<username>@<hostname>.nix` 声明 identity、facts、profiles；`outputs/default.nix` 自动扫描生成三类 flake outputs。新增机器只加一个文件。
2. **profiles 是组件套餐**：
   - `home.core`：所有机器强制（builder 自动注入）
   - `home.server`：无头服务器生产工具
   - `home.dev.{full,embedded,android,vm}`：开发工具
   - `home.desktop.{common,fonts,input,multimedia,electron,gnome,hyprland,gaming}`：GUI 组件
   - `home.networking.{ssh,dae}`
   - `home.platform.*`：由 `identity.kind` 自动注入
3. **模块只读 options，不做探测**：机器身份/事实通过 `modules/meta.nix` 的 `dotfiles.machine`、`dotfiles.hardware` 等注入。禁止在模块中 `builtins.pathExists /etc/nixos`、读电池/NVIDIA 设备等构建机探测。
4. **系统模块复用**：NixOS 重复配置抽取到 `modules/nixos/`；GPU Bus ID、用户名等差异用 options 或 machine facts。

### 用户配置

- `users/tyd/common.nix`、`users/deck/common.nix`：机器无关的用户基础配置。
- 机器专属覆盖放在 `machines/` 的 `home.extraImports` 中。

## 密钥安全（重要）

- 明文密钥只在仓库外：`~/.config/dotfiles/secrets/`（700/600）。
- 仓库 `secrets/` 只允许 SOPS 密文：
  - `secrets/common/secrets.yaml`：所有机器共享
  - `secrets/hosts/<identity>/secrets.yaml`：机器专属
- 解密身份优先复用 SSH key：
  - NixOS/macOS 系统级：`/etc/ssh/ssh_host_ed25519_key`
  - home-manager 用户级：`~/.ssh/id_ed25519`（所有平台）
  - `setup-sops.sh` 会在 NixOS/macOS 上同时登记 host key 与 user key，standalone 只登记 user key
  - 若用户 SSH key 有 passphrase，可在 `machines/<identity>.nix` 设置 `home.sopsAgeKeyFile` fallback。
- 初始化/更新：`scripts/setup-sops.sh`；旧位置迁移：`scripts/migrate-secrets.sh`。
- pre-commit 已启用 `gitleaks`、`detect-private-keys`、`no-plaintext-secrets`。
- 任何密钥曾进入 git 历史都视为泄露：先轮换，再考虑清理历史。

## 代码规范

### 提交规范

Conventional Commits：
- `feat(module)` / `fix(host)` / `config(system)` / `docs`

### Nix 代码风格

- 使用 `nix fmt`
- 优先使用 `lib` 函数
- 模块间通过 `imports` 组合
- 机器差异通过 options，不在共享模块写机器名/用户名分支

## 安全注意事项

- SSH 密钥手动生成（`ssh-keygen -t ed25519`）
- Git 用户信息通过 `modules/rename_git.sh` 手动设置
- 敏感配置使用 sops-nix 或仓库外文件

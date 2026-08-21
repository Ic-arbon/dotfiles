# Dotfiles for Multi-Platform Nix Configuration

基于 Nix Flakes 的多机器多系统统一配置管理方案，支持 NixOS、macOS（nix-darwin）、Fedora 独立 home-manager。

**核心理念：**
- 一套配置跨 NixOS / macOS / Fedora 复用，快速迁移开发与生产环境
- `<username>@<hostname>` 唯一确定一台机器的组件组合与机器事实
- 新增机器 = 只新增一个 `machines/<username>@<hostname>.nix`
- 模块不探测构建机，机器差异全部由声明式 options 注入

## 目录结构

```text
dotfiles/
├── machines/        # ★ 机器清单：文件即注册点，username@hostname.nix
├── profiles/        # 组件套餐：core/server/dev/desktop/networking/platform
├── modules/         # 通用模块：home/、nixos/、darwin/ 以及 meta options
├── hosts/           # 机器私有硬件配置（hardware-configuration 等）
├── outputs/         # builders + 自动扫描 machines/ 生成 flake outputs
├── users/           # 每个用户的机器无关 common.nix
└── secrets/         # 只允许 SOPS 加密的 secrets.yaml + README
```

## 机器清单

| identity | 类型 | 组合 |
|---|---|---|
| `tyd@tydsG16` | NixOS | desktop.hyprland + gaming + dev.embedded + networking |
| `tyd@celestia` | NixOS | desktop.hyprland + gaming + dev.embedded + networking |
| `tyd@proxy` | NixOS | core + server |
| `tyd@seafile` | NixOS | core + server |
| `tyd@tydsMBA` | nix-darwin | core + desktop.common + desktop.multimedia |
| `deck@steam-deck` | standalone | core + desktop.common/fonts + networking.dae |
| `tyd@OB714` | standalone Fedora | core + desktop.gnome + dev.vm |

## 部署

```bash
# NixOS
sudo nixos-rebuild switch --flake ~/dotfiles#tydsG16
sudo nixos-rebuild switch --flake ~/dotfiles#celestia
sudo nixos-rebuild switch --flake ~/dotfiles#proxy
sudo nixos-rebuild switch --flake ~/dotfiles#seafile

# macOS
darwin-rebuild switch --flake ~/dotfiles#tydsMBA

# Steam Deck
home-manager switch -b backup --flake ~/dotfiles#deck@steam-deck

# Fedora OB714（首次运行 scripts/bootstrap-fedora.sh）
home-manager switch -b backup --flake ~/dotfiles#tyd@OB714
```

`update` 别名由当前机器的 identity 自动选择正确命令。

## 新增机器

1. 新建 `machines/<username>@<hostname>.nix`，填写 identity/facts/profiles；
2. `nix flake show` 验证新输出；
3. 部署。

无需修改 `outputs/default.nix` 或任何共享模块。

## Fedora OB714

- 独立 home-manager，系统层继续由 dnf 管理。
- 组件：`core + desktop.gnome + dev.vm`（GNOME 桌面工具 + 虚拟化开发工具，无 electron/embedded/hyprland/gaming）。
- 首次引导：`~/dotfiles/scripts/bootstrap-fedora.sh`。

## 密钥安全

- 明文密钥只在仓库外：`~/.config/dotfiles/secrets/`（700/600）。
- 仓库内只允许 SOPS 密文：
  - `secrets/common/secrets.yaml`（所有机器共享）
  - `secrets/hosts/<identity>/secrets.yaml`（机器专属）
- 解密身份优先复用 SSH key：
  - NixOS/macOS 系统级：`/etc/ssh/ssh_host_ed25519_key`
  - home-manager 用户级（所有平台）：`~/.ssh/id_ed25519`
  - `setup-sops.sh` 会在 NixOS/macOS 上同时登记 host key 与 user key，standalone 只登记 user key
- 初始化：`~/dotfiles/scripts/setup-sops.sh`；从旧位置迁移：`~/dotfiles/scripts/migrate-secrets.sh`。
- pre-commit 已启用 gitleaks / detect-private-keys / no-plaintext-secrets。

## 开发

```bash
nix fmt
nix flake check
nix flake show
```

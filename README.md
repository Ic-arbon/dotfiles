# Dotfiles for Multi-Platform Nix Configuration

## 项目简介

基于 Nix Flakes 的多机器多系统统一配置管理方案，支持 NixOS、macOS 和独立 home-manager 部署。

**核心理念：**
- 多机器多系统同步一套配置，快速移植开发环境
- 不要让命令式部署环境，化作项目伙伴构建失败的泪水
- 不要让处理更新和依赖，化作天天写Dockerfile的汗水

**It works on my machine :)**

## 项目架构

本项目采用模块化架构，支持多种系统配置：

```
dotfiles/
├── hosts/          # 各主机特定配置
│   ├── tydsG16/    # 游戏本 (NixOS)
│   ├── proxy/      # 代理服务器 (NixOS)
│   ├── seafile/    # 文件服务器 (NixOS)
│   ├── macbook-m2/ # MacBook (Darwin)
│   └── steam-deck/ # Steam Deck (独立home-manager)
├── outputs/        # 系统输出配置
├── modules/        # 可复用的功能模块
├── users/          # 用户配置
└── overlays/       # 软件包覆盖
```

## 支持的系统

- **NixOS 系统配置**: tydsG16 (游戏本)、proxy (代理服务器)、seafile (文件服务器)
- **Darwin 系统配置**: macbook-m2 (MacBook)
- **独立 home-manager**: steam-deck (Steam Deck)

每个配置都包含针对特定用途优化的模块组合：
- 桌面环境 (Hyprland + Waybar)
- 开发工具 (Neovim + 嵌入式开发)
- 游戏环境 (Steam + 游戏优化)
- 服务器工具 (基础工具 + 网络配置)

## 安装指南

### 1. 安装 Nix 包管理器

推荐使用 [Determinate Systems](https://zero-to-nix.com/) 的安装脚本，它修复了官方安装脚本的一些问题并默认启用 flakes：

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install 
```

安装完成后，修改 `/etc/nix/nix.conf`，在文件末尾追加：
```
trusted-users = root your_username
```

### 2. 克隆配置仓库

```shell
git clone --recursive https://github.com/Ic-arbon/dotfiles ~/dotfiles
cd ~/dotfiles
```

### 3. 配置个人信息

修改 Git 用户信息：
```shell
~/dotfiles/modules/rename_git.sh
```

### 4. 选择部署方式

根据你的系统类型选择对应的部署命令：

#### NixOS 系统配置 (推荐)

如果你使用 NixOS，可以直接部署系统级配置：

```shell
# 游戏本配置 (包含桌面环境、游戏、开发工具)
sudo nixos-rebuild switch --flake ~/dotfiles#tydsG16

# 代理服务器配置
sudo nixos-rebuild switch --flake ~/dotfiles#proxy

# 文件服务器配置
sudo nixos-rebuild switch --flake ~/dotfiles#seafile
```

#### macOS 系统配置

如果你使用 macOS，需要先安装 nix-darwin：

```shell
# 安装 nix-darwin
nix run nix-darwin -- switch --flake ~/dotfiles#macbook-m2
```

#### 独立 home-manager 配置

适用于非 NixOS/Darwin 系统或仅需要用户级配置：

```shell
# Steam Deck 或其他 Linux 发行版
nix run home-manager/release-24.11 -- switch --flake ~/dotfiles#"deck@steam-deck"

# 通用方式 (需要先创建对应的用户配置)
nix run home-manager/release-24.11 -- switch -b backup --impure --flake ~/dotfiles#your_username
```

> **注意**: 如果是第一次在非 NixOS 系统上使用，可能需要添加 `--impure` 参数。

## 日常使用

### 更新配置

配置文件修改后，使用对应的命令重新部署：

```shell
# NixOS 系统
sudo nixos-rebuild switch --flake ~/dotfiles#your-host

# macOS 系统  
darwin-rebuild switch --flake ~/dotfiles#macbook-m2

# 独立 home-manager
home-manager switch --flake ~/dotfiles#your-config
```

### 使用别名 (推荐)

项目已配置了便捷的别名 `update`，你可以直接使用：

```shell
update  # 等价于对应系统的重新部署命令
```

> **提示**: 如果别名不生效，请手动执行 `source ~/.zshrc` 重新加载配置。

### 添加新主机

1. 在 `hosts/` 目录下创建新主机配置目录
2. 在 `outputs/` 目录下创建对应的输出配置文件  
3. 在 `outputs/default.nix` 中注册新主机

### 自定义模块

所有功能模块位于 `modules/` 目录，你可以：
- 修改现有模块配置
- 添加新的功能模块
- 在主机配置中选择性导入需要的模块

参考 [modules/README.md](modules/README.md) 了解模块开发规范。

## 配置详情

### 主机配置说明

| 主机名称 | 系统类型 | 用途 | 主要模块 |
|---------|----------|------|----------|
| **tydsG16** | NixOS | 游戏本/开发机 | 桌面环境、游戏、开发工具、嵌入式 |
| **proxy** | NixOS | 代理服务器 | 基础工具、网络代理、SSH |
| **seafile** | NixOS | 文件服务器 | 基础工具、文件服务、网络 |
| **macbook-m2** | Darwin | MacBook开发机 | 基础工具、开发环境 |
| **steam-deck** | home-manager | Steam Deck | 游戏相关、基础工具 |

### 模块组合策略

不同类型的主机采用不同的模块组合：

**桌面/游戏机** (tydsG16):
```nix
imports = [
  hyprland waybar theme font fcitx5  # 桌面环境
  browsers electron capture          # 日常应用  
  gaming                            # 游戏环境
  embedded                          # 开发工具
  base-tools shell git astronvim    # 基础工具
];
```

**服务器** (proxy, seafile):
```nix
imports = [
  base-tools shell git astronvim     # 基础工具
  ssh filemanager                   # 服务器必需
  environment-detection              # 环境检测
];
```

**macOS** (macbook-m2):
```nix
imports = [
  base-tools shell git astronvim     # 基础工具
  filemanager                       # 文件管理
];
```

### 技术特性

- **多系统支持**: NixOS、macOS (Darwin)、独立 home-manager
- **模块化设计**: 可选择性导入功能模块
- **环境检测**: 自动适配不同运行环境
- **主题统一**: 使用 Stylix 实现一致的视觉风格
- **开发友好**: 集成 direnv、各种开发工具链
- **游戏优化**: Steam、游戏模式、性能调优

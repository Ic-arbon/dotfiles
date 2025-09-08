# CLAUDE.md

用中文
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个基于 Nix Flakes 的多环境 dotfiles 配置项目，支持 NixOS 系统配置和 Home Manager 用户环境管理。项目设计为智能检测部署环境并自动选择合适的模块配置，实现一套配置多环境部署。

## 常用命令

### Home Manager 相关
```shell
# 更新用户环境配置（有 update 别名）
home-manager switch --flake ~/dotfiles#tyd

# 首次安装 Home Manager
nix run home-manager/release-25.05 -- switch -b backup --impure --flake ~/dotfiles#tyd
```

### NixOS 系统配置
```shell
# 重建 NixOS 系统配置
sudo nixos-rebuild switch --flake ~/dotfiles#tydsG16

# 测试配置不生效
sudo nixos-rebuild test --flake ~/dotfiles#tydsG16

# 重建引导项
sudo nixos-rebuild boot --flake ~/dotfiles#tydsG16
```

### 开发调试
```shell
# 格式化 Nix 代码
nix fmt

# 检查 flake 配置
nix flake check

# 显示 flake 详细信息
nix flake show

# 更新 flake.lock
nix flake update
```

### 环境测试
```shell
# 测试环境检测脚本
nix run ~/dotfiles#test-environment-detection
```

## 架构设计

### 多环境支持
项目支持以下环境类型，通过自动检测机制选择合适的配置：

- **服务器环境**: 无图形界面，仅基础工具和命令行应用
- **NixOS 笔记本**: 完整桌面环境 + Hyprland 窗口管理器
- **ArchLinux 笔记本**: 使用 nixGL 包装器的桌面环境
- **NixOS 桌面**: 桌面环境，不包含笔记本特定功能

### 环境检测机制
通过检查系统文件和硬件设备自动判断环境类型：
- `/etc/nixos` - 检测 NixOS 系统
- `/etc/arch-release` - 检测 ArchLinux 系统  
- `/sys/class/power_supply/BAT*` - 检测笔记本设备
- `/dev/nvidia*` - 检测 NVIDIA 显卡

环境检测逻辑位于 `users/tyd/default.nix:16-28`

### 模块化配置
配置按功能模块化，位于 `modules/` 目录：

**基础模块**:
- `base-tools` - 基础命令行工具
- `shell` - Zsh 配置和插件
- `git` - Git 配置
- `astronvim` - Neovim 配置

**桌面模块**:
- `hyprland` - Wayland 窗口管理器
- `waybar` - 状态栏
- `browsers` - 浏览器配置
- `gaming` - 游戏相关配置

**硬件模块**:
- `bluetooth` - 蓝牙支持
- `fcitx5` - 中文输入法
- `capture` - 截图录屏工具

### Flake 结构
- `flake.nix` - 主入口，定义 inputs 和 outputs
- `outputs/default.nix` - 配置生成逻辑
- `hosts/` - NixOS 系统配置
- `users/` - Home Manager 用户配置  
- `modules/` - 可复用模块
- `overlays/` - 包覆盖

### 关键配置文件
- `users/tyd/default.nix` - 用户配置入口，包含环境检测和模块选择逻辑
- `hosts/tydsG16/default.nix` - NixOS 系统配置入口
- `modules/default.nix` - 模块导出清单
- `outputs/default.nix` - Home Manager 和 NixOS 配置生成

### 智能配置特性
1. **条件化启用**: 根据环境特征启用不同功能（如 nixGL 仅在非NixOS系统启用）
2. **硬件感知**: 自动检测 NVIDIA 显卡等硬件并设置相应环境变量
3. **模块选择**: 根据设备类型（服务器/笔记本/桌面）选择不同模块组合

## 开发注意事项

- 新增模块需要在 `modules/default.nix` 中导出
- 环境特定配置应使用 `lib.mkIf` 条件化启用
- 修改模块选择逻辑在 `users/tyd/default.nix` 中的 `selectedModules`
- NixOS 系统级配置在 `hosts/` 目录下，按主机名组织
- 所有路径使用绝对路径，避免相对路径问题

## 用户配置定制

要添加新用户，需要：
1. 在 `users/` 目录创建用户配置文件
2. 在 `outputs/default.nix` 的 `users` 列表中添加用户名
3. 根据需要修改模块选择逻辑

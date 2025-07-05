# NixOS笔记本部署指南

## 概述
此配置会自动检测NixOS笔记本环境并启用完整的桌面功能，包括图形界面和笔记本特定的功能。

## 自动检测的特性
- 检测到NixOS系统
- 检测到笔记本设备（通过电池检测）
- 检测到图形环境
- 自动检测NVIDIA显卡（如果存在）
- 自动配置为 "nixos-laptop" 模式

## 启用的模块

### 基础模块
- environment-detection（环境检测）
- base-tools（基础工具）
- shell（Shell配置）
- git（Git配置）
- ssh（SSH配置）
- astronvim（Neovim配置）

### 桌面模块
- font（字体配置）
- fcitx5（输入法）
- browsers（浏览器）
- filemanager（文件管理器）
- electron（Electron应用）

### 笔记本特定模块
- bluetooth（蓝牙）
- capture（截图工具）
- gaming（游戏相关）

### 图形界面模块
- hyprland（Wayland窗口管理器）
- waybar（状态栏）
- theme（主题配置）

## 部署步骤

### 1. 克隆配置仓库
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 2. 构建系统配置
```bash
# 构建并应用NixOS配置
sudo nixos-rebuild switch --flake .#tydsG16
```

### 3. 构建用户配置
```bash
# 构建并应用Home Manager配置
nix run github:nix-community/home-manager -- switch --flake .#tyd
```

## 特殊配置

### NVIDIA显卡支持
如果系统有NVIDIA显卡，配置会自动：
- 设置NVIDIA相关环境变量
- 配置适当的硬件加速选项

### 显示器配置
- 优先使用外接显示器（HDMI-A-1）
- 在有外接显示器时禁用内置显示器（eDP-2）
- 自动配置高分辨率显示

### Hyprland配置
- 使用来自inputs的最新Hyprland
- 启用Xwayland支持
- 配置systemd集成

## 环境变量
NixOS笔记本模式下的环境变量：
- `EDITOR=nvim`
- `LANG=zh_CN.UTF-8`
- `LANGUAGE=zh_CN:en_US`
- `XDG_SESSION_TYPE=wayland`
- `XCURSOR_SIZE=16`

### NVIDIA特定环境变量（如果检测到NVIDIA）
- `LIBVA_DRIVER_NAME=nvidia`
- `__GLX_VENDOR_LIBRARY_NAME=nvidia`
- `GBM_BACKEND=nvidia-drm`

## 注意事项
- 确保启用了必要的NixOS模块（如graphics、audio等）
- 如果有多个显示器，可能需要手动调整显示器配置
- 游戏相关功能需要确保系统支持相应的硬件加速 
# ArchLinux笔记本部署指南

## 概述
此配置会自动检测ArchLinux笔记本环境并启用完整的桌面功能，使用nixGL包装器来确保图形应用正常运行。

## 自动检测的特性
- 检测到ArchLinux系统
- 检测到笔记本设备（通过电池检测）
- 检测到图形环境
- 自动检测NVIDIA显卡（如果存在）
- 自动配置为 "archlinux-laptop" 模式

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

### 图形界面模块（使用nixGL包装）
- hyprland（Wayland窗口管理器，nixGL包装）
- waybar（状态栏）
- theme（主题配置）

## 预备步骤

### 1. 安装Nix包管理器
```bash
# 安装Nix包管理器
curl -L https://nixos.org/nix/install | sh

# 启用flakes和nix-command
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### 2. 安装Home Manager
```bash
# 安装Home Manager
nix run github:nix-community/home-manager -- --version
```

## 部署步骤

### 1. 克隆配置仓库
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 2. 构建Home Manager配置
```bash
# 构建并应用Home Manager配置
nix run github:nix-community/home-manager -- switch --flake .#tyd
```

### 3. 重新登录或重新加载Shell
```bash
# 重新加载Shell配置
exec $SHELL
```

## 特殊配置

### nixGL包装器
- 所有图形应用都会自动使用nixGL包装器
- Hyprland使用stable版本并通过nixGL包装
- 确保与ArchLinux的图形驱动兼容

### 显示器配置
- 优先使用外接显示器（HDMI-A-1）
- 内置显示器（eDP-1）配置为高分辨率
- 适配ArchLinux的显示器命名规则

### 环境变量
- 启用genericLinux兼容模式
- 设置nixGL相关环境变量
- 配置Wayland特定设置

## 环境变量
ArchLinux笔记本模式下的环境变量：
- `EDITOR=nvim`
- `LANG=zh_CN.UTF-8`
- `LANGUAGE=zh_CN:en_US`
- `XDG_SESSION_TYPE=wayland`
- `XCURSOR_SIZE=16`
- `NIXOS_OZONE_WL=1`（非NixOS系统特有）

### NVIDIA特定环境变量（如果检测到NVIDIA）
- `LIBVA_DRIVER_NAME=nvidia`
- `__GLX_VENDOR_LIBRARY_NAME=nvidia`
- `GBM_BACKEND=nvidia-drm`

## 故障排除

### 图形应用无法启动
1. 确保安装了必要的图形驱动
2. 检查nixGL是否正确安装
3. 尝试手动用nixGL包装应用

### Hyprland启动失败
1. 检查Wayland支持
2. 确保没有其他窗口管理器在运行
3. 查看Hyprland日志：`journalctl --user -u hyprland`

### 中文输入法问题
1. 确保fcitx5正确安装和配置
2. 检查环境变量设置
3. 重启后重新测试

## 注意事项
- 确保ArchLinux系统已安装基础的图形驱动
- 某些功能可能需要手动安装ArchLinux包作为依赖
- 定期更新nixGL以获得最新的图形支持
- 如果遇到权限问题，可能需要添加用户到相应的组（如video、audio等）

## 与ArchLinux包管理器的集成
- 此配置主要通过Nix管理用户级应用
- 系统级依赖仍然通过pacman管理
- 可以与现有的ArchLinux环境和谐共存 
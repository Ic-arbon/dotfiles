#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash

# 环境检测测试脚本
# 用于验证自动环境检测功能是否正常工作

echo "=== 环境检测测试 ==="
echo

# 检测操作系统
echo "操作系统检测:"
if [[ -f /etc/nixos ]]; then
  echo "✓ 检测到 NixOS"
  OS_TYPE="nixos"
elif [[ -f /etc/arch-release ]]; then
  echo "✓ 检测到 ArchLinux"
  OS_TYPE="archlinux"
else
  echo "? 未知操作系统"
  OS_TYPE="unknown"
fi
echo

# 检测设备类型
echo "设备类型检测:"
if [[ -d /sys/class/power_supply/BAT0 ]] || [[ -d /sys/class/power_supply/BAT1 ]]; then
  echo "✓ 检测到笔记本电脑（有电池）"
  DEVICE_TYPE="laptop"
  HAS_GRAPHICS="true"
else
  echo "✓ 检测到服务器（无电池）"
  DEVICE_TYPE="server"
  HAS_GRAPHICS="false"
fi
echo

# 检测NVIDIA显卡
echo "NVIDIA显卡检测:"
if [[ -e /dev/nvidia0 ]] || [[ -e /proc/driver/nvidia ]]; then
  echo "✓ 检测到NVIDIA显卡"
  HAS_NVIDIA="true"
else
  echo "✗ 未检测到NVIDIA显卡"
  HAS_NVIDIA="false"
fi
echo

# 确定环境配置类型
echo "环境配置类型:"
if [[ "$DEVICE_TYPE" == "server" ]]; then
  PROFILE="server"
  echo "🖥️  服务器环境"
elif [[ "$OS_TYPE" == "nixos" ]]; then
  PROFILE="nixos-laptop"
  echo "💻 NixOS笔记本"
else
  PROFILE="archlinux-laptop"
  echo "💻 ArchLinux笔记本"
fi
echo

# 显示将要启用的模块
echo "将要启用的模块:"
case "$PROFILE" in
  "server")
    echo "  - environment-detection（环境检测）"
    echo "  - base-tools（基础工具 + 文件管理器）"
    echo "  - shell（Shell配置）"
    echo "  - git（Git配置）"
    echo "  - ssh（SSH配置）"
    echo "  - astronvim（Neovim配置）"
    ;;
  "nixos-laptop"|"archlinux-laptop")
    echo "  - environment-detection（环境检测）"
    echo "  - base-tools（基础工具 + 文件管理器）"
    echo "  - shell（Shell配置）"
    echo "  - git（Git配置）"
    echo "  - ssh（SSH配置）"
    echo "  - astronvim（Neovim配置）"
    echo "  - font（字体配置）"
    echo "  - fcitx5（输入法）"
    echo "  - browsers（浏览器）"
    echo "  - filemanager（GUI文件管理器）"
    echo "  - electron（Electron应用）"
    echo "  - bluetooth（蓝牙）"
    echo "  - capture（截图工具）"
    echo "  - gaming（游戏相关）"
    echo "  - graphic-tools（图形工具）"
    echo "  - hyprland（Wayland窗口管理器）"
    echo "  - waybar（状态栏）"
    echo "  - theme（主题配置）"
    ;;
esac
echo

# 显示特殊配置
echo "特殊配置:"
if [[ "$OS_TYPE" != "nixos" ]]; then
  echo "  - 启用nixGL包装器"
  echo "  - 启用genericLinux兼容模式"
fi
if [[ "$HAS_NVIDIA" == "true" ]]; then
  echo "  - 启用NVIDIA环境变量"
fi
if [[ "$HAS_GRAPHICS" == "true" ]]; then
  echo "  - 启用systemd用户服务"
  echo "  - 启用NIXOS_OZONE_WL环境变量"
fi
echo

echo "=== 测试完成 ==="
echo "环境配置类型: $PROFILE"
echo "建议的部署命令:"
case "$PROFILE" in
  "server")
    echo "  nix run github:nix-community/home-manager -- switch --flake .#tyd"
    ;;
  "nixos-laptop")
    echo "  sudo nixos-rebuild switch --flake .#<hostname>"
    echo "  nix run github:nix-community/home-manager -- switch --flake .#tyd"
    ;;
  "archlinux-laptop")
    echo "  # 先安装Nix和Home Manager"
    echo "  nix run github:nix-community/home-manager -- switch --flake .#tyd"
    ;;
esac 
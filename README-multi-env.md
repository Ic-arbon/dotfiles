# 多环境智能部署方案

## 🎯 解决方案概述

这个方案解决了您提到的问题：**让一份NixOS配置在多个不同机器上自动构建出不同的结果，无需手动修改**。

## 🔧 支持的环境

- **🖥️ 服务器** - 无电池设备，基础工具 + 文件管理器
- **💻 NixOS笔记本** - 有电池设备，完整桌面环境，包含游戏功能
- **💻 ArchLinux笔记本** - 有电池设备，使用nixGL的完整桌面环境

## 🚀 快速开始

### 1. 测试环境检测
```bash
# 运行测试脚本查看当前环境
./scripts/test-environment-detection.nix
```

### 2. 部署配置
```bash
# 服务器或ArchLinux笔记本
nix run github:nix-community/home-manager -- switch --flake .#tyd

# NixOS系统
sudo nixos-rebuild switch --flake .#<hostname>
```

## 🧠 核心功能

### 自动环境检测
- ✅ 操作系统类型 (NixOS/ArchLinux)
- ✅ 设备类型 (笔记本/服务器，通过电池检测)
- ✅ NVIDIA显卡检测

### 智能模块选择
- 🔧 服务器：基础工具 + 文件管理器
- 🎮 笔记本：完整功能 + 游戏 + 图形工具
- 🎨 图形：Hyprland + Waybar + 主题

### 条件化配置
- 🔍 nixGL仅在非NixOS上启用
- 🎯 NVIDIA环境变量自动设置
- 🔄 显示器配置自动适配
- 🌐 NIXOS_OZONE_WL在所有Hyprland环境中启用

## 📁 文件结构

```
├── modules/
│   ├── environment-detection.nix    # 环境检测模块
│   ├── base-tools/                  # 基础CLI工具 + 文件管理器
│   ├── graphic-tools/               # 图形界面工具
│   └── ...
├── users/tyd/
│   └── default.nix                  # 智能用户配置
├── examples/                        # 部署示例
│   ├── server-deployment.md
│   ├── nixos-laptop-deployment.md
│   └── archlinux-laptop-deployment.md
├── docs/
│   └── multi-environment-deployment.md  # 详细文档
└── scripts/
    └── test-environment-detection.nix   # 测试脚本
```

## 🔧 自定义配置

### 添加新环境
1. 修改 `modules/environment-detection.nix`
2. 更新 `users/tyd/default.nix` 中的模块组合
3. 测试并验证

### 强制指定环境
```nix
# 如果自动检测不准确，可以强制指定
environment.profile = lib.mkForce "nixos-laptop";
```

## 📖 详细文档

- [📋 完整部署指南](docs/multi-environment-deployment.md)
- [🖥️ 服务器部署](examples/server-deployment.md)  
- [💻 NixOS笔记本部署](examples/nixos-laptop-deployment.md)
- [💻 ArchLinux笔记本部署](examples/archlinux-laptop-deployment.md)

## ✨ 优势

1. **零配置** - 无需手动修改配置文件
2. **自动适应** - 根据环境自动选择功能
3. **模块化** - 易于扩展和维护
4. **一致性** - 所有环境使用相同逻辑
5. **灵活性** - 支持手动覆盖

## 🛠️ 故障排除

```bash
# 查看环境检测结果
./scripts/test-environment-detection.nix

# 强制重新构建
nix run github:nix-community/home-manager -- switch --flake .#tyd --show-trace

# 检查配置语法
nix flake check
```

---

现在您可以在任何支持的环境中部署这个配置，系统会自动检测环境并选择合适的功能，完全无需手动修改！🎉 
# 多环境部署方案

## 概述
此方案实现了一个智能的NixOS配置系统，能够自动检测不同的部署环境并选择合适的模块配置。无需手动修改，一份配置即可在多个不同环境中正常工作。

## 支持的环境

### 1. 服务器环境
- **特征**: 无图形界面，非笔记本设备
- **配置**: 仅启用基础工具和命令行应用
- **模块**: base-tools, shell, git, ssh, astronvim

### 2. NixOS笔记本
- **特征**: NixOS系统，笔记本设备，有图形界面
- **配置**: 完整的桌面环境，包括游戏和多媒体功能
- **模块**: 基础模块 + 桌面模块 + 笔记本模块 + Hyprland

### 3. ArchLinux笔记本
- **特征**: ArchLinux系统，笔记本设备，有图形界面
- **配置**: 使用nixGL包装器的完整桌面环境
- **模块**: 基础模块 + 桌面模块 + 笔记本模块 + Hyprland(nixGL)

### 4. NixOS桌面
- **特征**: NixOS系统，桌面设备，有图形界面
- **配置**: 桌面环境，不包含笔记本特定功能
- **模块**: 基础模块 + 桌面模块 + Hyprland

## 核心技术

### 环境检测机制
系统通过以下方式自动检测环境：

```nix
# 检测操作系统类型
isNixOS = builtins.pathExists /etc/nixos;
isArchLinux = builtins.pathExists /etc/arch-release;

# 检测设备类型
isLaptop = builtins.pathExists "/sys/class/power_supply/BAT0";
hasGraphics = builtins.pathExists "/dev/dri";

# 检测硬件特性
hasNvidia = builtins.pathExists "/dev/nvidia0";
```

### 模块化配置
不同环境使用不同的模块组合：

```nix
selectedModules = 
  if envProfile == "server" then serverModules
  else if envProfile == "nixos-laptop" then laptopModules ++ nixosGraphicsModules
  else if envProfile == "archlinux-laptop" then laptopModules ++ archlinuxGraphicsModules
  else desktopModules ++ nixosGraphicsModules;
```

### 条件化配置
根据环境特征启用不同的功能：

```nix
# 仅在非NixOS系统上启用nixGL
nixGL = lib.mkIf (!envDetection.isNixOS) {
  packages = nixgl.packages;
  defaultWrapper = "mesa";
};

# 仅在有图形环境时启用systemd用户服务
systemd.user.startServices = lib.mkIf envDetection.hasGraphics "sd-switch";
```

## 部署指南

### 快速开始
1. 克隆仓库到 `~/dotfiles`
2. 根据你的环境选择相应的部署方式：
   - 服务器: `nix run github:nix-community/home-manager -- switch --flake .#tyd`
   - NixOS笔记本: `sudo nixos-rebuild switch --flake .#<hostname>`
   - ArchLinux笔记本: 安装Nix后使用Home Manager

### 详细指南
- [服务器部署](../examples/server-deployment.md)
- [NixOS笔记本部署](../examples/nixos-laptop-deployment.md)
- [ArchLinux笔记本部署](../examples/archlinux-laptop-deployment.md)

## 自定义配置

### 添加新的环境类型
1. 在 `environment-detection.nix` 中添加新的检测逻辑
2. 在 `users/tyd/default.nix` 中添加新的模块组合
3. 根据需要创建特定的模块配置

### 修改现有环境的模块
在 `users/tyd/default.nix` 中修改对应的模块列表：

```nix
serverModules = with outputs.homeManagerModules; [
  environment-detection
  base-tools
  shell
  git
  ssh
  astronvim
  # 添加新模块
  your-new-module
];
```

## 环境变量管理

### 通用环境变量
所有环境共享的基础环境变量：
- `EDITOR=nvim`
- `LANG=zh_CN.UTF-8`
- `LANGUAGE=zh_CN:en_US`

### 图形环境变量
仅在有图形界面时设置：
- `XDG_SESSION_TYPE=wayland`
- `XCURSOR_SIZE=16`

### 硬件特定变量
根据检测到的硬件自动设置：
- NVIDIA: `LIBVA_DRIVER_NAME=nvidia`
- 非NixOS: `NIXOS_OZONE_WL=1`

## 故障排除

### 环境检测错误
如果自动检测的环境不正确，可以手动覆盖：

```nix
# 在用户配置中强制指定环境
environment.profile = lib.mkForce "nixos-laptop";
```

### 模块冲突
确保不同环境的模块没有冲突，特别是：
- 图形相关模块只在有图形环境时启用
- nixGL只在非NixOS系统上启用
- 系统级配置只在NixOS上启用

### 调试环境检测
查看当前检测到的环境信息：

```bash
# 构建配置时会显示检测到的环境
nix run github:nix-community/home-manager -- switch --flake .#tyd --show-trace
```

## 优势

1. **零配置**: 无需手动修改配置文件
2. **自动适应**: 根据环境自动选择合适的功能
3. **模块化**: 易于扩展和维护
4. **一致性**: 所有环境使用相同的配置逻辑
5. **灵活性**: 支持手动覆盖自动检测的结果

## 注意事项

- 确保所有目标机器都能访问Nix包管理器
- 某些功能可能需要相应的系统级依赖
- 定期更新配置以获得最新的功能和修复
- 在生产环境中建议先在测试环境验证配置 
# 服务器部署指南

## 概述
此配置会自动检测服务器环境（无图形界面、非笔记本）并仅启用必要的模块。

## 自动检测的特性
- 检测到无图形环境
- 检测到非笔记本设备
- 自动配置为 "server" 模式

## 启用的模块
- environment-detection（环境检测）
- base-tools（基础工具）
- shell（Shell配置）
- git（Git配置）
- ssh（SSH配置）
- astronvim（Neovim配置）

## 部署步骤

### 1. 克隆配置仓库
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 2. 构建Home Manager配置
```bash
# 对于NixOS服务器
sudo nixos-rebuild switch --flake .#<hostname>

# 对于使用Home Manager的情况
nix run github:nix-community/home-manager -- switch --flake .#tyd@<hostname>
```

### 3. 验证配置
配置应该会自动：
- 跳过图形界面相关模块
- 不启用systemd用户服务
- 不配置显示器设置
- 仅安装服务器所需的基础工具

## 环境变量
服务器模式下的环境变量：
- `EDITOR=nvim`
- `LANG=zh_CN.UTF-8`
- `LANGUAGE=zh_CN:en_US`

## 注意事项
- 确保服务器有足够的存储空间用于Nix store
- 如果需要额外的服务器特定工具，可以在 `users/tyd/default.nix` 中的 `serverModules` 列表中添加 
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 构建和部署命令

### 系统构建/重新部署
```bash
# NixOS 系统配置
sudo nixos-rebuild switch --flake ~/dotfiles#tydsG16    # 游戏本配置
sudo nixos-rebuild switch --flake ~/dotfiles#proxy      # 代理服务器配置
sudo nixos-rebuild switch --flake ~/dotfiles#seafile    # 文件服务器配置

# macOS 系统配置
nix run nix-darwin -- switch --flake ~/dotfiles#macbook-m2  # 首次安装
darwin-rebuild switch --flake ~/dotfiles#macbook-m2         # 后续更新

# 独立 home-manager 配置
nix run home-manager/release-24.11 -- switch --flake ~/dotfiles#"deck@steam-deck"
```

### 便捷更新命令
```bash
update  # 使用项目配置的别名，自动选择对应系统的重新部署命令
```

### 开发和调试
```bash
# 格式化 Nix 代码
nix fmt

# 检查 flake 配置
nix flake check

# 更新 flake inputs
nix flake update

# 查看可用的配置
nix flake show
```

## 代码架构

### 整体结构
这是一个基于 Nix Flakes 的多平台统一配置管理系统，支持：
- **NixOS 系统配置**：完整的系统级和用户级配置
- **macOS (Darwin) 配置**：使用 nix-darwin 的 macOS 系统配置  
- **独立 home-manager 配置**：仅用户级配置，适用于非 NixOS/Darwin 系统

### 核心设计模式

1. **模块化架构**：
   - `modules/` 包含所有可复用的功能模块
   - `hosts/` 包含特定主机的配置
   - `outputs/` 定义系统输出配置
   - 通过 `imports` 选择性组合模块

2. **环境检测系统**：
   - `environment-detection.nix` 自动检测运行环境
   - 根据不同环境（NixOS/Darwin/独立 home-manager）调整配置

3. **三层配置结构**：
   ```
   outputs/default.nix → outputs/{host}.nix → hosts/{host}/default.nix
   ```

### 主机配置策略

#### tydsG16 (游戏本/开发机)
- **用途**：桌面环境 + 游戏 + 开发
- **核心模块**：Hyprland、Waybar、Steam、嵌入式开发工具
- **特殊配置**：ASUS 笔记本硬件支持、游戏优化

#### proxy/seafile (服务器)
- **用途**：轻量级服务器环境
- **核心模块**：基础工具、SSH、文件管理
- **特殊配置**：网络服务、系统服务

#### macbook-m2 (macOS)
- **用途**：macOS 开发环境
- **核心模块**：基础开发工具、文件管理
- **限制**：不包含 Linux 特有的桌面环境

#### steam-deck (独立 home-manager)
- **用途**：Steam Deck 用户配置
- **核心模块**：游戏相关、基础工具

### 重要的配置文件

- `flake.nix`：定义所有输入依赖和 nixConfig
- `outputs/default.nix`：导出所有系统配置
- `outputs/common.nix`：共享配置（formatter、overlays）
- `modules/default.nix`：模块导出列表
- `modules/environment-detection.nix`：环境检测逻辑

### 模块开发规范

1. **模块位置**：新模块放在 `modules/` 下
2. **模块注册**：在 `modules/default.nix` 中注册
3. **环境兼容性**：使用环境检测确保跨平台兼容
4. **命名约定**：使用 kebab-case 文件命名

### 用户配置管理

- `users/tyd/`：主用户配置
- `users/deck/`：Steam Deck 用户配置
- 通过 home-manager 管理用户级配置

## 代码规范

### 提交规范
遵循 Conventional Commits：
- `feat(module)`: 新增功能模块
- `fix(host)`: 修复主机配置
- `config(system)`: 系统配置更新
- `docs`: 文档更新

### Nix 代码风格
- 使用 `nix fmt` 自动格式化
- 优先使用 `lib` 函数而不是原始操作
- 模块间通过 `imports` 组合，避免硬编码依赖

### 安全注意事项
- SSH 密钥需要手动生成和配置（`ssh-keygen -t ed25519`）
- 敏感配置使用环境变量或外部文件
- Git 用户信息需要通过 `modules/rename_git.sh` 手动设置
# 模块与 Profile 规范

## 功能模块

- home-manager 模块放在 `modules/`（按需可建子目录），在 `modules/default.nix` 注册。
- NixOS 系统模块放在 `modules/nixos/`，由 `profiles.system.*` 组合。
- 模块内禁止探测构建机（`/etc/nixos`、`/sys`、`/dev`）；需要机器信息时读取 `modules/meta.nix` 声明的 `config.dotfiles.*`。

### 平台差异

需要按 Linux/Darwin 使用不同包实现的模块，使用“同名入口 + common + linux/darwin”结构：

```text
modules/home/<name>/
├── default.nix     # imports = [ ./common.nix ./darwin.nix ./linux.nix ]
├── common.nix      # 跨平台公共配置
├── linux.nix       # lib.mkIf pkgs.stdenv.isLinux { ... }
└── darwin.nix      # lib.mkIf pkgs.stdenv.isDarwin { ... }
```

- profiles/machines 只引用 `<name>`，不知道平台细节；
- 不要用 `pkgs.stdenv` 在 `imports` 里做条件导入（会因 module args 解析产生递归）；
- 平台文件无条件导入，内部用 `lib.mkIf` 控制生效。

```nix
# example.nix
{ config, pkgs, ... }: {
  programs.example = {
    enable = true;
    # 机器差异示例：
    # enableFeature = config.dotfiles.hardware.laptop;
  };

  home.packages = with pkgs; [ hello ];
}
```

## Profile

- 叶子 profile 只导入功能模块；组合 profile 只聚合叶子。
- `home.core` 由 builders 自动注入；`home.platform.*` 由 `identity.kind` 自动注入。
- 新增可复用组合：加 `profiles/default.nix` 即可，不要在 `outputs/default.nix` 或共享模块里加机器分支。

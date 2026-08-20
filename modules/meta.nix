# 机器身份与事实的唯一来源。
# machines/<username>@<hostname>.nix 通过 module 把这些值注入到 NixOS/darwin/home-manager 配置中。
{
  config,
  lib,
  ...
}:
with lib; {
  options.dotfiles = {
    machine = {
      identity = mkOption {
        type = types.str;
        description = "全局唯一身份键，格式 username@hostname";
      };
      username = mkOption {
        type = types.str;
        description = "登录用户名";
      };
      hostname = mkOption {
        type = types.str;
        description = "主机名";
      };
      system = mkOption {
        type = types.str;
        description = "目标系统（如 x86_64-linux）";
      };
      kind = mkOption {
        type = types.enum ["nixos" "darwin" "standalone"];
        description = "部署形态：NixOS / nix-darwin / 独立 home-manager";
      };
    };

    hardware = {
      laptop = mkEnableOption "whether this is a laptop";
      nvidia = mkEnableOption "whether this machine has an NVIDIA GPU";
    };

    desktop = {
      monitor = mkOption {
        type = types.str;
        default = ",preferred,auto,auto";
        description = "Hyprland 显示器规则，由机器清单提供";
      };
    };

    secretsDir = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "仓库外的明文密钥目录（sops-nix 接管前为兼容保留）";
    };

    secrets = {
      commonFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "所有机器共享的 SOPS 密文（secrets/common/secrets.yaml）";
      };
      hostFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "当前机器专属的 SOPS 密文（secrets/hosts/<identity>/secrets.yaml）";
      };
    };

    sops = {
      enable = mkEnableOption "sops-nix encrypted secrets in repo";
    };
  };
}

# tyd 的机器无关 home-manager 基础配置。
# 机器差异只通过 dotfiles.machine / dotfiles.hardware 等 options 读取，
# 不要在这里探测 /etc、/sys、/dev 或写死用户名。
{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.home-manager.enable = true;
  programs.git.enable = true;

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    zsh.enable = true;
  };

  home.sessionVariables =
    {
      EDITOR = "nvim";
      LANG = "zh_CN.UTF-8";
      LANGUAGE = "zh_CN:en_US";
    }
    // lib.optionalAttrs config.dotfiles.hardware.nvidia {
      # NVIDIA 相关
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    }
    // lib.optionalAttrs (config.dotfiles.machine.kind == "darwin") {
      CLAUDE_CODE_MAX_OUTPUT_TOKENS = "64000";
    };

  xdg.enable = true;

  # macOS 上没有 user systemd
  systemd.user.startServices =
    lib.mkIf (config.dotfiles.machine.kind != "darwin") "sd-switch";
}

{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    # 桌面 profile（hyprland 等）可以用更高优先级覆盖为 stable/nixGL 版本
    package = lib.mkDefault (config.lib.nixGL.wrap pkgs.ghostty);
    enableZshIntegration = true;
  };
}

{
  config,
  pkgs,
  ...
}: let
  # 部署形态由 machines 注入，不探测构建机文件系统
  isNixOS = config.dotfiles.machine.kind == "nixos";
in {
  # Screenshot
  # home.packages = with pkgs; [ wl-clipboard flameshot hyprshot ];

  # Video Record
  programs.obs-studio = {
    enable = true;
    package =
      if isNixOS
      then pkgs.obs-studio
      else (config.lib.nixGL.wrap pkgs.obs-studio);
    plugins = with pkgs; [
      obs-studio-plugins.wlrobs
      obs-studio-plugins.obs-vkcapture
      obs-studio-plugins.input-overlay
      obs-studio-plugins.obs-gstreamer
    ];
  };
}

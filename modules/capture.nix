{
  config,
  pkgs,
  ...
}:
let
  # 直接进行环境检测，避免循环依赖
  isNixOS = builtins.pathExists /etc/nixos;
  isArchLinux = builtins.pathExists /etc/arch-release;
  isLaptop = builtins.pathExists "/sys/class/power_supply/BAT0" ||
             builtins.pathExists "/sys/class/power_supply/BAT1";
  hasNvidia = builtins.pathExists "/dev/nvidia0" ||
              builtins.pathExists "/proc/driver/nvidia";
in
{
  # Screenshot
  # home.packages = with pkgs; [ wl-clipboard flameshot hyprshot ];

  # Video Record
  programs.obs-studio = {
    enable = true;
    package = if isNixOS 
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

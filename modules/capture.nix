{
  config,
  pkgs,
  ...
}:
{
  # Screenshot
  home.packages = with pkgs; [ wl-clipboard flameshot hyprshot ];

  # Video Record
  programs.obs-studio = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.obs-studio);
    plugins = with pkgs; [
      obs-studio-plugins.wlrobs
      obs-studio-plugins.obs-vkcapture
      obs-studio-plugins.input-overlay
      obs-studio-plugins.obs-gstreamer
    ];
  };
}

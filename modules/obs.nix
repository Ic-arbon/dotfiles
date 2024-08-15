{ config, pkgs, ... }:
{
  programs.obs-studio = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.obs-studio);
    plugins = with pkgs; [
      obs-studio-plugins.wlrobs
      obs-studio-plugins.input-overlay 
    ];
  };
}

{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";
    settings = import ./config.nix;
    style = ./style.css;
  };
}

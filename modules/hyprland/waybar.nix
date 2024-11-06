{ pkgs, pkgs-stable, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";
    # systemd.target = "";
    settings = import ./conf/waybar/config.nix;
    style = ./conf/waybar/style.css;
  }; 

  # home.packages = [
  # ];
}

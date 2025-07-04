{ lib, pkgs, pkgs-unstable, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs-unstable.waybar;
    # systemd.enable = true;
    # systemd.target = "hyprland-session.target";
    # systemd.target = "";
    settings = import ./conf/waybar/config.nix;
    style = lib.mkForce (./conf/waybar/style.css);
  }; 

  # home.packages = [
  # ];
}

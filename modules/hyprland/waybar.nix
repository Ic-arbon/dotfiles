{ lib, pkgs, pkgs-unstable, pkgs-stable, ... }:
let
  isNixOS = builtins.pathExists /etc/nixos;
in
{
  programs.waybar = {
    enable = true;
    package = if isNixOS then pkgs.waybar else pkgs-unstable.waybar;
    # systemd.enable = if isNixOS then true else;
    # systemd.target = if isNixOS then "hyprland-session.target" else;
    # systemd.target = "";
    settings = import ./conf/waybar/config.nix;
    style = lib.mkForce (./conf/waybar/style.css);
  }; 

  # home.packages = [
  # ];
}

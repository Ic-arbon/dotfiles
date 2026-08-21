{
  lib,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = import ./conf/waybar/config.nix;
    style = lib.mkForce (./conf/waybar/style.css);
  };

  # home.packages = [
  # ];
}

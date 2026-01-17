{ config, pkgs, pkgs-stable, pkgs-unstable, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  home.packages =
    # Cross-platform defaults
    (with pkgs; [
      mpv
    ])
    # Platform-specific additions
    ++ (if isDarwin then (with pkgs; [
      vlc
      zotero
      # Darwin: drop gtk apps (pavucontrol), nixGL-wrapped programs, and Linux-only wemeet
      # Avoid pulling gtk+3/libcanberra on macOS
    ]) else (with pkgs; [
      (config.lib.nixGL.wrap pkgs-unstable.qcm)
      vlc
      zotero
      pkgs.nur.repos.novel2430.wemeet-bin-bwrap-wayland-screenshare
      libreoffice-bin
      stirling-pdf
      bluetuith
      pavucontrol
      qemu
    ]));
} 

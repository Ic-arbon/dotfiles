# graphic-tools Linux 专属包
{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = lib.mkIf pkgs.stdenv.isLinux (with pkgs; [
    vlc
    zotero
    libreoffice
    stirling-pdf
    bluetuith
    pavucontrol
    qemu
  ]);
}

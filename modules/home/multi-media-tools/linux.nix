# multi-media-tools Linux 专属包
{
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.mkIf pkgs.stdenv.isLinux (with pkgs; [
    vlc
  ]);
}

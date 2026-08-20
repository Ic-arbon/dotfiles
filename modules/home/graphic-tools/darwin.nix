# graphic-tools Darwin 专属包
{
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.mkIf pkgs.stdenv.isDarwin (with pkgs; [
    vlc-bin
    zotero
    libreoffice-bin
  ]);
}

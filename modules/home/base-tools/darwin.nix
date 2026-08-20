# base-tools Darwin 专属包
{
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.mkIf pkgs.stdenv.isDarwin (with pkgs; [
    keycastr
  ]);
}

# browsers Darwin 包选择：避免从源码构建 Firefox/GTK stack
{
  lib,
  pkgs,
  pkgs-stable,
  ...
}: {
  programs.firefox.package = lib.mkIf pkgs.stdenv.isDarwin (
    lib.mkDefault pkgs-stable.firefox-bin
  );
}

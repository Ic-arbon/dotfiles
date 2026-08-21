# browsers Linux 包选择：NixOS / standalone Linux 统一使用源码包。
# standalone 的 GPU 驱动由 targets.genericLinux.gpu 提供，无需 nixGL wrap。
{
  lib,
  pkgs,
  ...
}: {
  programs.firefox.package = lib.mkIf pkgs.stdenv.isLinux (
    lib.mkDefault pkgs.firefox
  );
}

# Ghostty Linux 专属：NixOS / standalone Linux 统一使用 nixpkgs 源码包。
{
  lib,
  pkgs,
  ...
}: {
  programs.ghostty = {
    package = lib.mkIf pkgs.stdenv.isLinux (lib.mkDefault pkgs.ghostty);
    # Linux 目前没遇到透明导致的残留，先保持透明；默认 0.9，Stylix 可覆盖。
    settings.background-opacity = lib.mkIf pkgs.stdenv.isLinux (lib.mkDefault 0.9);
  };
}

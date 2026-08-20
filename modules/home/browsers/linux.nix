# browsers Linux 包选择：NixOS 用源码包，standalone Linux 用 nixGL 包装的 bin
{
  config,
  lib,
  pkgs,
  ...
}: let
  isNixOS = config.dotfiles.machine.kind == "nixos";
in {
  programs.firefox.package = lib.mkIf pkgs.stdenv.isLinux (
    lib.mkDefault (
      if isNixOS
      then pkgs.firefox
      else config.lib.nixGL.wrap pkgs.firefox-bin
    )
  );
}

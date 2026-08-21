{
  lib,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    # macOS 使用官方 dmg 的 ghostty-bin；Linux 使用 nixpkgs 源码包。
    package = lib.mkDefault (
      if pkgs.stdenv.hostPlatform.isDarwin
      then pkgs.ghostty-bin
      else pkgs.ghostty
    );
    enableZshIntegration = true;
  };
}

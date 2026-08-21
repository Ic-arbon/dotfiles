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
    settings = {
      # 固定字号，避免 Stylix 在 macOS 上放大到 21.33pt。
      font-size = lib.mkForce 16;
      # 关闭透明背景，避免 GPU 终端在换行/重绘时出现残留与撕裂。
      background-opacity = lib.mkForce 1;
    };
  };
}

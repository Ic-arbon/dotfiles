# Ghostty Darwin 专属：官方 dmg 的 ghostty-bin + 半透明背景（关闭窗口阴影）。
{
  lib,
  pkgs,
  ...
}: {
  programs.ghostty = {
    # macOS 使用官方 dmg 的 ghostty-bin。
    package = lib.mkIf pkgs.stdenv.isDarwin (lib.mkDefault pkgs.ghostty-bin);

    settings = {
      # 使用 ghostty 自身的背景透明度 0.9（90% 不透明）。
      background-opacity = lib.mkIf pkgs.stdenv.isDarwin (lib.mkForce 0.9);
      # 不启用 macOS 原生玻璃/毛玻璃，仅用 ghostty 的背景透明度。
      background-blur = lib.mkIf pkgs.stdenv.isDarwin (lib.mkForce 0);
      # 关闭 macOS 窗口阴影，避免半透明/高透明下出现重绘残留。
      macos-window-shadow = lib.mkIf pkgs.stdenv.isDarwin false;
    };
  };
}

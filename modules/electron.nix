{ config, pkgs, ... }:
# fix fcitx5 in electron apps for wayland 
# https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#Chromium_.2F_Electron
let
  # 原始obsidian包
  obsidianOriginal = pkgs.obsidian;
  
  # 自定义桌面文件
  obsidianDesktop = pkgs.makeDesktopItem {
    name = "obsidian";
    desktopName = "Obsidian (Wayland)";
    # exec = "${obsidianOriginal}/bin/obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime %U";
    exec = "${obsidianOriginal}/bin/obsidian %U";
    icon = "obsidian";
    terminal = false;
    categories = ["Office"];
    mimeTypes = [];
  };

  # 修改后的obsidian包
  obsidianWithCustomDesktop = pkgs.symlinkJoin {
    name = "obsidian-wayland";
    paths = [ obsidianOriginal ];
    buildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      # 删除原版desktop文件
      rm -f $out/share/applications/obsidian.desktop
      # 安装自定义desktop文件
      cp ${obsidianDesktop}/share/applications/*.desktop $out/share/applications/
      wrapProgram $out/bin/obsidian \
        --add-flags --enable-features=UseOzonePlatform \
        --add-flags --ozone-platform=wayland \
        --add-flags --enable-wayland-ime \
        # --add-flags --gtk-version=4
    '';
  };
in
{
  home.packages = [
    obsidianWithCustomDesktop
  ];
}

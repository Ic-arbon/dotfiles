{ config, pkgs, pkgs-unstable, ... }:
# fix fcitx5 in electron apps for wayland 
# https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#Chromium_.2F_Electron
let
  # 原始obsidian包
  obsidianOriginal = pkgs.obsidian;
  
  # 自定义桌面文件
  obsidianDesktop = pkgs.makeDesktopItem {
    name = "obsidian";
    desktopName = "Obsidian (Wayland)";
    exec = "${obsidianOriginal}/bin/obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime %U";
    # exec = "${obsidianOriginal}/bin/obsidian %U";
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
    '';
  };

  cursorOriginal = pkgs-unstable.code-cursor;
  
  cursorDesktop = pkgs.makeDesktopItem {
    name = "cursor";
    desktopName = "cursor (Wayland)";
    exec = "${cursorOriginal}/bin/cursor --enable-features=UseOzonePlatform --ozone-platform=x11 --enable-wayland-ime %U";
    # exec = "${cursorOriginal}/bin/cursor %U";
    icon = "cursor";
    terminal = false;
    categories = [""];
    mimeTypes = [];
  };

  cursorWithCustomDesktop = pkgs.symlinkJoin {
    name = "cursor-wayland";
    paths = [ cursorOriginal ];
    buildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      # 删除原版desktop文件
      rm -f $out/share/applications/cursor.desktop
      # 安装自定义desktop文件
      cp ${cursorDesktop}/share/applications/*.desktop $out/share/applications/
      wrapProgram $out/bin/cursor \
        --add-flags --enable-features=UseOzonePlatform \
        --add-flags --ozone-platform=x11 \
        --add-flags --enable-wayland-ime \
    '';
  };
in
{
  home.packages = [
    obsidianWithCustomDesktop
    cursorWithCustomDesktop
  ];
}

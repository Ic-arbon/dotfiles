{ config, pkgs, ... }:
# fix fcitx5 in electron apps for wayland 
# https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#Chromium_.2F_Electron
{
  home.packages = with pkgs; [
    (pkgs.symlinkJoin {
      name = "obsidian";
      paths = [ pkgs.obsidian ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/obsidian \
        --add-flags --enable-features=UseOzonePlatform \
        --add-flags --ozone-platform=wayland \
        --add-flags --enable-wayland-ime  \
      '';
    })
  ];
}

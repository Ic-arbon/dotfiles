{ config, pkgs, ... }:
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

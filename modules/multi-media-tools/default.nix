{ config, pkgs, pkgs-stable, pkgs-unstable, ... }:{
  home.packages = with pkgs; [
    # multimedia player
    vlc-bin
    mpv

    # multimedia tools
    # losslesscut-bin
    # (config.lib.nixGL.wrap pkgs.kdePackages.kdenlive)
    # gimp-with-plugins

    # DAW
    reaper
    # reaper-sws-extension
    # reaper-reapack-extension
  ];
} 

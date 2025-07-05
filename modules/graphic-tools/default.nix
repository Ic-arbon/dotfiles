{ config, pkgs, pkgs-stable, pkgs-unstable, ... }:{
  home.packages = with pkgs; [
    # multimedia player
    (config.lib.nixGL.wrap pkgs.qcm)
    # waylyrics
    # vlc

    # office
    qq
    # libreoffice-qt
    # wpsoffice
    # nur.repos.rewine.ttf-wps-fonts
    # nur.repos.novel2430.wpsoffice
    # nur.repos.novel2430.wpsoffice-365
    # (config.lib.nixGL.wrap pkgs.nur.repos.linyinfeng.wemeet)
    (config.lib.nixGL.wrap pkgs-unstable.wemeet)
    
    # multimedia tools
    # losslesscut-bin
    # (config.lib.nixGL.wrap pkgs.kdePackages.kdenlive)
    # gimp-with-plugins

    # peripheral controller
    # bluetuith
    # pavucontrol
    # solaar

    # theme
    # libsForQt5.qtstyleplugins
    # libsForQt5.qt5ct
    # lxappearance

    # misc
    # screenkey
    # rustdesk
    # betaflight-configurator

    # network tools
    # wireshark
    # v2raya
    # v2ray
  ];
} 
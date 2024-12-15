{ config, pkgs, ... }:{
  home.packages = with pkgs; [
    bat
    htop
    tree
    neofetch
    git
    tig
    btdu

    # unarchiver
    gzip
    unzip
    unrar

    # network tools
    bind
    nload
    wireshark
    # v2raya
    # v2ray

    # peripheral controller
    bluetuith
    pavucontrol
    solaar

    # multimedia tools
    ffmpeg
    losslesscut-bin
    (config.lib.nixGL.wrap pkgs.kdePackages.kdenlive)
    gimp-with-plugins

    # multimdia player
    go-musicfox
    (config.lib.nixGL.wrap pkgs.qcm)
    waylyrics
    vlc

    # office
    qq
    (config.lib.nixGL.wrap pkgs.nur.repos.linyinfeng.wemeet)

    # gaming
    steam
    protonplus
    mangohud

    # theme
    libsForQt5.qtstyleplugins
    libsForQt5.qt5ct
    lxappearance

    # misc
    screenkey
    axel
    qemu
  ];
}

{ config, pkgs, pkgs-stable, ... }:{
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
    p7zip
    unzip
    unrar

    # network tools
    bind
    nload
    # wireshark
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
    libreoffice-qt
    # wpsoffice
    # nur.repos.rewine.ttf-wps-fonts
    # nur.repos.novel2430.wpsoffice
    # nur.repos.novel2430.wpsoffice-365
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

    # ebook reader
    bk
    epr
  ];

  programs.aria2 ={
    enable = true;
    # settings = {
    #   listen-port = 60000;
    #   dht-listen-port = 60000;
    #   seed-ratio = 1.0;
    #   max-upload-limit = "50K";
    #   ftp-pasv = true;
    # };

  };
}

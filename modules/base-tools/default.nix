{ config, pkgs, pkgs-stable, pkgs-unstable, ... }:{
  home.packages = with pkgs; [
    # basic CLI tools
    bat
    htop
    tree
    neofetch
    git
    tig
    btdu
    pkgs-unstable.claude-code

    # unarchiver
    gzip
    p7zip
    unzip
    unrar

    # network tools
    bind
    ethtool
    nload

    # multimedia tools
    ffmpeg

    # CLI multimedia player
    go-musicfox

    # file manager
    ranger

    # office
    pkgs-stable.qq
    discord
    libreoffice-qt
    # wpsoffice
    # nur.repos.rewine.ttf-wps-fonts
    # nur.repos.novel2430.wpsoffice
    # nur.repos.novel2430.wpsoffice-365
    # (config.lib.nixGL.wrap pkgs.nur.repos.linyinfeng.wemeet)

    # misc
    axel

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

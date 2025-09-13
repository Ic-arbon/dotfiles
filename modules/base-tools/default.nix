{ config, pkgs, pkgs-stable, pkgs-unstable, ... }:{
  home.packages = with pkgs; [
    # basic CLI tools
    bat
    htop
    tree
    neofetch
    git
    tig
    # btdu

    # unarchiver
    gzip
    p7zip
    unzip
    unrar

    # network tools
    bind
    # ethtool
    nload

    # multimedia tools
    ffmpeg

    # CLI multimedia player
    pkgs-unstable.go-musicfox

    # file manager
    ranger

    # dev tools
    pkgs-unstable.claude-code

    # office
    # pkgs-stable.qq
    discord
    libreoffice-bin
    # (config.lib.nixGL.wrap pkgs.nur.repos.linyinfeng.wemeet)

    # misc
    axel

    # ebook reader
    bk
    epr
  ];

  programs.kitty = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs-stable.kitty);
    # settings = {
    #   background_opacity = "0.9";
    # };
    themeFile = "GruvboxMaterialDarkHard";
    # font.name = "FiraCode Nerd Font";
    # font.size = 16;
  };
  
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

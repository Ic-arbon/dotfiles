{ config, lib, pkgs, pkgs-stable, pkgs-unstable, ... }:{
  home.packages = with pkgs; [
    # basic CLI tools
    bat
    htop
    tree
    neofetch
    git
    tig
    tio

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
    # pkgs-unstable.codex
    pkgs-unstable.claude-code
    nodejs

    # office
    # pkgs-stable.qq
    # (config.lib.nixGL.wrap pkgs.nur.repos.linyinfeng.wemeet)

    # misc
    axel

    # ebook reader
    bk
    epr
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    btdu
    qemu
  ];

  programs.kitty = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.kitty);
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

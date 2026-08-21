# base-tools 跨平台公共部分
{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    # basic CLI tools
    bat
    coreutils
    htop
    btop
    tree
    neofetch
    git
    tig
    tio
    minicom
    baobab

    # unarchiver
    gzip
    p7zip
    unzip
    unrar

    # network tools
    bind
    nmap
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

    # office
    # pkgs.qq
    # pkgs.nur.repos.linyinfeng.wemeet

    # misc
    axel
    marp-cli

    # ebook reader
    bk
    epr
  ];

  programs.aria2 = {
    enable = true;
  };
}

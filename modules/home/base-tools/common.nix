# base-tools 跨平台公共部分
{
  config,
  lib,
  pkgs,
  pkgs-stable,
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
    nodejs

    # office
    # pkgs-stable.qq
    # (config.lib.nixGL.wrap pkgs.nur.repos.linyinfeng.wemeet)

    # misc
    axel
    marp-cli

    # ebook reader
    bk
    epr
  ];

  programs.kitty = {
    enable = true;
    # 桌面 profile（hyprland 等）可以用更高优先级覆盖为 stable/nixGL 版本
    package = lib.mkDefault (config.lib.nixGL.wrap pkgs.kitty);
    themeFile = "GruvboxMaterialDarkHard";
  };

  programs.aria2 = {
    enable = true;
  };
}

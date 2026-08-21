# base-tools 跨平台公共部分
{
  config,
  lib,
  pkgs,
  pkgs-stable,
  pkgs-unstable,
  nixgl,
  ...
}: {
  # standalone（非 NixOS）上 nixGL.wrap 才有意义；NixOS 上 wrap 为恒等。
  # specialArgs 里的 nixgl.packages 必须显式喂给 nixGL.packages option，
  # 否则该 option 为 null，config.lib.nixGL.wrap 退化为不包装（EGL 崩溃根因）。
  nixGL = lib.mkDefault {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
  };
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

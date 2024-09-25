# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  # isLinux = pkgs.stdenv.hostPlatform.isLinux;
  # isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  # unsupported = builtins.abort "Unsupported platform";
  homeDir = "${config.home.homeDirectory}";
  dotfileDir = "$HOME/dotfiles";
  # stuffDir =
  #   if isLinux then "/stuff" else
  #   if isDarwin then "${homeDir}/stuff" else unsupported;
  # hmDir = "${stuffDir}/nix/home-manager";
  nixGLIntel = inputs.nixGL.packages."${pkgs.system}".nixGLIntel;
in {
  # TODO: Set your username
  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    # if isLinux then "/home/deck" else
    # if isDarwin then "/Users/deck" else unsupported;
  };

  # You can import other home-manager modules here
  imports =
    [
      (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
        sha256 = "01dkfr9wq3ib5hlyq9zq662mp0jl42fw3f6gd2qgdf8l8ia78j7i";
      })
      # If you want to use modules your own flake exports (from modules/home-manager):
      # outputs.homeManagerModules.example

      # Or modules exported from other flakes (such as nix-colors):
      # inputs.nix-colors.homeManagerModules.default

      # You can also split up your configuration and import pieces of it here:
      # ./nvim.nix
    ]
    # 导入所有模块
    ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.nur-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  home.packages = with pkgs; [
    # Common packages
    bat
    neofetch
    v2raya
    v2ray
    ffmpeg
    vlc
    go-musicfox
    waylyrics
    screenkey
    tig
    commitizen
    btdu
    axel
    obsidian
    wireshark
    # GNU/Linux packages
    bind
    traceroute
    nload
    bluetuith
    qq
    onlyoffice-bin_latest
    solaar
    avidemux
    obexd
    protonplus
    (config.lib.nixGL.wrap pkgs.qcm)
    (config.lib.nixGL.wrap pkgs.octaveFull)
    (config.lib.nixGL.wrap pkgs.freecad)
    (config.lib.nixGL.wrap pkgs.kdePackages.kdenlive)
    # glibc
    libsForQt5.krdc
    libsForQt5.krfb
    libsForQt5.qtstyleplugins
    libsForQt5.qt5ct
    lxappearance
    # macOS packages
    gnused
  ];

  nixGL.prefix = "${nixGLIntel}/bin/nixGLIntel";

  # Enable home-manager, git, and direnv
  programs.home-manager.enable = true;
  programs.git.enable = true;
  # ...other config, other config...
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    zsh.enable = true; # see note on other shells below
  };

  # home.language = {
  #   base = "zh_CN.UTF-8";
  # };

  xresources.properties = {
    # "Xft.dpi" = 144;
  };

  home.activation = {
    # OUT OF DATE
    rename = lib.hm.dag.entryBefore ["writeBoundary"] ''
      $DRY_RUN_CMD $HOME/dotfiles/modules/rename_git.sh
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    LANG = "zh_CN.UTF-8";
    LANGUAGE = "zh_CN:en_US";
  };

  # Misc
  # xdg.enable=true;
  # xdg.mime.enable=true;

  #让home-manager在非NixOS下更好地工作，能让kde集成桌面应用
  targets.genericLinux.enable = true;
  home.file.".local/share/applications" = {
    # enable = false;
    source = ~/.nix-profile/share/applications;
    recursive = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}

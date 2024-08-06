# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # TODO: Set your username
  home = {
    username = "deck";
    homeDirectory = "/home/deck";
  };

  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    # outputs.homeManagerModules.git
    # outputs.homeManagerModules.shells
    # outputs.homeManagerModules.ssh # 不能全自动化部署，需要ssh-keygen -t ed25519，并上传公钥
    # outputs.homeManagerModules.ranger
    # outputs.homeManagerModules.astronvim
    # outputs.homeManagerModules.firefox

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ]++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

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
    go-musicfox
    spotify
    # GNU/Linux packages
    bind
    nload
    bluetuith
    # macOS packages
    gnused
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shellAliases = {
    ls = "ls --color=auto";
    ll = "ls -lah";
    ra = "ranger";
    lg = "lazygit";
    #gst = "git status";
    #gp = "git pull";
    #gco = "git checkout";
    update = "home-manager switch";
  };

  # Misc
  # xdg.enable=true;
  # xdg.mime.enable=true;

  #让home-manager在非NixOS下更好地工作，能让kde集成桌面应用
  targets.genericLinux.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}

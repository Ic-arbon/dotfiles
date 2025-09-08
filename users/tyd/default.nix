# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-stable,
  nixgl,
  ...
}: let
  homeDir = "${config.home.homeDirectory}";
  dotfileDir = "$HOME/dotfiles";
  
  # 直接在这里进行环境检测，避免循环依赖
  isNixOS = builtins.pathExists /etc/nixos;
  isArchLinux = builtins.pathExists /etc/arch-release;
  isLaptop = builtins.pathExists "/sys/class/power_supply/BAT0" ||
             builtins.pathExists "/sys/class/power_supply/BAT1";
  hasNvidia = builtins.pathExists "/dev/nvidia0" ||
              builtins.pathExists "/proc/driver/nvidia";
  
  # 根据检测结果确定环境类型
  envProfile = 
    if !isLaptop then "server"
    else if isNixOS then "nixos-laptop"
    else "archlinux-laptop";
  
  # 定义不同环境的模块集合
  serverModules = with outputs.homeManagerModules; [
    environment-detection
    base-tools
    filemanager
    shell
    git
    ssh
    astronvim
  ];
  
  laptopModules = with outputs.homeManagerModules; [
    environment-detection
    embedded
    base-tools
    shell
    git
    ssh
    astronvim
    font
    fcitx5
    browsers
    filemanager
    electron
    bluetooth
    capture
    dae
    gaming
    graphic-tools
    hyprland
    waybar
    theme
  ];
  
  # 根据环境选择模块
  selectedModules = 
    if envProfile == "server" then serverModules
    else laptopModules; # nixos-laptop 或 archlinux-laptop
    
in {
  home = {
    username = "tyd";
    homeDirectory = "/home/tyd";
  };


  # 根据环境动态导入模块
  imports = selectedModules;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages
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

  # 只在非NixOS系统上启用nixGL
  nixGL = lib.mkIf (!isNixOS) {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
  };

  # Enable home-manager, git, and direnv
  programs.home-manager.enable = true;
  programs.git.enable = true;
  
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zsh.enable = true;
  };

  home.activation = {
    # OUT OF DATE
    rename = lib.hm.dag.entryBefore ["writeBoundary"] ''
      $DRY_RUN_CMD $HOME/dotfiles/modules/rename_git.sh
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "zh_CN.UTF-8";
    LANGUAGE = "zh_CN:en_US";
  } // lib.optionalAttrs hasNvidia {
    # NVIDIA相关环境变量
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Misc
  xdg.enable = true;

  # 只在非NixOS系统上启用 genericLinux
  targets.genericLinux.enable = lib.mkIf (!isNixOS) true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}

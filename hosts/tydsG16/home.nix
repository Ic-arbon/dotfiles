{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = with outputs.homeManagerModules; [
    # 基础工具
    environment-detection
    base-tools
    shell
    git
    ssh
    astronvim
    filemanager
    
    # 开发环境（G16是开发机）
    embedded
    
    # 桌面环境（笔记本需要）
    hyprland
    waybar
    theme
    font
    fcitx5
    browsers
    electron
    bluetooth
    capture
    graphic-tools
    
    # 游戏（G16是游戏本）
    gaming
    
    # 网络工具
    dae
  ];

  home = {
    username = "tyd";
    homeDirectory = "/home/tyd";
    stateVersion = "25.05";
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

  # G16特定配置
  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "zh_CN.UTF-8";
    LANGUAGE = "zh_CN:en_US";
    # NVIDIA相关
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Misc
  xdg.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
{ inputs, outputs, lib, config, pkgs, nixgl, ... }: {
  imports = with outputs.homeManagerModules; [
    # 基础工具
    shell
    git
    astronvim
    base-tools
    filemanager
    font
    dae

    # Steam Deck特定需求
    # 不需要完整的桌面环境（因为SteamOS有自己的桌面）
  ];

  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    stateVersion = "24.11";  # 保持现有版本
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

  # Steam Deck特定配置
  nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
  };

  # 为非NixOS系统启用
  targets.genericLinux.enable = true;
  
  # Steam Deck特定的桌面集成 - 让 KDE 检测到 nix 安装的应用
  xdg.desktopEntries = {}; # 确保 xdg.dataHome 生效
  home.file.".local/share/applications/nix-apps" = {
    source = "${config.home.profileDirectory}/share/applications";
    recursive = true;
  };

  # Steam Deck特定的包
  home.packages = with pkgs; [
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "zh_CN.UTF-8";
    LANGUAGE = "zh_CN:en_US";
  };

  # Misc
  xdg.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

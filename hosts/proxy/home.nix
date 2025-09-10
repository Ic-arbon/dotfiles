{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = with outputs.homeManagerModules; [
    # 服务器基础工具
    environment-detection
    base-tools
    shell
    git
    ssh
    astronvim
    filemanager
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

  # 服务器环境变量
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
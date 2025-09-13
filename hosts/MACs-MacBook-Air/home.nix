{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = with outputs.homeManagerModules; [
    # 基础工具
    shell
    git
    astronvim
    base-tools
    filemanager
    browsers
    theme
    
    # 开发工具（macOS开发机）
    # embedded  # macOS可能不需要嵌入式开发工具
  ];

  home = {
    username = "tyd";
    homeDirectory = "/Users/tyd";
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
  
  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "zh_CN.UTF-8";
    LANGUAGE = "zh_CN:en_US";
  };

  xdg.enable = true;

}

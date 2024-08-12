{
  programs.bash = {
    #enable = true;	# 导致Steamdeck切换桌面模式时ksplashqml崩溃
    bashrcExtra = ''
      export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        # "docker-compose"
        # "docker"
      ];
      theme = "robbyrussell";
    };
    initExtra = ''
      bindkey '^f' autosuggest-accept
      export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}

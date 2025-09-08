let
  dotfileDir = "$HOME/dotfiles";
in 
{
  programs.bash = {
    #enable = true;	# 导致Steamdeck切换桌面模式时ksplashqml崩溃
    bashrcExtra = ''
      export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
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
        "direnv"
        # "docker-compose"
        # "docker"
      ];
      theme = "robbyrussell";
    };

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -lah";
      ra = "y";
      bui = "bluetuith";
      update = "home-manager switch -b backup --impure --flake ${dotfileDir}";
      claude-sk = "ANTHROPIC_AUTH_TOKEN='sk-QvveLQ59Kl8uKTtAFwJns75knF5QOoyQT9Wr8JI5buM37tnH' ANTHROPIC_BASE_URL='https://ccg.shiwoool.com' CLAUDE_CODE_MAX_OUTPUT_TOKENS=32000 claude";
    };

    initContent = ''
      bindkey '^f' autosuggest-accept
      export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
      export XDG_DATA_HOME="$HOME/.local/share"
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8
      if [[ "$TERM" == "xterm-kitty" ]]; then
        alias ssh="TERM=xterm-256color ssh"
      fi
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}

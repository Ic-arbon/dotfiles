{
  config,
  lib,
  ...
}: let
  dotfileDir = "$HOME/dotfiles";
  # 明文密钥必须放在仓库外；repo 内只允许 SOPS 加密的 secrets.yaml
  secretDir =
    if
      builtins.hasAttr "dotfiles" config
      && builtins.hasAttr "secretsDir" config.dotfiles
      && config.dotfiles.secretsDir != null
    then config.dotfiles.secretsDir
    else "$HOME/.config/dotfiles/secrets";

  # sops-nix 可用且 common 密文存在时读取解密路径，否则回退到仓库外明文目录
  sopsEnabled =
    builtins.hasAttr "dotfiles" config
    && builtins.hasAttr "sops" config.dotfiles
    && config.dotfiles.sops.enable;
  commonSopsFile =
    if builtins.hasAttr "dotfiles" config && builtins.hasAttr "secrets" config.dotfiles
    then config.dotfiles.secrets.commonFile
    else null;
  apiSopsEnabled = sopsEnabled && commonSopsFile != null;

  apiToken = name:
    if apiSopsEnabled
    then config.sops.secrets.${name}.path
    else "${secretDir}/${name}";

  # 根据 machines 注入的 identity 生成正确的部署命令
  updateCmd =
    if
      builtins.hasAttr "dotfiles" config
      && builtins.hasAttr "machine" config.dotfiles
    then
      if config.dotfiles.machine.kind == "nixos"
      then "sudo nixos-rebuild switch --flake ${dotfileDir}#${config.dotfiles.machine.hostname}"
      else if config.dotfiles.machine.kind == "darwin"
      then "darwin-rebuild switch --flake ${dotfileDir}#${config.dotfiles.machine.hostname}"
      else "home-manager switch -b backup --impure --flake ${dotfileDir}#${config.dotfiles.machine.identity}"
    else "home-manager switch -b backup --impure --flake ${dotfileDir}";
in {
  sops.secrets = lib.mkIf apiSopsEnabled {
    "deepseek-api-key" = {
      sopsFile = commonSopsFile;
      mode = "0400";
    };
    "glm-api-key" = {
      sopsFile = commonSopsFile;
      mode = "0400";
    };
  };

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
      update = updateCmd;
      deepseek = builtins.concatStringsSep " " [
        "ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic"
        "ANTHROPIC_AUTH_TOKEN=\"$(cat ${apiToken "deepseek-api-key"})\""
        # "ANTHROPIC_MODEL='deepseek-v4-pro[1m]'"
        "ANTHROPIC_MODEL=deepseek-v4-flash[1m]"
        "ANTHROPIC_DEFAULT_OPUS_MODEL='deepseek-v4-pro[1m]'"
        "ANTHROPIC_DEFAULT_SONNET_MODEL='deepseek-v4-pro[1m]'"
        "ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash[1m]"
        # "CLAUDE_CODE_SUBAGENT_MODEL='deepseek-v4-pro[1m]'"
        "CLAUDE_CODE_SUBAGENT_MODEL='deepseek-v4-flash[1m]'"
        "CLAUDE_CODE_EFFORT_LEVEL=max"
        "claude"
      ];
      glm = builtins.concatStringsSep " " [
        "ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/anthropic"
        "ANTHROPIC_AUTH_TOKEN=\"$(cat ${apiToken "glm-api-key"})\""
        "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1"
        "API_TIMEOUT_MS=600000"
        "ANTHROPIC_MODEL='glm-5.2[1m]'"
        "ANTHROPIC_DEFAULT_OPUS_MODEL='glm-5.2[1m]'"
        "ANTHROPIC_DEFAULT_SONNET_MODEL='glm-5.2[1m]'"
        "ANTHROPIC_DEFAULT_HAIKU_MODEL='glm-5.2[1m]'"
        "ANTHROPIC_SMALL_FAST_MODEL='glm-5.2[1m]'"
        "CLAUDE_CODE_SUBAGENT_MODEL='glm-5.2[1m]'"
        "CLAUDE_CODE_AUTO_COMPACT_WINDOW=1000000"
        "claude"
      ];
    };

    initContent = ''
      bindkey '^f' autosuggest-accept
      export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
      export XDG_DATA_HOME="$HOME/.local/share"
      export PATH="$HOME/.local/bin:$PATH"
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8
      if [[ "$TERM" == "xterm-ghostty" ]]; then
        alias ssh="TERM=xterm-256color ssh"
      fi
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}

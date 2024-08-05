{ config, pkgs, libs, ... }:

let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  unsupported = builtins.abort "Unsupported platform";

  homeDir = "${config.home.homeDirectory}";
  # stuffDir =
  #   if isLinux then "/stuff" else
  #   if isDarwin then "${homeDir}/stuff" else unsupported;
  # hmDir = "${stuffDir}/nix/home-manager";
in
{
  #导入部分apps的配置文件
  imports = [
    ./apps/shells.nix
    ./apps/git.nix
    ./apps/ssh.nix  # 不能全自动化部署，需要ssh-keygen -t ed25519，并上传公钥
    ./apps/ranger.nix
    ./apps/astronvim.nix
    ./apps/firefox.nix
  ];
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; ([
    # # 已经加了"with pkgs;"了，意味着分号后的表达式都是pkgs的子集，只需要包名就行了
    # Common packages
    bat
    neofetch
    v2raya
    v2ray
    ffmpeg
    go-musicfox
  ] 
  ++ lib.optionals isLinux [
    # GNU/Linux packages
    bind
    nload
    bluetuith
  ]
  ++ lib.optionals isDarwin [
    # macOS packages
    gnused
  
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ]);
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "spotify"
    ];
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/deck/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
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
  
  # 以下是不常用的settings

  #让home-manager在非NixOS下更好地工作，能让kde集成桌面应用
  targets.genericLinux.enable=true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "deck";
  home.homeDirectory =
    if isLinux then "/home/deck" else
    if isDarwin then "/Users/deck" else unsupported;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

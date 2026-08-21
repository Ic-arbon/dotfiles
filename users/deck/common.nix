# deck 的机器无关 home-manager 基础配置（SteamOS 独立部署）。
{
  config,
  pkgs,
  ...
}: {
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

  # genericLinux 与 GPU 由 platform.standalone profile 自动设置（targets.genericLinux.gpu）

  # Steam Deck 特定的包
  home.packages = with pkgs; [
    pkgs.octaveFull
  ];

  # Steam Deck 桌面集成：让 KDE 检测到 nix 安装的应用
  xdg.desktopEntries = {};
  home.file.".local/share/applications/nix-apps" = {
    source = "${config.home.profileDirectory}/share/applications";
    recursive = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "zh_CN.UTF-8";
    LANGUAGE = "zh_CN:en_US";
  };

  xdg.enable = true;
  systemd.user.startServices = "sd-switch";
}

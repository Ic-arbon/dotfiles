# Seafile 服务器基础系统配置（原文件缺失，按 proxy 风格补全最小集）。
{
  config,
  pkgs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "seafile";
  time.timeZone = "Asia/Shanghai";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.${config.dotfiles.machine.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "24.05";
}

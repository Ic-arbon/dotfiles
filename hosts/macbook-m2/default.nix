{ ... }:
{
  # macOS系统配置将在这里定义
  # 这个文件现在是占位符，等你有MacBook后再完善
  
  # 基本的Darwin配置
  system.stateVersion = 5;  # Darwin版本
  
  # 启用Nix daemon
  services.nix-daemon.enable = true;
  
  # Nix配置
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@admin" ];
  };
  
  # 允许不自由软件
  nixpkgs.config.allowUnfree = true;
  
  # 基本的系统程序
  programs.zsh.enable = true;
}
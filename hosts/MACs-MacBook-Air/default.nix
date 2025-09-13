{ ... }:
{
  # macOS系统配置将在这里定义
  # 这个文件现在是占位符，等你有MacBook后再完善
  nixpkgs.hostPlatform = "aarch64-darwin";

    users.users.tyd = {
        name = "tyd";
        home = "/Users/tyd";
    };

  # 基本的Darwin配置
  system.stateVersion = 5;  # Darwin版本
  
  # Nix配置
  nix.enable = false;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@admin" ];
  };
  
  # 基本的系统程序
  programs.zsh.enable = true;
}

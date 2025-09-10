# Seafile服务器网络配置
{ config, lib, pkgs, ... }:

{
  # 启用网络管理器
  networking.networkmanager.enable = true;

  # 防火墙配置
  networking.firewall = {
    enable = true;
    # Seafile默认端口
    allowedTCPPorts = [ 22 80 443 8000 8082 ];
  };

  # SSH配置
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
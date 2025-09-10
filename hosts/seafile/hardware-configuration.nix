# 这是seafile服务器的硬件配置占位符
# 实际部署时需要根据具体硬件生成
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # 启动配置
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 文件系统配置（占位符）
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  # 网络
  networking.useDHCP = lib.mkDefault true;
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
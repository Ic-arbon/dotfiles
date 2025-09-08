{ config, pkgs, lib, ... }:

{
  # 启用 flatpak 支持
  services.flatpak.enable = true;

  users.users."tyd" = {
    packages = with pkgs; [
      flatpak
      gnome-software
    ];
  };

  # XDG 桌面门户支持（用于更好的桌面集成）
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    # 修复 1.17+ 版本的配置
    config.common.default = "*";
  };

}

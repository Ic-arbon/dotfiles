# Flatpak + XDG portal；用户从 dotfiles.machine.username 读取，不再硬编码。
{
  config,
  pkgs,
  ...
}: {
  services.flatpak.enable = true;

  users.users.${config.dotfiles.machine.username} = {
    packages = with pkgs; [
      flatpak
      gnome-software
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };
}

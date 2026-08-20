{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  homeDir = "/home/${config.dotfiles.machine.username}";
in {
  networking.networkmanager.enable = true;

  # daed - dae with a web dashboard
  services.daed = {
    enable = true;

    openFirewall = {
      enable = true;
      port = 12345;
    };

    listen = "0.0.0.0:2023";
    configDir = "${homeDir}/.config/daed";
  };
}

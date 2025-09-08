{ config, lib, pkgs, ... }:
{
  services.supergfxd.enable = true;
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  services.asusd.enable = true;
  services.asusd.enableUserService = true;
}


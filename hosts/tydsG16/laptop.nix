{ config, lib, pkgs, ... }:
{
  # logind
  services.logind = {
    powerKey = "ignore";
    lidSwitch = "suspend";
    lidSwitchExternalPower = "ignore";
  };

  services.power-profiles-daemon.enable = true;

  # specialisation = {
  #   on-the-go.configuration = {
  #     system.nixos.tags = [ "on-the-go" ];
  #     hardware.nvidia = {
  #       prime.offload.enable = lib.mkForce true;
  #       prime.offload.enableOffloadCmd = lib.mkForce true;
  #       prime.sync.enable = lib.mkForce false;
  #     };
  #   };
  # };  

}


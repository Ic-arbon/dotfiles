{ inputs, config, lib, pkgs, ... }:

let 
  homeDir = "/home/tyd";
in

{
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 22 80 2023 8082 8083];
  # networking.firewall.allowedUDPPorts = [ 8211 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "socks5://192.168.1.207:20170";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

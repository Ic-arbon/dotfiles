{ inputs, config, lib, pkgs, ... }:
let 
  homeDir = "/home/tyd";
in
{
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  networking.interfaces.enp56s0 = {
    wakeOnLan = {
      enable = true;
      policy = [ "magic" ];
    };

  };

  # systemd.services.wakeonnlan = {
  #   after = [ "network.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     RemainAfterExit = "true";
  #     ExecStart = "${pkgs.ethtool}/sbin/ethtool -s enp56s0 wol g";
  #   };
  #   wantedBy = [ "multi-user.target" ];
  # };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # services.v2raya.enable = true;
  # services.v2ray.configFile = "/etc/v2ray/config.json";

  # dae
  # services.dae = {
  #     enable = true;
  #
  #     openFirewall = {
  #       enable = true;
  #       port = 12345;
  #     };
  #
  #     configFile = "${homeDir}/.config/dae/config.dae";
  #
  #     /* default options */
  #
  #     # disableTxChecksumIpGeneric = false;
  #     #
  #     # configFile = "/etc/dae/config.dae";
  #     # assets = with pkgs; [ v2ray-geoip v2ray-domain-list-community ];
  #
  #     # alternative of `assets`, a dir contains geo database.
  #     # assetsPath = "/etc/dae";
  # };

  # daed - dae with a web dashboard
  services.daed = {
      enable = true;

      openFirewall = {
        enable = true;
        port = 12345;
      };

      listen = "0.0.0.0:2023";
      configDir = "${homeDir}/.config/daed";

      /* default options */

      # package = inputs.daeuniverse.packages.x86_64-linux.daed;
      # configDir = "/etc/daed";
      # listen = "127.0.0.1:2023";
  };

  # services.udev = {
  #   extraRules = ''
  #     SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
  #   '';
  # };
}

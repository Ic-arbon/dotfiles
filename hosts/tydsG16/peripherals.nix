{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    # package = pkgs.bluez;
    powerOnBoot = true;
  };

  # services.pipewire.wireplumber.extraConfig."10-bluez" = {
  #   "monitor.bluez.properties" = {
  #     "bluez5.enable-sbc-xq" = true;
  #     "bluez5.enable-msbc" = true;
  #     "bluez5.enable-hw-volume" = true;
  #     "bluez5.roles" = [
  #       "hsp_hs"
  #       "hsp_ag"
  #       "hfp_hf"
  #       "hfp_ag"
  #     ];
  #   };
  # };
  services.pipewire.wireplumber.extraConfig."11-bluetooth-policy" = {
    "wireplumber.settings" = {
      "bluetooth.autoswitch-to-headset-profile" = false;
    };
  };

  services.blueman.enable = true;
  
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    # touchpad.dev = "/dev/input/by-id/usb-ASUSTek_Computer_Inc._N-KEY_Device-event-mouse";
    # touchpad.sendEventsMode = "disabled-on-external-mouse";
  };
}


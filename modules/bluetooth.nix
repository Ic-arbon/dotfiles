{
  xdg.configFile = {
    "wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" = {
      text = ''
        wireplumber.settings = {
          bluetooth.autoswitch-to-headset-profile = false
        } 
      '';
    };
  };
}

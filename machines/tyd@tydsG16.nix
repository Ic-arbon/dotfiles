# tyd@tydsG16 —— 游戏本/开发机（NixOS）
{profiles, ...}: {
  identity = {
    username = "tyd";
    hostname = "tydsG16";
    system = "x86_64-linux";
    kind = "nixos";
  };

  facts = {
    laptop = true;
    nvidia = true;
    monitor = "eDP-1,preferred,auto,auto";
  };

  profiles = {
    home = [
      profiles.home.dev.embedded
      profiles.home.desktop.hyprland
      profiles.home.desktop.gaming
      profiles.home.networking.ssh
      profiles.home.networking.dae
    ];
    system = [
      profiles.system.desktop
      profiles.system.embedded-hardware
      profiles.system.android-dev
    ];
  };

  home = {
    stateVersion = "25.05";
    useGlobalPkgs = false;
    extraImports = [];
  };

  system = {
    nur = true;
    dae = true;
    daed = true;
    extraImports = [../hosts/tydsG16];
  };
}

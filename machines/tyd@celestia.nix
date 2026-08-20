# tyd@celestia —— 台式机/开发机/游戏机（NixOS）
{profiles, ...}: {
  identity = {
    username = "tyd";
    hostname = "celestia";
    system = "x86_64-linux";
    kind = "nixos";
  };

  facts = {
    laptop = false;
    nvidia = true;
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
    stateVersion = "25.11";
    useGlobalPkgs = false;
    extraImports = [];
  };

  system = {
    nur = true;
    dae = true;
    daed = true;
    extraImports = [../hosts/celestia];
  };
}

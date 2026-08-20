# deck@steam-deck —— Steam Deck（standalone home-manager）
{profiles, ...}: {
  identity = {
    username = "deck";
    hostname = "steam-deck";
    system = "x86_64-linux";
    kind = "standalone";
  };

  facts = {
    laptop = true;
    nvidia = false;
  };

  profiles = {
    home = [
      profiles.home.desktop.common
      profiles.home.desktop.fonts
      profiles.home.networking.dae
    ];
    system = [];
  };

  home = {
    stateVersion = "24.11";
    useGlobalPkgs = false;
    extraImports = [];
  };

  system = {
    nur = false;
    extraImports = [];
  };
}

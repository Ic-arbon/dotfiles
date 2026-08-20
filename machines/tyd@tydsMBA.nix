# tyd@tydsMBA —— MacBook Air（nix-darwin）
{profiles, ...}: {
  identity = {
    username = "tyd";
    hostname = "tydsMBA";
    system = "aarch64-darwin";
    kind = "darwin";
  };

  facts = {
    laptop = true;
    nvidia = false;
  };

  profiles = {
    home = [
      profiles.home.desktop.common
      profiles.home.desktop.multimedia
    ];
    system = [];
  };

  home = {
    stateVersion = "25.11";
    useGlobalPkgs = false;
    extraImports = [];
  };

  system = {
    nur = false;
    extraImports = [../hosts/tydsMBA];
  };
}

# tyd@proxy —— 代理服务器（NixOS）
{profiles, ...}: {
  identity = {
    username = "tyd";
    hostname = "proxy";
    system = "x86_64-linux";
    kind = "nixos";
  };

  facts = {
    laptop = false;
    nvidia = false;
  };

  profiles = {
    home = [profiles.home.server];
    system = [];
  };

  home = {
    stateVersion = "25.05";
    useGlobalPkgs = true;
    extraImports = [];
  };

  system = {
    nur = false;
    daed = true;
    extraImports = [../hosts/proxy];
  };
}

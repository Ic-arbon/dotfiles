{ nixpkgs, home-manager, ... } @ inputs:
let
  common = import ./common.nix inputs;
in
home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
  extraSpecialArgs = common.pkgArgs.x86_64-linux // { 
    inherit inputs;
    outputs = import ./default.nix inputs;
  };
  modules = [
    ../hosts/steam-deck/home.nix
    inputs.stylix.homeModules.stylix
  ];
}
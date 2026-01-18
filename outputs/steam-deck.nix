{ nixpkgs, home-manager, ... } @ inputs:
let
  common = import ./common.nix inputs;
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    overlays = [ inputs.nur.overlays.default ];
  };
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = common.pkgArgs.x86_64-linux // {
    inherit inputs;
    outputs = import ./default.nix inputs;
  };
  modules = [
    ../hosts/steam-deck/home.nix
    inputs.stylix.homeModules.stylix
  ];
}
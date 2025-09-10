{
  nixpkgs,
  home-manager,
  ...
} @ inputs: let
  systems = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  forAllSystems = nixpkgs.lib.genAttrs systems;
  
  genSpecialArgs = system: {
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
      # overlays = [ inputs.nur.overlays.default ];
    };
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      # overlays = [ inputs.nur.overlays.default ];
    };

    nix-gaming = inputs.nix-gaming.packages.${system};

    nixgl = {
      packages = inputs.nixGL.packages.${system}; 
      config.allowUnfree = true;
    };
  };
in {
  inherit forAllSystems genSpecialArgs;
  
  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  overlays = import ../overlays { inherit inputs; };
  homeManagerModules = import ../modules;
  
  pkgArgs = forAllSystems genSpecialArgs;
}

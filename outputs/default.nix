{
  self,
  nixpkgs,
  home-manager,
  nur,
  nixGL,
  pre-commit-hooks,
  ...
} @ inputs: let
  inherit (self) outputs;

  users = [ "tyd" "deck" ];

  # Supported systems for your flake packages, shell, etc.
  systems = [
    # linux
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    # darwin
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  # This is a function that generates an attribute by calling a function you
  # pass to it, with each system as an argument
  forAllSystems = nixpkgs.lib.genAttrs systems;

  genSpecialArgs = system: {
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    nur = import inputs.nur {
      inherit system;
      config.allowUnfree = true;
    };
  };
  specialArgs = forAllSystems (system: genSpecialArgs system);

in 
{
  # Your custom packages
  # Accessible through 'nix build', 'nix shell', etc
  # packages = forAllSystems (system: import ../pkgs nixpkgs.legacyPackages.${system});

  # Formatter for your nix files, available through 'nix fmt'
  # Other options beside 'alejandra' include 'nixpkgs-fmt'
  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

  # Your custom packages and modifications, exported as overlays
  # TODO: move to submodules
  overlays = import ../overlays {inherit inputs;};
  # Reusable home-manager modules you might want to export
  # These are usually stuff you would upstream into home-manager
  homeManagerModules = import ../modules;

  # Standalone home-manager configuration entrypoint
  # Available through 'home-manager --flake .#your-username@your-hostname'
  # TODO: mutable system var
  homeConfigurations = nixpkgs.lib.genAttrs users (user:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = specialArgs // { inherit inputs outputs; };
      modules = [
        ../home/${user}
      ];
    }
  );
  # homeConfigurations = {
  #   "tyd" = home-manager.lib.homeManagerConfiguration {
  #     pkgs = nixpkgs.legacyPackages.x86_64-linux;
  #     extraSpecialArgs = specialArgs // { inherit inputs outputs; };
  #     modules = [
  #       ../home/tyd
  #     ];
  #   };
  # };
}

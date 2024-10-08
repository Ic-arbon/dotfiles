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
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib {inherit lib;};
  # myvars = import ../vars {inherit lib;};

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

  genSpecialArgs = system: 
    {
      inherit mylib;

      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };

      nix-gaming = import inputs.nix-gaming;

      # nur = import inputs.nur {
      #   nurpkgs = import nixpkgs { inherit system; };
      # };
    };
  pkgArgs = forAllSystems (system: genSpecialArgs system);

in 
{
  # Your custom packages
  # Accessible through 'nix build', 'nix shell', etc
  # packages = forAllSystems (system: import ../pkgs nixpkgs.legacyPackages.${system});

  # Formatter for your nix files, available through 'nix fmt'
  # Other options beside 'alejandra' include 'nixpkgs-fmt'
  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

  # Your custom packages and modifications, exported as overlays
  overlays = import ../overlays {inherit inputs;};

  # Reusable home-manager modules you might want to export
  # These are usually stuff you would upstream into home-manager
  homeManagerModules = import ../modules;

  # Standalone home-manager configuration entrypoint
  # Available through 'home-manager --flake .#your-username@your-hostname'
  homeConfigurations = nixpkgs.lib.genAttrs users (user:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = pkgArgs.x86_64-linux // {inherit inputs outputs;};
      modules = [
        ../users/${user}
      ];
    }
  );

  nixosConfigurations.tydsG16 = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = pkgArgs.x86_64-linux // {inherit inputs outputs;}; 
    modules = [
      ../hosts/tydsG16
      inputs.daeuniverse.nixosModules.dae
      inputs.daeuniverse.nixosModules.daed
    ];
  };
}

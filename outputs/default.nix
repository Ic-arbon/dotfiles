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
  # Supported systems for your flake packages, shell, etc.
  systems = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  # This is a function that generates an attribute by calling a function you
  # pass to it, with each system as an argument
  forAllSystems = nixpkgs.lib.genAttrs systems;
in 
{
  # Your custom packages
  # Accessible through 'nix build', 'nix shell', etc
  packages = forAllSystems (system: import ../pkgs nixpkgs.legacyPackages.${system});
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
  homeConfigurations = {
    #  TODO: FIXME replace with your username@hostname
    "tyd" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [
        # > Our main home-manager configuration file <
        # ./home-manager/home.nix
        ../home.nix
      ];
    };
  };
}

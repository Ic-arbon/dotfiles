{ nixpkgs, nix-darwin, home-manager, ... } @ inputs:
let
  common = import ./common.nix inputs;
in
nix-darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = common.pkgArgs.aarch64-darwin // { 
    inherit inputs; 
    outputs = import ./default.nix inputs;
  };
  modules = [
    # Darwin系统配置
    ../hosts/macbook-m2
    
    # 集成home-manager
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = common.pkgArgs.aarch64-darwin // {
        inherit inputs;
        outputs = import ./default.nix inputs;
      };
      home-manager.users.tyd = import ../hosts/macbook-m2/home.nix;
    }
  ];
}
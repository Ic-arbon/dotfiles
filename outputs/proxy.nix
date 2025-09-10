{ nixpkgs, home-manager, ... } @ inputs:
let
  common = import ./common.nix inputs;
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = common.pkgArgs.x86_64-linux // { 
    inherit inputs; 
    outputs = import ./default.nix inputs;
  };
  modules = [
    # 系统配置
    ../hosts/proxy
    inputs.daeuniverse.nixosModules.daed
    
    # 集成home-manager
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = common.pkgArgs.x86_64-linux // {
        inherit inputs;
        outputs = import ./default.nix inputs;
      };
      home-manager.users.tyd = import ../hosts/proxy/home.nix;
    }
  ];
}
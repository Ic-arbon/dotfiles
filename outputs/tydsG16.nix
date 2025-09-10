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
    ../hosts/tydsG16
    inputs.daeuniverse.nixosModules.dae
    inputs.daeuniverse.nixosModules.daed
    
    # 集成home-manager
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = false;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = common.pkgArgs.x86_64-linux // {
        inherit inputs;
        outputs = import ./default.nix inputs;
      };
      home-manager.users.tyd = import ../hosts/tydsG16/home.nix;
      home-manager.sharedModules = [
        inputs.stylix.homeModules.stylix
        # 配置 home-manager 的 nixpkgs
        {
          nixpkgs.overlays = [ inputs.nur.overlays.default ];
          nixpkgs.config.allowUnfree = true;
        }
      ];
    }
  ];
}

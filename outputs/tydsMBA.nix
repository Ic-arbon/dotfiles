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
    ../hosts/tydsMBA
    
    # 集成home-manager
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = false;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = common.pkgArgs.aarch64-darwin // {
        inherit inputs;
        outputs = import ./default.nix inputs;
      };
      home-manager.users.tyd = import ../hosts/tydsMBA/home.nix;    
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

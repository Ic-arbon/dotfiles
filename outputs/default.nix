inputs: let
  common = import ./common.nix inputs;
in {
  # Formatter for your nix files, available through 'nix fmt'
  formatter = common.formatter;

  # Your custom packages and modifications, exported as overlays
  overlays = common.overlays;

  # Reusable home-manager modules you might want to export
  homeManagerModules = common.homeManagerModules;

  # NixOS系统配置（包含系统+用户）
  nixosConfigurations = {
    tydsG16 = import ./tydsG16.nix inputs;
    proxy = import ./proxy.nix inputs;
    seafile = import ./seafile.nix inputs;
  };

  # Darwin系统配置（包含系统+用户）
  darwinConfigurations = {
    tydsMBA = import ./tydsMBA.nix inputs;
  };

  # 独立的home-manager配置（用于非NixOS/Darwin系统或测试用）
  homeConfigurations = {
    "deck@steam-deck" = import ./steam-deck.nix inputs;
  };
}

{...}: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./boot.nix
    ./graphics.nix
    ./networking.nix
  ];
}

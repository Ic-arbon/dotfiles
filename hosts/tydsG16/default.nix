{...}: {
  imports = [
    ./hardware-configuration.nix
    ./asus.nix
    ./configuration.nix
    ./boot.nix
    ./graphics.nix
    ./laptop.nix
    ./networking.nix
    ./udev.nix
  ];
}

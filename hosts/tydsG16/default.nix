{ ... }:
{
  imports = [
    ./audio.nix
    ./hardware-configuration.nix
    ./configuration.nix
    ./laptop.nix
    ./locale.nix
    ./gamemode.nix
    ./graphics.nix
    ./networking.nix
    ./peripherals.nix
    ./steam.nix
    ./zram.nix
  ];
}

{ ... }:
{
  imports = [
    ./android-dev.nix
    ./asus.nix
    ./audio.nix
    ./hardware-configuration.nix
    ./configuration.nix
    ./fhs.nix
    ./flatpak.nix
    ./gamemode.nix
    ./graphics.nix
    ./laptop.nix
    ./locale.nix
    ./networking.nix
    ./peripherals.nix
    ./steam.nix
    ./udev.nix
    ./virtualisation.nix
    # ./umu.nix
    ./zram.nix
  ];
}

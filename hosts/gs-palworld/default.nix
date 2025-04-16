{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./fhs.nix
    ./networking.nix
    # ./seafile.nix
  ];
}

{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./fhs.nix
    ./networking.nix
    ./gitlab.nix
    # ./seafile.nix
  ];
}

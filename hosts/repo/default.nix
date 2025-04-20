{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./forgejo.nix
    ./sops.nix
  ];
}

{ config, lib, pkgs, ... }:
{
  # In /etc/nixos/configuration.nix
  virtualisation.docker = {
    enable = true;
    # Customize Docker daemon settings using the daemon.settings option
    daemon.settings = {
      # dns = [ "1.1.1.1" "8.8.8.8" ];
      log-driver = "journald";
      # registry-mirrors = [ "https://mirror.gcr.io" ];
      # storage-driver = "overlay2";
    };
    # Use the rootless mode - run Docker daemon as non-root user
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose  
  ];

  # Optional: Add your user to the "docker" group to run docker without sudo
  # users.users.tyd.extraGroups = [ "docker" ];
}

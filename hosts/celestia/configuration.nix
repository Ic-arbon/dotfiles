{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["root" "@wheel"];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [inputs.nur.overlays.default];

  networking.hostName = "celestia";

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
  };

  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users.root = {};
    users.${config.dotfiles.machine.username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = ["networkmanager" "wheel" "video" "input" "uinput" "libvirtd" "wireshark" "uucp" "dialout" "plugdev"];
      packages = with pkgs; [
        git
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  programs.pulseview = {
    enable = true;
  };

  services.openssh.enable = true;

  networking.firewall.enable = false;

  # gamemode 依赖 power-profiles-daemon
  services.power-profiles-daemon.enable = true;

  system.stateVersion = "25.11";
}

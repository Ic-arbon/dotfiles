{config, ...}: {
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.${config.dotfiles.machine.username} = {
    name = config.dotfiles.machine.username;
    home = "/Users/${config.dotfiles.machine.username}";
  };

  system.stateVersion = 5; # Darwin版本

  nix.enable = false;
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["@admin"];
  };

  programs.zsh.enable = true;
}

{ pkgs, ...}:

{
  programs = {
    ssh = {
      enable = true;
      package = pkgs.openssh;
      matchBlocks = {
        "github.com" = {
          user = "git";
          identityFile = "~/.ssh/github";
        };
      };
      extraOptionOverrides = {
        "AddKeysToAgent" = "yes";
      };
    };
    zsh = {
      oh-my-zsh = {
        enable = true;
        plugins = [
          "ssh-agent"
        ];
      };
    };
  };
}
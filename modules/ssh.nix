{pkgs, ...}: {
  programs.ssh = {
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
  services.ssh-agent = {
    enable = true;
  };
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "ssh-agent"
      ];
    };
  };
}

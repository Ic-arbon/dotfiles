{
  lib,
  pkgs,
  pkgs-stable,
  ...
}: {
  # Dependencies
  fonts.fontconfig.enable = true;

  # home.packages = with pkgs; [
  #   # (nerdfonts.override {fonts = ["FiraCode"];})
  #   nerd-fonts.fira-code
  #   tree-sitter
  #   gdu
  #   python3
  #   nodejs_22
  #   gcc
  #   gzip
  #   unzip
  #   cargo
  # ];

  programs = {
    neovim = {
      enable = true;
      withPython3 = true;
      withNodeJs = true;
      extraPackages = with pkgs; [
        nerd-fonts.fira-code
        tree-sitter
        gdu
        python3
        nodejs_22
        gcc
        gzip
        unzip
        cargo
      ];
    };

    ripgrep = {
      enable = true;
    };

    lazygit = {
      enable = true;
    };

    bottom = {
      enable = true;
      settings = {
        flags = {
          color = "gruvbox";
        };
      };
    };
  };

  home.activation = {
    backup = lib.hm.dag.entryBefore ["writeBoundary"] ''
      if [[ -f $HOME/dotfiles/modules/backup_nvim.sh ]]; then
        $DRY_RUN_CMD $HOME/dotfiles/modules/backup_nvim.sh
      fi
    '';
  };

  xdg.configFile = {
    "nvim" = {
      source = ./AstroNvim;
      executable = true;
      recursive = true;
    };
  };
}

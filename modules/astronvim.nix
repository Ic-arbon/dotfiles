{
  lib,
  pkgs,
  pkgs-stable,
  ...
}: {
  # Dependencies
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # (nerdfonts.override {fonts = ["FiraCode"];})
    nerd-fonts.fira-code
    tree-sitter
    gdu
    python3
    # python312Packages.stdenv
    nodejs_22
    gcc
    # gccStdenv
    gzip
    unzip
    cargo
  ];

  programs = {
    neovim = {
      enable = true;
      withPython3 = true;
      withNodeJs = true;
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
      $DRY_RUN_CMD $HOME/dotfiles/modules/backup_nvim.sh
    '';
  };

  xdg.configFile = {
    "nvim" = {
      source = ~/dotfiles/AstroNvim;
      executable = true;
      recursive = true;
    };
  };
}

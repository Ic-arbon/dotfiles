{
  lib,
  pkgs,
  ...
}: {
  # Dependencies
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
    tree-sitter
    gdu
    python3
    nodejs
    gcc
    # rustup
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

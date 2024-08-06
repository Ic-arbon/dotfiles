{pkgs, ...}: {
  # Dependencies
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
    tree-sitter
    gdu
    python3
    nodejs
    gcc
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

  xdg.configFile = {
    "nvim" = {
      source = pkgs.fetchFromGitHub {
        owner = "Ic-arbon";
        repo = "AstroNvim";
        rev = "";
        sha256 = "sha256-P6AC1L5wWybju3+Pkuca3KB4YwKEdG7GVNvAR8w+X1I=";
      };
      executable = true;
      recursive = true;
    };
  };
}

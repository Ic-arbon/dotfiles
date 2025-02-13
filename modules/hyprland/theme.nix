{ pkgs, ...}:{
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  qt = {
      enable = true;
      platformTheme.name = "gtk";
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "macchiato";
        accent = "lavender";
      };
      name = "Papirus-Dark";
    };
    theme = {
        name = "catppuccin-macchiato-mauve-compact";
        package = pkgs.catppuccin-gtk.override {
          accents = ["mauve"];
          variant = "macchiato";
          size = "compact";
        };
    };
    gtk3.extraConfig = {
        gtk-application-prefer-dark-theme=1;
        gtk-im-module="fcitx";
    };
    gtk4.extraConfig = {
        gtk-application-prefer-dark-theme=1;
        gtk-im-module="fcitx";
    };
  };
}

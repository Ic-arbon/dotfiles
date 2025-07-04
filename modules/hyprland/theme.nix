{ lib, pkgs, ...}:{
  # home.pointerCursor = lib.mkForce ({
  #   gtk.enable = true;
  #   # x11.enable = true;
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Modern-Classic";
  #   size = 16;
  # });

  stylix = {
    enable = true;

    # targets.kitty.enable = false;
    targets.waybar.enable = false;
    targets.yazi.enable = false;
    targets.firefox.profileNames = ["dev-edition-default"];

    image = ../../wallpapers/default.jpg;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    opacity.terminal = 0.9;

    fonts = {
      sizes.terminal = 16;

      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
        # package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
        # package = pkgs.nerd-fonts.sauce-code-pro;
        # name = "SauceCodePro Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  # qt = {
  #     enable = true;
  #     platformTheme.name = "gtk";
  # };
  #
  # gtk = {
  #   enable = true;
  #   iconTheme = {
  #     package = pkgs.catppuccin-papirus-folders.override {
  #       flavor = "macchiato";
  #       accent = "lavender";
  #     };
  #     name = "Papirus-Dark";
  #   };
  #   theme = {
  #       name = "catppuccin-macchiato-mauve-compact";
  #       package = pkgs.catppuccin-gtk.override {
  #         accents = ["mauve"];
  #         variant = "macchiato";
  #         size = "compact";
  #       };
  #   };
  #   gtk3.extraConfig = {
  #       gtk-application-prefer-dark-theme=1;
  #       gtk-im-module="fcitx";
  #   };
  #   gtk4.extraConfig = {
  #       gtk-application-prefer-dark-theme=1;
  #       gtk-im-module="fcitx";
  #   };
  # };
}

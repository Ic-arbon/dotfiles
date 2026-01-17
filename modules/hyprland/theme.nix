{ lib, pkgs, pkgs-stable, ...}:{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    polarity = "dark";

    image = ../../wallpapers/default.jpg;

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
        # package = pkgs-stable.nerdfonts.override {fonts = ["FiraCode"];};
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };#font end

    targets.firefox.profileNames = ["dev-edition-default"];

  };#stylix end
  

}

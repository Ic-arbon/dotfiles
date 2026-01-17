{ config, lib, pkgs, pkgs-stable, ...}:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji 
    # nerdfonts
    # (nerdfonts.override {fonts = ["FiraCode" "SourceCodePro"];})
    # nerd-fonts.dejavu-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.sauce-code-pro
    source-han-serif
    # font-awesome_6      # otf-font-awesome
  ];
  # ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # home.file = {
  #   ".local/share/fonts" = {
  #     source = ~/.nix-profile/share/fonts; 
  #   };
  # };
  home.activation.refreshFontCache = lib.hm.dag.entryAfter [ "installPackages" ] ''
    echo "构建字体缓存 Refreshing font cache..."
    echo "${pkgs.fontconfig}"
    ${pkgs.fontconfig}/bin/fc-cache 
  '';
}

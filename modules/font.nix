{ config, lib, pkgs, ...}:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji 
    nerdfonts
    source-han-serif
    font-awesome      # otf-font-awesome
  ];
  home.file = {
    ".local/share/fonts" = {
      source = ~/.nix-profile/share/fonts; 
    };
  };
  home.activation.refreshFontCache = lib.hm.dag.entryAfter [ "installPackages" ] ''
    echo "构建字体缓存 Refreshing font cache..."
    echo "${pkgs.fontconfig}"
    ${pkgs.fontconfig}/bin/fc-cache 
  '';
}

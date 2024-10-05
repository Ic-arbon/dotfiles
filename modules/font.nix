{ config, lib, pkgs, ...}:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji 
    nerdfonts
    font-awesome      # otf-font-awesome
  ];
  home.activation.refreshFontCache = lib.hm.dag.entryAfter [ "installPackages" ] ''
    echo "构建字体缓存 Refreshing font cache..."
    ${pkgs.fontconfig}/bin/fc-cache 
  '';
}

{pkgs, pkgs-stable, ...}: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    # enable = true;
    # type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-pinyin-zhwiki
      fcitx5-pinyin-moegirl
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-configtool
    ];
  };
}

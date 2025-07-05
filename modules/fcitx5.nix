{pkgs, pkgs-stable, ...}: {
  i18n.inputMethod = {
    # enabled = "fcitx5";
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-pinyin-zhwiki
      fcitx5-pinyin-moegirl
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-configtool
    ];
    fcitx5.settings.inputMethod = {
      GroupOrder."0" = "Default";
      "Groups/0" = {
        Name = "Default";
        "Default Layout" = "us";
        DefaultIM = "pinyin";
      };
      "Groups/0/Items/0".Name = "keyboard-us";
      "Groups/0/Items/1".Name = "pinyin";
    };
    fcitx5.settings.addons.pinyin.globalSection = {
      CloudPinyinEnabled = "True";
      CloudPinyinIndex = 2;
    };
  };
}

# tyd@OB714 —— Fedora 笔记本（standalone home-manager）
# 组件组合：core（自动）+ desktop.gnome + dev.vm，无 electron / embedded / hyprland / gaming。
{profiles, ...}: {
  identity = {
    username = "tyd";
    hostname = "OB714";
    system = "x86_64-linux";
    kind = "standalone";
  };

  facts = {
    laptop = true;
    nvidia = false;
    desktop = "gnome";
  };

  profiles = {
    home = [
      profiles.home.desktop.gnome
      profiles.home.dev.vm
    ];
    system = [];
  };

  home = {
    stateVersion = "25.11";
    useGlobalPkgs = false;
    extraImports = [];
  };

  system = {
    nur = false;
    extraImports = [];
  };
}

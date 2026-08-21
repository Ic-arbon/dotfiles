# 组件套餐（profiles）。
# 叶子 profile 只导入功能模块；组合 profile 只聚合叶子。
# core 与 platform 由 outputs/builders.nix 自动注入，机器清单无需重复选择。
{hmModules}: let
  core = [
    hmModules.shell
    hmModules.git
    hmModules.astronvim
    hmModules.base-tools
    hmModules.filemanager
  ];

  server = [
    hmModules.ssh
  ];

  dev = {
    full = [
      hmModules.embedded
      hmModules.android-dev
    ];
    embedded = [hmModules.embedded];
    android = [hmModules.android-dev];
    vm = [hmModules.vm];
  };

  desktop = rec {
    # GUI 通用：浏览器 + 主题 + 终端（字体单独叶子，因为 macOS 当前不装 font profile）
    common = [
      hmModules.browsers
      hmModules.theme
      hmModules.ghostty
    ];
    fonts = [hmModules.font];
    # 输入法属于桌面但不属于 common，按机器选择是否启用
    input = [hmModules.fcitx5];
    # 纯图形化多媒体工具
    multimedia = [
      hmModules.multi-media-tools
      hmModules.graphic-tools
    ];
    # Electron 应用单独成类，GNOME 默认不强制带
    electron = [hmModules.electron];
    # Fedora GNOME：common + fonts + input + multimedia + capture
    gnome =
      common
      ++ fonts
      ++ input
      ++ multimedia
      ++ [
        hmModules.capture
      ];
    # 完整 Hyprland WM 桌面：common + fonts + input + hyprland 全家桶 + electron
    hyprland =
      common
      ++ fonts
      ++ input
      ++ [
        hmModules.hyprland
        hmModules.waybar
        hmModules.capture
        hmModules.bluetooth
      ]
      ++ electron;
    gaming = [hmModules.gaming];
  };

  networking = {
    ssh = [hmModules.ssh];
    dae = [hmModules.dae];
  };

  # 由 builders 根据 identity.kind 自动注入，机器清单无需选择。
  platform = {
    nixos = [];
    darwin = [];
    standalone = [(import ./platform/standalone-linux.nix)];
  };
in {
  home = {
    inherit core server dev desktop networking platform;
  };

  # NixOS 系统侧套餐。
  system = {
    desktop = [
      ../modules/nixos/pipewire.nix
      ../modules/nixos/fhs.nix
      ../modules/nixos/flatpak.nix
      ../modules/nixos/gamemode.nix
      ../modules/nixos/steam.nix
      ../modules/nixos/peripherals.nix
      ../modules/nixos/virtualisation.nix
      ../modules/nixos/zram.nix
      ../modules/nixos/locale.nix
    ];
    embedded-hardware = [../modules/nixos/udev-probe-rs.nix];
    android-dev = [../modules/nixos/android-dev.nix];
    nvidia-prime = [];
    asus-laptop = [];
    server-base = [];
  };
}

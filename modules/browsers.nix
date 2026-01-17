{
  config,
  lib,
  pkgs,
  pkgs-stable,
  pkgs-unstable,
  ...
}:
let
  isNixOS = builtins.pathExists /etc/nixos;
  # Detect Darwin (macOS) to avoid building Firefox from source and GTK stack
  isDarwin = pkgs.stdenv.isDarwin;

  # 原始chrome包
  chromeOriginal = pkgs.google-chrome;
  
  # 自定义桌面文件
  chromeDesktop = pkgs.makeDesktopItem {
    name = "google-chrome";
    desktopName = "Google Chrome (Wayland)";
    exec = "${chromeOriginal}/bin/google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=x11 --enable-wayland-ime %U";
    # exec = "${chromeOriginal}/bin/google-chrome-stable %U";
    icon = "google-chrome";
    terminal = false;
    categories = ["Network" "WebBrowser"];
    mimeTypes = [];
  };

  # 修改后的chrome包
  chromeWithCustomDesktop = pkgs.symlinkJoin {
    name = "google-chrome-wayland";
    paths = [ chromeOriginal ];
    buildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      # 删除原版desktop文件
      rm -f $out/share/applications/google-chrome.desktop
      # 安装自定义desktop文件
      cp ${chromeDesktop}/share/applications/*.desktop $out/share/applications/
      wrapProgram $out/bin/google-chrome-stable \
        --add-flags --enable-features=UseOzonePlatform \
        --add-flags --ozone-platform=x11 \
        --add-flags --enable-wayland-ime \
        # --add-flags --gtk-version=4
    '';
  };
in

{
  programs.firefox = {
    enable = true;
    # package = config.lib.nixGL.wrap pkgs.firefox-devedition-bin;

    package = lib.mkDefault (
      if isNixOS then pkgs.firefox
      else if isDarwin then pkgs-stable.firefox-bin
      else (config.lib.nixGL.wrap pkgs.firefox-bin)
    );

    languagePacks = [ "en-US" "zh-CN"];
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      SearchBar = "unified";
    };
    profiles = {

      dev-edition-default = {
        id = 0;
        name = "profile_0";
        isDefault = true;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          adblocker-ultimate
          darkreader
          vimium
          # tampermonkey
          immersive-translate
        ];
        settings = {
          "extensions.autoDisableScopes" = 0;
        };
      };

    };
  };
  nixpkgs.config.permittedInsecurePackages = [
    "immersive-translate-1.23.9"
  ];

  home.packages = with pkgs; [
    # 播放html5视频
    ffmpeg 

    # planB
    # chromeWithCustomDesktop
  ];

}

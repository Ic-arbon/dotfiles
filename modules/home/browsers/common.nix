# browsers 跨平台公共部分（Firefox 配置、扩展、策略）
{
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;

    languagePacks = ["en-US" "zh-CN"];
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
          # adblocker-ultimate
          darkreader
          vimium
          # tampermonkey
          # immersive-translate
        ];
        settings = {
          "extensions.autoDisableScopes" = 0;
        };
      };
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    # "immersive-translate-1.23.9"
  ];

  home.packages = with pkgs; [
    # 播放 html5 视频
    ffmpeg
  ];
}

{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ffmpeg # 播放html5视频
  ];

  programs.firefox = {
    enable = true;
    # package = config.lib.nixGL.wrap pkgs.firefox-devedition-bin;
    package = config.lib.nixGL.wrap pkgs.firefox;
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
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          adblocker-ultimate
          darkreader
          vimium
          tampermonkey
          translate-web-pages
          gruvbox-dark-theme
          kristofferhagen-nord-theme
        ];
        settings = {
          "extensions.autoDisableScopes" = 0;
        };
      };

    };
  };
}

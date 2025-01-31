{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:
let
  isNixOS = builtins.pathExists /etc/nixos;
in

{
  programs.firefox = {
    enable = true;
    # package = config.lib.nixGL.wrap pkgs.firefox-devedition-bin;

    package = lib.mkDefault (
      if isNixOS
      then pkgs.firefox
      else (config.lib.nixGL.wrap pkgs.firefox)
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

  home.packages = with pkgs; [
    ffmpeg # 播放html5视频

    # planB
    (pkgs.symlinkJoin {
      name = "google-chrome";
      paths = [ pkgs.google-chrome ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/google-chrome-stable \
        --add-flags --ozone-platform=wayland \
        --add-flags --enable-wayland-ime  \
      '';
    })

  ];

}

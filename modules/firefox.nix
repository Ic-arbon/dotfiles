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
    package = config.lib.nixGL.wrap pkgs.firefox-devedition-bin;
    # languagePacks = [ "en-US" "zh-CN"];
  };
}

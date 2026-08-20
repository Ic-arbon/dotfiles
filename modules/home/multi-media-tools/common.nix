# multi-media-tools 跨平台公共部分
{pkgs, ...}: {
  home.packages = with pkgs; [
    mpv
    moonlight-qt
  ];
}

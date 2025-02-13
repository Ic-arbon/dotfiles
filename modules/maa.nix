{pkgs, ...}:
{
  home.packages = with pkgs; [
    maa-cli
    maa-assistant-arknights
    android-tools
  ];
}

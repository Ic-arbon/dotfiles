{pkgs, ...}: {
  home.packages = with pkgs; [
    asusctl
    power-profiles-daemon
    supergfxctl
  ];
}

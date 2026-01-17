{ config, pkgs, pkgs-stable, pkgs-unstable, ... }:{
  home.packages = with pkgs; [
    pnpm
    kubo
  ];
}

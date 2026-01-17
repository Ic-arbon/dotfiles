{ config, pkgs, pkgs-unstable, ... }:
{
  home.packages = [
    pkgs-unstable.daed
  ];
}

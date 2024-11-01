{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ dae ];
}

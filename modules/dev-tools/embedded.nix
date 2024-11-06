{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stm32cubemx
  ];
}

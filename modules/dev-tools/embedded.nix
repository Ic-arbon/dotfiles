{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # toolchain
    gcc-arm-embedded
    # code generator
    stm32cubemx
    # debug
    segger-ozone
  ];
}

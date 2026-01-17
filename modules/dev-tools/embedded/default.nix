{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # HARDWARE DESIGN
    # (config.lib.nixGL.wrap pkgs.kicad)
    # easyeda2kicad

    # toolchain
    # fix https://github.com/NixOS/nixpkgs/issues/303651
    clang-tools
    clang
    gcc-arm-embedded
    # glibc_multi
    # code generator
    # debug
    # gdb
    openocd
    # gcc-arm-embedded-10
    # glibc_multi
    cmake
    # gnumake

    # code generator
    # stm32cubemx

    # debug
    # gdb
    # openocd
    tio
    # minicom
    # (config.lib.nixGL.wrap pkgs.pulseview)
    # libsigrok
    # (import ./scripts/udev {inherit pkgs;})
    # segger-ozone
    # gtkwave

    # platformio
    # vscode
  ];

  # xdg.configFile = {
  #   "nvim/lua/plugins/embedded-override.lua" = {
  #     text = ''
  #     return {
  #       {
  #         "jedrzejboczar/nvim-dap-cortex-debug",
  #         opts = function(_, opts)
  #           local dap = require("dap")
  #           
  #           -- 如果dap.configurations.c还不存在,初始化它为空table
  #           dap.configurations.c = dap.configurations.c or {}
  #           
  #           -- 修改第一个配置的toolchainPath
  #           if dap.configurations.c[1] then
  #             dap.configurations.c[1].toolchainPath = "${pkgs.gcc-arm-embedded}/bin"
  #           end
  #           
  #           -- 确保C++配置与C配置保持同步
  #           dap.configurations.cpp = dap.configurations.c
  #         end,
  #       },
  #     }
  #     '';
  #   };
  # };
}

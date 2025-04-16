{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # toolchain
    # fix https://github.com/NixOS/nixpkgs/issues/303651
    clang-tools
    gcc-arm-embedded-10
    glibc_multi
    # code generator
    # debug
    gdb
    openocd
    minicom
    (import ./scripts/udev {inherit pkgs;})
    # platformio
    # vscode
  ];

  xdg.configFile = {
    "nvim/lua/plugins/embedded-override.lua" = {
      text = ''
      return {
        {
          "jedrzejboczar/nvim-dap-cortex-debug",
          opts = function(_, opts)
            local dap = require("dap")
            
            -- 如果dap.configurations.c还不存在,初始化它为空table
            dap.configurations.c = dap.configurations.c or {}
            
            -- 修改第一个配置的toolchainPath
            if dap.configurations.c[1] then
              dap.configurations.c[1].toolchainPath = "${pkgs.gcc-arm-embedded-10}/bin"
            end
            
            -- 确保C++配置与C配置保持同步
            dap.configurations.cpp = dap.configurations.c
          end,
        },
      }
      '';
    };
  };
}

return {
  -- Install required plugins
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Add cortex-debug to ensure_installed
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "cortex-debug")
    end,
  },
  -- Configure dap
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Add the cortex-debug dap extension
      {
        "jedrzejboczar/nvim-dap-cortex-debug",
        config = function()
          require("dap-cortex-debug").setup {
            -- Debug logs if needed
            debug = false,
            -- Uses mason's cortex-debug installation
            extension_path = nil,
            -- Register nvim-dap-ui RTT element
            dapui_rtt = true,
            -- Register cortex-debug for C/C++
            dap_vscode_filetypes = { "c", "cpp", "rust" },
          }
        end,
      },
    },
    opts = function()
      local dap = require "dap"
      local dap_cortex_debug = require "dap-cortex-debug"

      -- Configure debug adapter for embedded development
      dap.configurations.c = {
        dap_cortex_debug.openocd_config {
          name = "Debug with OpenOCD",
          toolchainPath = "~/.nix-profile/bin",
          -- Set working directory
          cwd = "${workspaceFolder}",
          -- Path to your executable
          executable = "${workspaceFolder}/build/${workspaceFolderBasename}.elf",
          -- OpenOCD config files
          configFiles = {
            -- Add your openocd config files here
            "${workspaceFolder}/openocd.cfg",
          },
          -- OpenOCD GDB port
          gdbTarget = "localhost:3333",
          -- Enable RTT logging
          rttConfig = dap_cortex_debug.rtt_config(0),
          -- Show OpenOCD output for debugging
          showDevDebugOutput = false,
        },
      }
      -- Use same config for C++
      dap.configurations.cpp = dap.configurations.c
    end,
  },
  -- Configure DAP UI
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        {
          elements = {
            -- Add scopes and RTT view
            { id = "scopes", size = 0.4 },
            { id = "rtt", size = 0.6 },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            "repl",
            "console",
          },
          position = "bottom",
          size = 10,
        },
      },
    },
  },
}

return {
  { import = "astrocommunity.pack.cpp" },
  -- 添加覆盖配置
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
        clangd = {
          capabilities = {
            offsetEncoding = "utf-8",
          },
          -- 配置系统 clangd
          cmd = { "clangd" },
          -- 禁用自动安装
          mason = false,
        },
      })
      -- 确保 clangd 在服务器列表中
      opts.servers = require("astrocore").list_insert_unique(opts.servers or {}, { "clangd" })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      -- 从 ensure_installed 中移除 clangd
      opts.ensure_installed = vim.tbl_filter(
        function(server) return server ~= "clangd" end,
        opts.ensure_installed or {}
      )
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      -- 从 ensure_installed 中移除 clangd
      opts.ensure_installed = vim.tbl_filter(function(tool) return tool ~= "clangd" end, opts.ensure_installed or {})
    end,
  },
}

-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- { import = "astrocommunity.completion.copilot-cmp" },
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  { import = "astrocommunity.pack.markdown" },

  { import = "astrocommunity.pack.lua" },

  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.cmake" },
  { import = "astrocommunity.pack.rust" },

  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.kotlin" },
  { import = "astrocommunity.pack.xml" },

  { import = "astrocommunity.pack.verilog" },
  -- import/override with your plugins folder
}

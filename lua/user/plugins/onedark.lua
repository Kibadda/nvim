return {
  "olimorris/onedarkpro.nvim",
  lazy = false,
  priority = 1000,
  enabled = false,
  opts = {
    highlights = {
      ["@field.lua"] = { link = "@keyword" },
    },
    options = {
      transparency = true,
    },
  },
  config = function(_, opts)
    require("onedarkpro").setup(opts)
    vim.cmd.colorscheme "onedark"
  end,
}

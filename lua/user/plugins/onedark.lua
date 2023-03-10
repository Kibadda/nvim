local M = {
  "olimorris/onedarkpro.nvim",
  lazy = false,
  priority = 1000,
  enabled = false,
}

function M.config()
  require("onedarkpro").setup {
    highlights = {
      ["@field.lua"] = { link = "@keyword" },
    },
    options = {
      transparency = true,
    },
  }

  vim.cmd.colorscheme "onedark"
end

return M

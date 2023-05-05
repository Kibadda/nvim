return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  enabled = false,
  opts = {
    transparent = true,
    overrides = function()
      return {
        TelescopeBorder = { bg = "none" },
        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
        StatusLine = { bg = "none" },
        GitsignsAdd = { bg = "none" },
        GitsignsChange = { bg = "none" },
        GitsignsDelete = { bg = "none" },
        SignColumn = { bg = "none" },
        DiagnosticSignError = { bg = "none" },
        DiagnosticSignWarn = { bg = "none" },
        DiagnosticSignInfo = { bg = "none" },
        DiagnosticSignHint = { bg = "none" },
      }
    end,
    theme = "dragon",
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd.colorscheme "kanagawa-dragon"
  end,
}

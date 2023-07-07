return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    require("user.themes").register("kanagawa", function()
      require("kanagawa").setup {
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
            StatusLineNC = { bg = "none" },
            FoldColumn = { bg = "none" },
            DiagnosticSignError = { bg = "none" },
            DiagnosticSignWarn = { bg = "none" },
            DiagnosticSignInfo = { bg = "none" },
            DiagnosticSignHint = { bg = "none" },
          }
        end,
      }

      vim.cmd.colorscheme "kanagawa-wave"
    end)
  end,
}

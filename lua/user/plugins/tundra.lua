return {
  "sam4llis/nvim-tundra",
  lazy = false,
  priority = 1000,
  opts = {
    transparent_background = true,
    overwrite = {
      highlights = {
        NormalFloat = { link = "Normal" },
        SpellBad = { sp = "#FCA5A5", fg = "NONE", bg = "NONE", bold = true, undercurl = true },
        SpellCap = { sp = "#FBC19D", fg = "NONE", bg = "NONE", bold = true, undercurl = true },
        SpellRare = { sp = "#A5B4FC", fg = "NONE", bg = "NONE", bold = true, undercurl = false, underline = true },
        SpellLocal = { sp = "#A5B4FC", fg = "NONE", bg = "NONE", bold = true, undercurl = false, underline = true },
      },
    },
  },
  config = function(_, opts)
    require("nvim-tundra").setup(opts)
    vim.cmd.colorscheme "tundra"

    vim.cmd.hi { args = { "link", "DiagnosticFloatingError", "DiagnosticError" }, bang = true }
    vim.cmd.hi { args = { "link", "DiagnosticFloatingWarn", "DiagnosticWarn" }, bang = true }
    vim.cmd.hi { args = { "link", "DiagnosticFloatingInfo", "DiagnosticInfo" }, bang = true }
    vim.cmd.hi { args = { "link", "DiagnosticFloatingHint", "DiagnosticHint" }, bang = true }
    vim.cmd.hi { args = { "link", "DiagnosticFloatingOk", "DiagnosticOk" }, bang = true }
  end,
}

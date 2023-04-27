return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  enabled = false,
  opts = {
    transparent = true,
    sidebars = {},
    styles = "storm",
    on_highlights = function(highlights)
      highlights.NormalFloat.bg = "NONE"
      highlights.TelescopeNormal.bg = "NONE"
      highlights.TelescopeBorder.bg = "NONE"
      highlights.FloatBorder.bg = "NONE"
      highlights.WhichKeyFloat.bg = "NONE"
      highlights.NeoTreeNormal.bg = "NONE"
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme "tokyonight"
  end,
}

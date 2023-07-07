return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    require("user.themes").register("tokyonight", function()
      require("tokyonight").setup {
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
      }

      vim.cmd.colorscheme "tokyonight"
    end)
  end,
}

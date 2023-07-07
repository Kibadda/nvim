return {
  "sam4llis/nvim-tundra",
  lazy = false,
  priority = 1000,
  init = function()
    require("user.themes").register("tundra", function()
      require("nvim-tundra").setup {
        transparent_background = true,
        overwrite = {
          highlights = {
            NormalFloat = { link = "Normal" },
          },
        },
      }
      vim.cmd.colorscheme "tundra"
    end)
  end,
}

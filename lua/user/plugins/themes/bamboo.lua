return {
  "ribru17/bamboo.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    require("user.themes").register("bamboo", function()
      require("bamboo").setup {
        transparent = true,
      }

      vim.cmd.colorscheme "bamboo"
    end)
  end,
}

return {
  "ribru17/bamboo.nvim",
  enabled = false,
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
  },
  config = function(_, opts)
    require("bamboo").setup(opts)
    vim.cmd.colorscheme "bamboo"
  end,
}

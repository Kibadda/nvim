return {
  "ofirgall/ofirkai.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("ofirkai").setup {}
    vim.cmd.colorscheme "ofirkai"
  end,
  enabled = false,
}

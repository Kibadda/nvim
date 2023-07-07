return {
  "ofirgall/ofirkai.nvim",
  enabled = false,
  lazy = false,
  priority = 1000,
  config = function()
    require("ofirkai").setup {}
    vim.cmd.colorscheme "ofirkai"
  end,
}

return {
  "ofirgall/ofirkai.nvim",
  lazy = false,
  priority = 1000,
  enabled = false,
  config = function()
    require("ofirkai").setup {}
    vim.cmd.colorscheme "ofirkai"
  end,
}

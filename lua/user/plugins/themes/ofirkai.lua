return {
  "ofirgall/ofirkai.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    require("user.themes").register("ofirkai", function()
      require("ofirkai").setup {}

      vim.cmd.colorscheme "ofirkai"
    end)
  end,
}

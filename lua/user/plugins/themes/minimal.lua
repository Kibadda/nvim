return {
  "Yazeed1s/minimal.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    require("user.themes").register("minimal", function()
      vim.cmd.colorscheme "minimal"
    end)
  end,
}

return {
  "Bekaboo/dropbar.nvim",
  lazy = false,
  keys = {
    {
      "<Leader>d",
      function()
        require("dropbar.api").pick()
      end,
      desc = "Dropbar",
    },
  },
  opts = true,
}

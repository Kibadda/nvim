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
  opts = {
    general = {
      enable = function()
        return not vim.g.started_as_db_client
      end,
    },
  },
}

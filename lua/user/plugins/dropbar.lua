return {
  "Bekaboo/dropbar.nvim",
  enabled = false,
  event = "VeryLazy",
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
      enable = function(buf, win)
        return not vim.g.started_as_db_client
          and not vim.api.nvim_win_get_config(win).zindex
          and vim.bo[buf].buftype == ""
          and vim.api.nvim_buf_get_name(buf) ~= ""
          and not vim.wo[win].diff
      end,
    },
  },
}

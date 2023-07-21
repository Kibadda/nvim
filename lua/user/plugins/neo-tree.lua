return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  branch = "v3.x",
  cmd = "Neotree",
  keys = {
    { "<Leader>e", "<Cmd>Neotree reveal<CR>", desc = "Open/Focus Neotree" },
    { "<Leader>E", "<Cmd>Neotree close<CR>", desc = "Close Neotree" },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = "single",
    window = {
      -- position = "right",
      width = 50,
    },
    filesystem = {
      follow_current_file = true,
    },
  },
}

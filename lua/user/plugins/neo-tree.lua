return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  branch = "v2.x",
  cmd = "Neotree",
  enabled = false,
  opts = {
    close_if_last_window = true,
    popup_border_style = "single",
    window = {
      position = "right",
      width = 50,
    },
    filesystem = {
      follow_current_file = true,
    },
  },
  init = function()
    require("user.utils").keymaps {
      n = {
        ["<Leader>"] = {
          e = { "<Cmd>Neotree reveal<CR>", "Open/Focus Neotree" },
          E = { "<Cmd>Neotree close<CR>", "Close Neotree" },
        },
      },
    }
  end,
}

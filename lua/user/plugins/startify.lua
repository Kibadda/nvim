local M = {
  "mhinz/vim-startify",
  dependencies = {
    {
      "Kibadda/projectodo.nvim",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      dev = true,
    },
  },
  lazy = false,
  priority = 999,
  enabled = false,
}

function M.init()
  require("user.utils.register").keymaps {
    n = {
      ["<Leader>"] = {
        S = {
          name = "Startify",
          c = { "<Cmd>SClose<CR>", "Close" },
          l = { "<Cmd>SLoad<CR>", "Load" },
          d = { "<Cmd>SDelete<CR>", "Delete" },
          s = { "<Cmd>SSave<CR>", "Save" },
        },
      },
    },
  }
end

function M.config()
  require("user.utils").set_global_options({
    session_persistence = true,
    session_before_save = {
      "silent! Neotree close",
    },
    change_to_vcs_root = true,
    custom_header = vim.fn["startify#pad"] {
      "┌───────────────────────────────────────────────────────┐",
      "│                                                       │",
      "│  ██┐  ██┐██┐██████┐  █████┐ ██████┐ ██████┐  █████┐   │",
      "│  ██│ ██┌┘██│██┌──██┐██┌──██┐██┌──██┐██┌──██┐██┌──██┐  │",
      "│  █████┌┘ ██│██████┌┘███████│██│  ██│██│  ██│███████│  │",
      "│  ██┌─██┐ ██│██┌──██┐██┌──██│██│  ██│██│  ██│██┌──██│  │",
      "│  ██│ └██┐██│██████┌┘██│  ██│██████┌┘██████┌┘██│  ██│  │",
      "│  └─┘  └─┘└─┘└─────┘ └─┘  └─┘└─────┘ └─────┘ └─┘  └─┘  │",
      "│                                                       │",
      "└───────────────────────────────────────────────────────┘",
    },
    lists = require("projectodo").get_sections(),
  }, "startify")
end

return M

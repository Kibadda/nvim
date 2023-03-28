return {
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
  opts = function()
    return {
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
    }
  end,
  init = function()
    require("user.utils").keymaps {
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
  end,
  config = function(_, opts)
    require("user.utils").set_global_options(opts, "startify")
  end,
}

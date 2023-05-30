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
  keys = {
    { "<Leader>Sc", "<Cmd>SClose<CR>", desc = "Close" },
    { "<Leader>Sl", "<Cmd>SLoad<CR>", desc = "Load" },
    { "<Leader>Sd", "<Cmd>SDelete<CR>", desc = "Delete" },
    { "<Leader>Ss", "<Cmd>SSave<CR>", desc = "Save" },
  },
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
      -- lists = require("projectodo").get_sections(),
    }
  end,
  config = function(_, opts)
    require("user.utils").set_global_options(opts, "startify")
  end,
  enabled = false,
}

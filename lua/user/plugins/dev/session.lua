local M = {
  "Kibadda/session.nvim",
  dev = true,
  lazy = false,
  priority = 1000,
}

function M.init()
  require("user.utils").keymaps {
    n = {
      ["<Leader>"] = {
        S = {
          name = "Session",
          n = {
            function()
              require("session.core").new()
            end,
            "New",
          },
          l = {
            function()
              require("session.telescope").list()
            end,
            "List",
          },
        },
      },
    },
  }
end

M.opts = {
  hooks = {
    pre = {
      save = function()
        pcall(vim.cmd.argdelete, "*")
        vim.cmd.Neotree "close"
      end,
      load = function()
        vim.cmd.LspStop()
      end,
    },
    post = {
      load = function()
        vim.cmd.clearjumps()
        vim.cmd.LspRestart()
      end,
    },
  },
}

return M

return {
  "Kibadda/session.nvim",
  dev = true,
  keys = {
    {
      "<Leader>Sn",
      function()
        require("session").new()
      end,
      desc = "New",
    },
    {
      "<Leader>Sl",
      function()
        MiniPick.start {
          source = {
            items = require("session").list(),
            choose = require("session").load,
          },
          mappings = {
            load = {
              char = "<M-l>",
              func = require("session").load,
            },
            delete = {
              char = "<M-d>",
              func = function(item)
                require("session").delete(item)
                MiniPick.refresh()
              end,
            },
          },
        }
      end,
      desc = "List",
    },
  },
  opts = {
    hooks = {
      pre = {
        save = function()
          pcall(vim.cmd.argdelete, "*")
        end,
        load = function()
          vim.lsp.stop_client(vim.lsp.get_clients())
        end,
      },
      post = {
        load = function()
          vim.cmd.clearjumps()
        end,
      },
    },
  },
}

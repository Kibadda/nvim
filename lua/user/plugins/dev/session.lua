return {
  "Kibadda/session.nvim",
  dev = true,
  keys = {
    {
      "<Leader>Sn",
      function()
        require("session.core").new()
      end,
      desc = "New",
    },
    {
      "<Leader>Sl",
      function()
        require("session.core").list()
      end,
      desc = "List",
    },
  },
  opts = {
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
        end,
      },
    },
  },
}

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
        require("session.telescope").list()
      end,
      desc = "List",
    },
  },
  opts = {
    hooks = {
      pre = {
        save = function()
          pcall(vim.cmd.argdelete, "*")

          if vim.fn.exists ":Neotree" > 0 then
            vim.cmd.Neotree "close"
          end
        end,
        load = function()
          if vim.fn.exists ":LspStop" > 0 then
            vim.cmd.LspStop()
          end
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

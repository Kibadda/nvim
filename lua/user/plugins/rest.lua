local M = {
  "rest-nvim/rest.nvim",
  keys = { "<Leader>Hr", "<Leader>Hp", "<Leader>Hl" },
}

function M.init()
  require("user.utils.register").keymaps {
    n = {
      ["<Leader>"] = {
        H = {
          name = "Http",
          r = {
            function()
              require("rest-nvim").run()
            end,
            "Run request",
          },
          p = {
            function()
              require("rest-nvim").run(true)
            end,
            "Preview command",
          },
          l = {
            function()
              require("rest-nvim").last()
            end,
            "Run last request",
          },
        },
      },
    },
  }
end

M.opts = {
  skip_ssl_verification = true,
}

return M

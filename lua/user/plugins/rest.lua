return {
  "rest-nvim/rest.nvim",
  ft = "http",
  opts = {
    skip_ssl_verification = true,
  },
  init = function()
    require("user.utils").keymaps {
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
  end,
}

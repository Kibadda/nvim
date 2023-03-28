return {
  "toppair/peek.nvim",
  build = "deno task --quiet build:fast",
  ft = "markdown",
  opts = {
    update_on_change = false,
  },
  init = function()
    require("user.utils").keymaps {
      n = {
        ["<Leader>"] = {
          m = {
            name = "Markdown",
            p = {
              function()
                require("peek").open()
              end,
              "Start",
            },
            s = {
              function()
                require("peek").close()
              end,
              "Stop",
            },
          },
        },
      },
    }
  end,
}

return {
  "sam4llis/nvim-tundra",
  lazy = false,
  priority = 1000,
  enabled = true,
  opts = {
    transparent_background = true,
    overwrite = {
      highlights = {
        NormalFloat = { link = "Normal" },
      },
    },
  },
  init = function()
    require("user.utils").keymaps {
      n = {
        ["<Leader>"] = {
          a = {
            function()
              require("nvim-tundra.commands").toggle_transparency()

              os.execute(
                ("kitty @ --to %s set-background-opacity %s"):format(
                  vim.env.KITTY_LISTEN_ON,
                  vim.g.tundra_opts.transparent_background and 0.9 or 1
                )
              )
            end,
            "Toggle transparent background",
          },
        },
      },
    }
  end,
  config = function(_, opts)
    require("nvim-tundra").setup(opts)
    vim.cmd.colorscheme "tundra"
  end,
}

return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "tpope/vim-dotenv",
    "MunifTanjim/nui.nvim",
  },
  enabled = true,
  build = function()
    require("dbee").install "curl"
  end,
  init = function()
    require("user.utils").keymaps {
      n = {
        ["<Leader>"] = {
          D = {
            name = "DB",
            o = {
              function()
                if vim.fn.filereadable ".db.env" == 1 then
                  require("dbee").open()
                end
              end,
              "open",
            },
            c = {
              function()
                require("dbee").close()
              end,
              "close",
            },
          },
        },
      },
    }
  end,
  config = function()
    vim.cmd.Dotenv ".db.env"

    require("dbee").setup {
      lazy = false,
      connections = {
        {
          name = vim.env.DB_NAME,
          type = vim.env.DB_DRIVER,
          url = vim.env.DB_USER .. ":" .. vim.env.DB_PASS .. "@" .. vim.env.DB_HOST .. "/" .. vim.env.DB_NAME,
        },
      },
      extra_helpers = {
        mysql = {
          List = "SELECT * FROM {table} LIMIT 500",
        },
      },
      drawer = {
        window_command = "to 60vsplit",
      },
      result = {
        window_command = "bo 30split",
      },
      editor = {
        mappings = {
          run_file = { key = "<C-CR>", mode = "n" },
          run_selection = { key = "<C-CR>", mode = "v" },
        },
      },
    }
  end,
}

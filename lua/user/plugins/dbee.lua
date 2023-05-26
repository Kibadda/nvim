return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
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
                require("dbee").open()
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
    local path = vim.fn.stdpath "cache" .. "/dbee/connections.json"

    if vim.fn.filereadable(path) == 0 then
      os.execute("mkdir -p " .. vim.fs.dirname(path))
      os.execute("touch " .. path)
    end

    require("dbee").setup {
      lazy = false,
      sources = {
        require("dbee.sources").FileSource:new(vim.fn.stdpath "cache" .. "/dbee/connections.json"),
      },
      extra_helpers = {
        mysql = {
          ["List All"] = { "SELECT * FROM `{table}`" },
        },
      },
      editor = {
        mappings = {
          run_file = { key = "<C-CR>", mode = "n" },
          run_selection = { key = "<C-CR>", mode = "v" },
        },
      },
      ui = {
        window_commands = {
          drawer = "to 60vsplit",
          result = "bo 30split",
        },
      },
    }
  end,
}

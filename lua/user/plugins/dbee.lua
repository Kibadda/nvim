return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    require("dbee").install "curl"
  end,
  init = function()
    if vim.g.started_as_db_client then
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.opt.showtabline = 0
          vim.opt.signcolumn = "no"
          vim.opt.number = false
          vim.opt.relativenumber = false
          vim.opt.statuscolumn = ""
          vim.opt.winbar = nil

          vim.keymap.set("n", "q", function()
            require("dbee").close()
            vim.cmd.quitall { bang = true }
          end)

          require("dbee").open()
        end,
      })
    end
  end,
  opts = function()
    local path = vim.fn.stdpath "cache" .. "/dbee/connections.json"

    if vim.fn.filereadable(path) == 0 then
      vim.system { "mkdir", "-p", vim.fs.dirname(path) }
      vim.system { "touch", path }
    end

    return {
      lazy = false,
      sources = {
        require("dbee.sources").FileSource:new(vim.fn.stdpath "cache" .. "/dbee/connections.json"),
      },
      drawer = {
        disable_help = true,
        mappings = {
          quit = false,
        },
      },
      editor = {
        mappings = {
          run_file = false,
          run_selection = { key = "<C-CR>", mode = "v" },
        },
      },
    }
  end,
}

return {
  "echasnovski/mini.pick",
  dependencies = {
    "echasnovski/mini.extra",
  },
  cmd = "Pick",
  keys = {
    { "<Leader>f", "<Cmd>Pick files<CR>", desc = "Find Files" },
    { "<Leader>F", "<Cmd>Pick all_files<CR>", desc = "Find All Files" },
    { "<Leader>sg", "<Cmd>Pick grep_live<CR>", desc = "Live Grep" },
    { "<Leader>sh", "<Cmd>Pick help<CR>", desc = "Help" },
    { "<Leader>sr", "<Cmd>Pick resume<CR>", desc = "Resume" },
    { "<M-e>", "<Cmd>Pick emoji<CR>", desc = "Emoji", mode = "i" },
    { "<Leader>e", "<Cmd>Pick explorer<CR>", desc = "Explorer" },
    { "<Leader>E", "<Cmd>Pick explorer cwd='%:p:h'<CR>", desc = "Explorer Current" },
    { "<Leader>sH", "<Cmd>Pick hl_groups<CR>", desc = "Highlights" },
    { "<Leader>sp", "<Cmd>Pick explorer cwd='./lua/user/plugins'<CR>", desc = "Plugin" },
    { "<Leader>ss", "<Cmd>Pick explorer cwd='./scratch'<CR>", desc = "Scratch Files" },
  },
  opts = {
    mappings = {
      move_down = "<C-j>",
      move_up = "<C-k>",
    },
    window = {
      config = function()
        local height = math.floor(0.618 * vim.o.lines)
        local width = math.floor(0.618 * vim.o.columns)
        return {
          anchor = "NW",
          height = height,
          width = width,
          row = math.floor(0.5 * (vim.o.lines - height)),
          col = math.floor(0.5 * (vim.o.columns - width)),
        }
      end,
    },
  },
  init = function()
    ---@diagnostic disable-next-line:duplicate-set-field
    function vim.ui.select(...)
      require("mini.pick").ui_select(...)
    end

    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("MiniExtraExplorerOnDirectoryEdit", { clear = true }),
      pattern = "*/",
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.bdelete()
          require "mini.extra"
          require("mini.pick").registry.explorer { cwd = vim.fn.fnamemodify(data.file, ":.") }
        end
      end,
    })
  end,
  config = function(_, opts)
    require("mini.pick").setup(opts)
    require("mini.extra").setup()

    MiniPick.registry.registry = require "user.plugins.mini-pick.registry"
    MiniPick.registry.emoji = require "user.plugins.mini-pick.emoji"
    MiniPick.registry.all_files = require "user.plugins.mini-pick.all_files"
    MiniPick.registry.explorer = require "user.plugins.mini-pick.explorer"
  end,
}

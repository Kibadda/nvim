return {
  "echasnovski/mini.pick",
  cmd = "Pick",
  keys = {
    { "<Leader>f", "<Cmd>Pick files<CR>", desc = "Find Files" },
    { "<Leader>F", "<Cmd>Pick files tool='fallback'<CR>", desc = "Find All Files" },
    { "<Leader>b", "<Cmd>Pick buffers<CR>", desc = "Buffers" },
    { "<Leader>sg", "<Cmd>Pick grep_live<CR>", desc = "Live Grep" },
    { "<Leader>sh", "<Cmd>Pick help<CR>", desc = "Help" },
    { "<Leader>sH", "<Cmd>Pick hl_groups<CR>", desc = "Highlights" },
    { "<Leader>sr", "<Cmd>Pick resume<CR>", desc = "Resume" },
    { "<Leader>sb", "<Cmd>Pick registry<CR>", desc = "Builtin" },
    { "<M-e>", "<Cmd>Pick emoji<CR>", desc = "Emoji", mode = "i" },
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
    vim.ui.select = function(...)
      require("mini.pick").ui_select(...)
    end
  end,
  config = function(_, opts)
    require("mini.pick").setup(opts)

    MiniPick.registry.registry = require "user.plugins.mini-pick.registry"
    MiniPick.registry.emoji = require "user.plugins.mini-pick.emoji"
  end,
}

return {
  "echasnovski/mini.pick",
  cmd = "Pick",
  keys = {
    { "<Leader>f", "<Cmd>Pick files<CR>", desc = "Find Files" },
    { "<Leader>F", "<Cmd>Pick files tool='fallback'<CR>", desc = "Find All Files" },
    { "<Leader>b", "<Cmd>Pick buffers<CR>", desc = "Buffers" },
    { "<Leader>e", "<Cmd>Pick explorer<CR>", desc = "Explorer" },
    { "<Leader>E", "<Cmd>Pick explorer cwd='%:p:h'<CR>", desc = "Explorer Current" },
    { "<Leader>sg", "<Cmd>Pick grep_live<CR>", desc = "Live Grep" },
    { "<Leader>sh", "<Cmd>Pick help<CR>", desc = "Help" },
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
    local group = vim.api.nvim_create_augroup("OpenPickFindFilesIfDirectory", { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.cd(data.file)
          vim.cmd.argdelete "*"
          vim.cmd.bdelete()
          vim.cmd.Pick "explorer"
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      pattern = "*/",
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.bdelete()
          vim.cmd {
            cmd = "Pick",
            args = { "explorer", "cwd='" .. vim.fn.fnamemodify(data.file, ":h:p") .. "'" },
          }
        end
      end,
    })

    ---@diagnostic disable-next-line:duplicate-set-field
    vim.ui.select = function(...)
      require "mini.pick"
      vim.ui.select = MiniPick.ui_select
      vim.ui.select(...)
    end
  end,
  config = function(_, opts)
    require("mini.pick").setup(opts)

    MiniPick.registry.registry = require "user.plugins.mini-pick.registry"
    MiniPick.registry.emoji = require "user.plugins.mini-pick.emoji"
  end,
}

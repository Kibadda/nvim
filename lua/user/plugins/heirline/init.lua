return {
  "rebelot/heirline.nvim",
  event = "VimEnter",
  opts = function()
    local statuscolumn = require "user.plugins.heirline.statuscolumn"
    local statusline = require "user.plugins.heirline.statusline"
    local winbar = require "user.plugins.heirline.winbar"
    -- local tabline = require "user.plugins.heirline.tabline"

    -- local utils = require "heirline.utils"
    -- local colors = require "nvim-tundra.palette.arctic"

    local align = { provider = "%=", hl = { bg = "" } }
    local space = { provider = " " }
    local bar = { provider = " | " }

    return {
      statuscolumn = {
        statuscolumn.diagnostics,
        align,
        statuscolumn.line_numbers,
        statuscolumn.gitsigns,
      },
      statusline = {
        init = function(self)
          self.mode = vim.fn.mode()
        end,
        static = {
          -- colors = colors,
          modes = {
            names = {
              n = "NORMAL",
              v = "VISUAL",
              V = "VISUAL",
              ["\22"] = "VISUAL",
              s = "SELECT",
              S = "SELECT",
              ["\19"] = "SELECT",
              i = "INSERT",
              R = "REPLACE",
              c = "COMMAND",
              r = "CONFIRM",
              ["!"] = "TERMINAL",
              t = "TERMINAL",
            },
            colors = {
              NORMAL = { bg = "#28304D", fg = "#9CA3AF", bold = true },
              VISUAL = { bg = "#FBC19D", fg = "#28304D", bold = true },
              SELECT = { bg = "#FBC19D", fg = "#28304D", bold = true },
              INSERT = { bg = "#B5E8B0", fg = "#28304D", bold = true },
              REPLACE = { bg = "#E8D4B0", fg = "#28304D", bold = true },
              COMMAND = { bg = "#A5B4FC", fg = "#28304D", bold = true },
              CONFIRM = { bg = "#BF7471", fg = "#28304D", bold = true },
              TERMINAL = { bg = "#28304D", fg = "#9CA3AF", bold = true },
            },
          },
        },
        statusline.mode,
        space,
        statusline.git,
        bar,
        statusline.diagnostics,
        bar,
        statusline.filename,
        align,
        statusline.filetype,
        bar,
        statusline.lsp,
        bar,
        statusline.formatting,
        space,
        statusline.position,
      },
      winbar = {
        space,
        winbar.symbol,
        align,
        winbar.modified,
        space,
        winbar.filepath,
        winbar.lines,
        space,
      },
      -- tabline = {
      --   hl = { bg = "" },
      --   space,
      --   utils.make_buflist(
      --     utils.surround({ "▏ ", " ▕" }, "", {
      --       static = { colors = colors },
      --       tabline.buffer.icon,
      --       space,
      --       tabline.buffer.name,
      --       space,
      --       tabline.buffer.modified,
      --     }),
      --     tabline.truncate.left,
      --     tabline.truncate.right
      --   ),
      --   align,
      --   {
      --     condition = function()
      --       return #vim.api.nvim_list_tabpages() >= 2
      --     end,
      --     utils.make_tablist(tabline.tabpage),
      --   },
      -- },
      opts = {
        disable_winbar_cb = function(args)
          return vim.tbl_contains({ "prompt", "nofile", "help", "quickfix" }, vim.bo[args.buf].buftype)
            or vim.tbl_contains({ "gitcommit", "fugitive" }, vim.bo[args.buf].filetype)
        end,
      },
    }
  end,
}

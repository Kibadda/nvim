return {
  "rebelot/heirline.nvim",
  event = "VimEnter",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },
  opts = function()
    local statuscolumn = require "user.plugins.heirline.statuscolumn"
    local statusline = require "user.plugins.heirline.statusline"

    local align = { provider = "%=", hl = { bg = "" } }
    local space = { provider = " " }

    return {
      statuscolumn = {
        condition = function()
          return vim.bo.buftype == ""
        end,
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
              NORMAL = { bg = "#E8D4B0", fg = "#28304D", bold = true },
              VISUAL = { bg = "#FBC19D", fg = "#28304D", bold = true },
              SELECT = { bg = "#FBC19D", fg = "#28304D", bold = true },
              INSERT = { bg = "#B5E8B0", fg = "#28304D", bold = true },
              REPLACE = { bg = "#28304D", fg = "#9CA3AF", bold = true },
              COMMAND = { bg = "#A5B4FC", fg = "#28304D", bold = true },
              CONFIRM = { bg = "#BF7471", fg = "#28304D", bold = true },
              TERMINAL = { bg = "#E8D4B0", fg = "#28304D", bold = true },
            },
          },
        },
        {
          condition = function()
            return not vim.g.started_as_db_client
          end,
          statusline.mode,
          space,
          statusline.git,
          statusline.diagnostics,
          statusline.filename,
          align,
          statusline.filetype,
          statusline.lsp,
          statusline.formatting,
          space,
          statusline.position,
        },
        {
          condition = function()
            return not not vim.g.started_as_db_client
          end,
          statusline.mode,
          align,
          statusline.position,
        },
      },
    }
  end,
}

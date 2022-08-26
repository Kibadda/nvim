if not pcall(require, "colorbuddy") then
  return
end

require("colorizer").setup {
  "*",
}
require("colorbuddy").colorscheme "gruvbuddy"

local Group = require("colorbuddy.group").Group
local g = require("colorbuddy.group").groups
local s = require("colorbuddy.style").styles

Group.new("CmpItemKind", g.Special)
Group.new("CmpItemMenu", g.NonText)
Group.new("CmpItemAbbr", g.Comment.fg:light())
Group.new("CmpItemAbbrDeprecated", g.Error)
Group.new("CmpItemAbbrMatchFuzzy", g.Comment, nil, s.italic)

vim.api.nvim_set_hl(0, "BufferLineBackground", { fg = "#80a0ff", bg = "#1e2127" })
vim.api.nvim_set_hl(0, "BufferLineFill", { fg = "#80a0ff", bg = "#1e2127" })
vim.api.nvim_set_hl(0, "BufferLineSeparator", { bg = "#1e2127" })

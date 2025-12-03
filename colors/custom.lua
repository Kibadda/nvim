vim.cmd.highlight "clear"
if vim.g.syntax_on then
  vim.cmd.syntax "reset"
end
vim.g.colors_name = "custom"

--- @type table<string, vim.api.keyset.highlight>
local highlights = {
  ["@diff.plus"] = { bg = "#005000" },
  ["@diff.minus"] = { bg = "#500000" },
  ["@keyword"] = { fg = "NvimLightRed" },
  ["@constant"] = { fg = "NvimLightYellow" },
  ["@operator"] = { fg = "NvimLightYellow" },
  ["@boolean"] = { fg = "NvimLightYellow" },

  BrightYellowReverse = { bg = "#e8d4b0", fg = "NvimDarkGrey4", bold = true },
  BrightYellow = { fg = "#e8d4b0" },
  BrightOrangeReverse = { bg = "#fbc19d", fg = "NvimDarkGrey4", bold = true },
  BrightOrange = { fg = "#fbc19d" },
  BrightGreenReverse = { bg = "#b5e8b0", fg = "NvimDarkGrey4", bold = true },
  BrightGreen = { fg = "#b5e8b0" },
  BrightPurpleReverse = { bg = "#dda0dd", fg = "NvimDarkGrey4", bold = true },
  BrightPurple = { fg = "#dda0dd" },
  BrightBlueReverse = { bg = "#a5b4fc", fg = "NvimDarkGrey4", bold = true },
  BrightBlue = { fg = "#a5b4fc" },
  BrightRedReverse = { bg = "#bf7471", fg = "NvimDarkGrey4", bold = true },
  BrightRed = { fg = "#bf7471" },
}

for name, hl in pairs(highlights) do
  vim.api.nvim_set_hl(0, name, hl)
end

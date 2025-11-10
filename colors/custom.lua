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
}

for name, hl in pairs(highlights) do
  vim.api.nvim_set_hl(0, name, hl)
end

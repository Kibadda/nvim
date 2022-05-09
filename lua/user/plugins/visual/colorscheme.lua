-- Lua:
-- For dark theme
vim.g.vscode_style = "dark"
-- Enable transparent background
vim.g.vscode_transparent = 1
-- Enable italic comment
vim.g.vscode_italic_comment = 1
-- Disable nvim-tree background color
vim.g.vscode_disable_nvimtree_bg = true

require('onedark').setup {
  toggle_style_key = '<leader>tc',
}

vim.cmd([[
  colorscheme onedark
]])

vim.g.mapleader = vim.keycode "<Space>"

if vim.loader then
  vim.loader.enable()
end

local set = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return set(mode, lhs, rhs, opts)
end

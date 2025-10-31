--- @diagnostic disable:duplicate-set-field

local set = vim.keymap.set
function vim.keymap.set(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  set(mode, lhs, rhs, opts)
end

function _G.add(mode)
  vim.print(mode)
end

vim.keymap.set("n", "<Leader><Leader>f", function()
  vim.o.operatorfunc = "v:lua.add"
  return "g@ "
end, { expr = true })

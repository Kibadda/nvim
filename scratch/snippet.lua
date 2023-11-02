vim.keymap.set("i", "<C-l>", function()
  vim.snippet.expand "local function ${1:name}(${2})\n\t${0}\nend"
end)

vim.keymap.set({ "i", "n" }, "<C-z>", function()
  if vim.snippet.jumpable(1) then
    return "<Cmd>lua vim.snippet.jump(1)<CR>"
  else
    return "<C-z>"
  end
end, { expr = true })

vim.keymap.set({ "i", "n" }, "<C-S-z>", function()
  if vim.snippet.jumpable(-1) then
    return "<Cmd>lua vim.snippet.jump(-1)<CR>"
  else
    return "<C-S-z>"
  end
end, { expr = true })

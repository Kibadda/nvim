if vim.g.loaded_kanban or vim.env.LOCATION ~= "work" then
  return
end

vim.g.loaded_kanban = 1

vim.keymap.set("n", "<Leader>k", function()
  require("user.kanban").toggle()
end, { desc = "Kanban" })

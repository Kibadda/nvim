if vim.g.loaded_plugin_formatter then
  return
end

vim.g.loaded_plugin_formatter = 1

vim.g.AutoFormat = vim.g.AutoFormat or 0

vim.keymap.set("n", "<Leader>lt", function()
  vim.g.AutoFormat = vim.g.AutoFormat == 0 and 1 or 0
end)

vim.keymap.set("n", "<Leader>lf", function()
  if vim.b.formatter then
    vim.b.formatter()
  end
end)

local group = vim.api.nvim_create_augroup "AutoFormatter"

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function()
    if vim.g.AutoFormat == 1 and vim.b.formatter then
      vim.b.formatter()
    end
  end,
})

local formatter = require "me.formatter"

for _, tool in ipairs(formatter.tools) do
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = tool.filetypes,
    callback = function(args)
      vim.b[args.buf].formatter = function()
        formatter.format(tool)
      end
    end,
  })
end

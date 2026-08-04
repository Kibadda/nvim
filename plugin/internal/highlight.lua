if vim.g.loaded_plugin_highlight then
  return
end

vim.g.loaded_plugin_highlight = 1

local group = vim.api.nvim_create_augroup("HighlightKeywords", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter", "FileType", "ColorScheme" }, {
  group = group,
  callback = function(args)
    require("me.highlight").cmd(args.buf, false)
  end,
})

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
  group = group,
  callback = function(args)
    require("me.highlight").cmd(args.buf, true)
  end,
})

vim.api.nvim_create_autocmd("BufUnload", {
  group = group,
  callback = function(args)
    require("me.highlight").clear(args.buf)
  end,
})

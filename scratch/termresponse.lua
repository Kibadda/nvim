vim.api.nvim_create_autocmd("TermResponse", {
  once = true,
  callback = function(args)
    local resp = args.data
    local r, g, b = resp:match "\x1b%]4;1;rgb:(%w+)/(%w+)/(%w+)"
    print(r, g, b)
  end,
})
io.stdout:write "\x1b]4;1;?\x1b\\"

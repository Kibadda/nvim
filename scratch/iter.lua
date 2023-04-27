vim.print(vim
  .iter({ 1, 2, 3, 4, 5 })
  :map(function(v)
    return v * 3
  end)
  :rev()
  :skip(2)
  :totable())

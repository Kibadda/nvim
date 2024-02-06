if vim.g.loaded_terminal then
  return
end

vim.g.loaded_terminal = 1

local group = vim.api.nvim_create_augroup("Terminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function(args)
    vim.opt_local.filetype = "term"
    vim.opt_local.winbar = ""
    vim.opt_local.statuscolumn = ""
    vim.opt_local.statusline = ""
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.cursorline = false

    vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { buffer = args.buf })
    vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { buffer = args.buf })
    vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { buffer = args.buf })
    vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { buffer = args.buf })

    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_autocmd("TermClose", {
  group = group,
  callback = function(args)
    if not vim.api.nvim_buf_is_valid(args.buf) or vim.bo[args.buf].filetype ~= "term" then
      return
    end

    if table.remove(vim.split(args.file, ":")) == vim.opt.shell:get() then
      vim.cmd.bdelete { bang = true }
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  pattern = "term://*",
  callback = function()
    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_user_command("T", function(args)
  local vertical = false

  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0)

  if height < width / 2.5 then
    vertical = true
  end

  if args.bang then
    vertical = not vertical
  end

  local buf = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_open_win(buf, true, { win = 0, split = vertical and "right" or "below" })
  vim.cmd.terminal { args = args.fargs }
end, {
  nargs = "*",
  complete = "shellcmd",
  bang = true,
  desc = "Opens terminal in split",
})

function OpenTerminal(opts)
  opts = opts or {}
  opts = vim.tbl_extend("keep", opts, {
    vertical = true,
    height = 12,
    program = nil,
    current_file = false,
  })

  local file
  if opts.current_file then
    file = vim.fn.expand "%"
  else
    file = nil
  end

  if opts.vertical then
    vim.cmd [[
      vnew
      wincmd L
      set winfixwidth
    ]]
  else
    vim.cmd [[
      new
      wincmd J
      set winfixheight
    ]]
    vim.api.nvim_win_set_height(0, opts.height)
  end

  if opts.program == nil then
    vim.cmd [[term]]
  elseif vim.fn.executable(opts.program) == 1 then
    if file ~= nil then
      vim.cmd(string.format("term %s %s", opts.program, file))
    else
      vim.cmd(string.format("term %s", opts.program))
    end
  else
    vim.notify(string.format("[TermApp] %s is not an executable", opts.program))
  end
end

vim.keymap.set("n", "<Leader>tr", "<CMD>lua OpenTerminal()<CR>")
vim.keymap.set("n", "<Leader>gg", "<CMD>lua OpenTerminal({program = 'lazygit'})<CR>")
vim.keymap.set("n", "<Leader>rr", "<CMD>lua OpenTerminal({program = 'ranger', current_file = true})<CR>")

function OpenFileFromTerminalApp(opts)
  opts = opts or {}
  opts = vim.tbl_extend("keep", opts, {
    close = true,
    close_key = "q",
    move_key = "",
  })

  if opts.keypresses == nil then
    vim.notify("[TermApp] you need to specify keypresses", "error")
    return
  end
  -- keypresses should result in:
  -- filepath gets copied to system clipboard
  for _, keypress in ipairs(opts.keypresses) do
    vim.api.nvim_chan_send(vim.b.terminal_job_id, keypress)
    vim.cmd [[sleep 100m]]
  end

  -- close term or move out of it
  if opts.close then
    vim.api.nvim_chan_send(vim.b.terminal_job_id, opts.close_key)
    vim.cmd [[sleep 100m]]
  else
    vim.api.nvim_chan_send(vim.b.terminal_job_id, opts.move_key)
    vim.cmd [[sleep 100m]]
  end

  -- get filepath from system clipboard
  local filepath = vim.fn.getreg "+"

  -- modify filepath to be relative to cwd
  filepath = vim.fn.fnamemodify(filepath, ":.")

  if vim.fn.isdirectory(filepath) == 1 then
    vim.notify("[TermApp] Can not open directory", "info")
    return
  end

  vim.cmd("edit " .. filepath)
end

vim.keymap.set("t", "*o", function()
  local termapp = vim.split(vim.fn.expand "%:t", ":")[2]

  if termapp == "lazygit" then
    OpenFileFromTerminalApp { keypresses = { "" } }
  elseif termapp == "ranger" then
    OpenFileFromTerminalApp { keypresses = { "y", "p" } }
  else
    vim.notify "[TermApp] could not find app"
  end
end, { desc = "Open file and close" })

vim.keymap.set("t", "*O", function()
  local termapp = vim.split(vim.fn.expand "%:t", ":")[2]

  if termapp == "lazygit" then
    OpenFileFromTerminalApp { keypresses = { "" }, close = false }
  elseif termapp == "ranger" then
    OpenFileFromTerminalApp { keypresses = { "y", "p" }, close = false }
  else
    vim.notify "[TermApp] could not find app"
  end
end, { desc = "Open file" })
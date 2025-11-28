local function create(opts)
  opts = opts or {}

  if not opts.bufnr or not vim.api.nvim_buf_is_valid(opts.bufnr) then
    opts.bufnr = vim.api.nvim_create_buf(false, false)
  end

  if not opts.win or not vim.api.nvim_win_is_valid(opts.win) then
    opts.win = vim.api.nvim_open_win(opts.bufnr, true, {
      split = "below",
      win = 0,
      height = 25,
    })
  else
    vim.api.nvim_set_current_win(opts.win)
    vim.api.nvim_set_current_buf(opts.bufnr)
  end

  vim.bo[opts.bufnr].filetype = opts.filetype
  vim.bo[opts.bufnr].bufhidden = "wipe"
  vim.bo[opts.bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(opts.bufnr, 0, -1, false, opts.lines)
  vim.bo[opts.bufnr].modifiable = false
  vim.bo[opts.bufnr].modified = false
  vim.wo[opts.win].spell = opts.spell

  pcall(vim.treesitter.start, opts.bufnr, opts.filetype)

  local function cancel()
    if opts.on_cancel then
      opts.on_cancel()
    end
    vim.cmd.stopinsert()
    vim.api.nvim_buf_delete(opts.bufnr, { force = true })
  end

  vim.keymap.set("n", "q", cancel, { buffer = opts.bufnr })
  vim.keymap.set({ "n", "i" }, "<C-c>", cancel, { buffer = opts.bufnr })

  vim.b[opts.bufnr].lsp = opts.lsp
  vim.b[opts.bufnr].cmd = opts.cmd
  vim.b[opts.bufnr].fargs = opts.fargs

  require("me.git.lsp").attach()

  return opts.bufnr
end

local function editor(file, client)
  local socket = ""

  local filetype, spell, lsp
  if file:find "COMMIT_EDITMSG" or file:find "MERGE_MSG" then
    filetype = "gitcommit"
    spell = true
    lsp = require("me.git.commands.commit").lsp
  elseif file:find "git%-rebase%-todo" then
    filetype = "git_rebase"
  elseif file:find "ADD_EDIT.patch" then
    filetype = "diff"
  end

  local cancelled = false

  local bufnr = create {
    filetype = filetype,
    lines = lines,
    spell = spell,
    on_cancel = function()
      cancelled = true
    end,
    lsp = lsp,
  }

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd.w { bang = true }
    if vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] == "" then
      vim.cmd.startinsert()
    end
  end)

  vim.api.nvim_buf_attach(bufnr, false, {
    on_detach = function()
      pcall(vim.treesitter.stop, bufnr)
      vim.rpcnotify()
      vim.fn.chanclose()
    end,
  })
end

local function cmd(stdout)
  local data = {
    lines = stdout,
    extmarks = {},
    keymaps = {},
  }

  if on_buf_load then
    data = vim.tbl_deep_extend("keep", on_buf_load(data.lines), data)
  end

  self.bufnr = create {
    filetype = self.cmd[1],
    lines = data.lines,
    lsp = self.lsp,
    cmd = self.cmd,
    fargs = self.fargs,
  }

  for _, extmark in ipairs(data.extmarks) do
    -- do extmark
  end

  for _, keymap in ipairs(data.keymaps) do
    -- do keymap
  end

  vim.b[self.bufnr].refresh = function()
    if self.can_refresh then
      self:run(self.fargs)
    end
  end

  vim.keymap.set("n", "<C-r>", function()
    vim.b[self.bufnr].refresh()
  end, { buffer = self.bufnr })
end

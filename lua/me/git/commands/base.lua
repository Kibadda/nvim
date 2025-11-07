local M = {
  can_refresh = false,
  show_output_in_buffer = false,
  lsp = {},
  ns = vim.api.nvim_create_namespace "Git",
}
M.__index = M

function M:run(fargs)
  if self.pre_run then
    if self:pre_run(fargs) == false then
      return
    end
  end

  self.fargs = fargs

  require("me.git.utils").run(self.cmd, fargs, function(stdout, code)
    self:on_exit(stdout, code)
  end)
end

function M:complete(arg_lead)
  local split = vim.split(arg_lead, "%s+")

  local completions = self.completions or {}

  if type(completions) == "function" then
    completions = completions(split)
  end

  local complete = vim.tbl_filter(function(opt)
    if vim.tbl_contains(split, opt) then
      return false
    end

    return string.find(opt, "^" .. split[#split]:gsub("%-", "%%-")) ~= nil
  end, completions)

  table.sort(complete)

  return complete
end

function M:ensure_layout()
  if not self.bufnr or not vim.api.nvim_buf_is_valid(self.bufnr) then
    self.bufnr = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(self.bufnr, self.cmd[1])
  end

  if not self.win or not vim.api.nvim_win_is_valid(self.win) then
    self.win = vim.api.nvim_open_win(self.bufnr, true, {
      split = "below",
      win = 0,
      height = 25,
    })
  end
end

function M:on_exit(stdout, code)
  if code ~= 0 then
    vim.notify(table.concat(stdout, "\n"), vim.log.levels.ERROR)
    return
  end

  if not self.show_output_in_buffer then
    vim.notify("Done: " .. table.concat(self.cmd, " "))
    return
  end

  self:ensure_layout()

  local data = {
    lines = stdout,
    extmarks = {},
  }

  if self.on_buf_load then
    data = vim.tbl_deep_extend("keep", self:on_buf_load(data.lines), data)
  end

  vim.bo[self.bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, data.lines)
  vim.bo[self.bufnr].modifiable = false
  vim.bo[self.bufnr].modified = false

  for _, extmark in ipairs(data.extmarks) do
    vim.api.nvim_buf_set_extmark(self.bufnr, self.ns, extmark.line - 1, extmark.col - 1, {
      end_col = extmark.end_col,
      hl_group = extmark.hl,
    })
  end

  vim.bo[self.bufnr].filetype = self.cmd[1]
  vim.bo[self.bufnr].bufhidden = "wipe"
  vim.b[self.bufnr].lsp = self.lsp
  vim.b[self.bufnr].fargs = self.fargs

  pcall(vim.treesitter.start, self.bufnr, self.cmd[1])

  local function cancel()
    vim.cmd.stopinsert()
    vim.api.nvim_buf_delete(self.bufnr, { force = true })
  end

  vim.keymap.set("n", "q", cancel, { buffer = self.bufnr })
  vim.keymap.set({ "i", "n" }, "<C-c>", cancel, { buffer = self.bufnr })

  vim.b[self.bufnr].refresh = function()
    if self.can_refresh then
      self:run(self.fargs)
    end
  end

  vim.keymap.set("n", "<C-r>", function()
    vim.b[self.bufnr].refresh()
  end, { buffer = self.bufnr })

  require("me.git.lsp").attach()
end

function M.new(opts)
  return setmetatable(opts, M)
end

return M

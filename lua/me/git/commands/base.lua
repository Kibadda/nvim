local M = {
  can_refresh = false,
  show_output_in_buffer = false,
  lsp = {},
  ns = vim.api.nvim_create_namespace "Git",
}
M.__index = M

local buffers = {}

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("GitPostRun", { clear = true }),
  pattern = "GitPostRun",
  callback = function(args)
    vim
      .iter(buffers)
      :filter(vim.api.nvim_buf_is_valid)
      :filter(function(bufnr)
        return bufnr ~= args.data.bufnr
      end)
      :each(function(buf)
        vim.b[buf].refresh(false)
      end)
  end,
})

function M:run(fargs, nested)
  if nested ~= false and self.pre_run then
    if self:pre_run(fargs) == false then
      return
    end
  end

  self.fargs = fargs
  self.nested = nested

  require("me.git.utils").run(self.cmd, fargs, function(code, stdout, stderr)
    self:on_exit(code, stdout, stderr)

    if nested ~= false then
      vim.api.nvim_exec_autocmds("User", {
        pattern = "GitPostRun",
        data = {
          bufnr = self.bufnr,
        },
      })
    end
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
    table.insert(buffers, self.bufnr)
  end

  if not self.win or not vim.api.nvim_win_is_valid(self.win) then
    self.win = vim.api.nvim_open_win(self.bufnr, true, {
      split = "below",
      win = 0,
      height = 25,
    })
  elseif self.nested ~= false then
    vim.api.nvim_set_current_win(self.win)
    vim.api.nvim_set_current_buf(self.bufnr)
  end
end

function M:on_exit(code, stdout, stderr)
  if code ~= 0 then
    local message = self.on_error and self:on_error(code, stderr)
      or ("code " .. tostring(code) .. "\n" .. table.concat(stderr, "\n"))

    vim.notify("[ERROR]\n" .. message, vim.log.levels.ERROR)

    return
  end

  if
    not self.show_output_in_buffer
    or (type(self.show_output_in_buffer) == "function" and not self.show_output_in_buffer(stdout))
  then
    vim.notify("Done: " .. table.concat(self.cmd, " "))
    return
  end

  self:ensure_layout()

  local data = {
    lines = stdout,
    extmarks = {},
    keymaps = {},
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
  vim.bo[self.bufnr].syntax = "off"
  vim.b[self.bufnr].lsp = self.lsp
  vim.b[self.bufnr].fargs = self.fargs

  pcall(vim.treesitter.start, self.bufnr, self.cmd[1])

  local function cancel()
    vim.cmd.stopinsert()
    vim.api.nvim_buf_delete(self.bufnr, { force = true })
  end

  local function set(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = self.bufnr })
  end

  for _, keymap in ipairs(data.keymaps) do
    set("n", keymap.lhs, keymap.rhs)
  end

  set("n", "q", cancel)
  set("n", "<Esc>", cancel)
  set({ "i", "n" }, "<C-c>", cancel)

  vim.b[self.bufnr].refresh = function(nested)
    if self.can_refresh then
      self:run(self.fargs, nested)
    end
  end

  vim.keymap.set("n", "<C-r>", function()
    vim.b[self.bufnr].refresh(false)
  end, { buffer = self.bufnr })

  require("me.git.lsp").attach()
end

function M.new(opts)
  return setmetatable(opts, M)
end

return M

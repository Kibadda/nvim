--- @class me.ai.terminal
--- @field id string
--- @field tool me.ai.tool
--- @field group integer
--- @field queue string[]
--- @field job integer
--- @field buf integer
--- @field win integer
--- @field cwd string
local M = {}
M.__index = M

--- @type table<string, me.ai.terminal>
M.terminals = {}

--- @param tool me.ai.tool
function M.get(tool)
  if not M.terminals[tool.cmd[1]] then
    M.terminals[tool.cmd[1]] = M.new(tool)
  end

  return M.terminals[tool.cmd[1]]
end

---@param tool me.ai.tool
function M.new(tool)
  local self = setmetatable({}, M)
  self.id = tool.cmd[1]
  self.tool = tool
  self.queue = {}
  self.cwd = vim.fn.getcwd()
  self.group = vim.api.nvim_create_augroup("ai-terminal-" .. self.id)

  return self
end

function M:is_running()
  return self.job and vim.fn.jobwait({ self.job }, 0)[1] == -1
end

function M:buf_valid()
  return self.buf and vim.api.nvim_buf_is_valid(self.buf)
end

function M:win_valid()
  return self.win and vim.api.nvim_win_is_valid(self.win)
end

function M:bo()
  local bo = {
    filetype = "ai-term",
  }

  for k, v in pairs(bo) do
    vim.bo[self.buf][k] = v
  end
end

function M:wo()
  local wo = {}

  for k, v in pairs(wo) do
    vim.api.nvim_set_option_value(k, v, { win = self.win, scope = "local" })
  end
end

function M:start()
  if self:is_running() then
    return
  end

  self.buf = vim.api.nvim_create_buf(false, true)
  self:bo()

  self:keys()
  self:open_win()

  vim.api.nvim_create_autocmd("TermClose", {
    group = self.group,
    buffer = self.buf,
    callback = function()
      vim.schedule(function()
        self:close()
      end)
    end,
  })

  local ready = assert(vim.uv.new_timer())
  local ready_start = vim.uv.hrtime()
  local ready_init
  local ready_lines = 0

  local function close()
    if not ready:is_closing() then
      ready:stop()
      ready:close()
    end
  end

  local function on_ready()
    close()
    vim.schedule(function()
      self:on_ready()
    end)
  end

  ready:start(
    100,
    100,
    vim.schedule_wrap(function()
      local elapsed = (vim.uv.hrtime() - ready_start) / 1e6

      if not self:buf_valid() then
        return close()
      end

      if elapsed > 5000 then
        return on_ready()
      end

      if not self:win_valid() then
        return
      end

      local lines = vim.api.nvim_buf_get_lines(self.buf, 0, -1, false)

      while #lines > 0 and vim.trim(lines[#lines]) == "" do
        table.remove(lines)
      end

      local cursor = vim.api.nvim_win_get_cursor(self.win)

      if #lines > 5 and cursor[1] > 3 then
        ready_init = ready_init or vim.uv.hrtime()

        if #lines ~= ready_lines then
          ready_lines = #lines
          ready_init = vim.uv.hrtime()
        end

        local init_elapsed = (vim.uv.hrtime() - ready_init) / 1e6

        if init_elapsed > 100 then
          return on_ready()
        end
      end
    end)
  )

  vim.api.nvim_win_call(self.win, function()
    self.job = vim.fn.jobstart(self.tool.cmd, {
      cwd = self.cwd,
      term = true,
    })
  end)

  if self.job <= 0 then
    self:close()
  end
end

function M:on_ready()
  self.timer = assert(vim.uv.new_timer())

  self.timer:start(0, 100, function()
    local next = table.remove(self.queue, 1)

    if next then
      next = next:gsub("\r\n", "\n")
      vim.schedule(function()
        if self:is_running() then
          vim.api.nvim_buf_call(self.buf, function()
            vim.api.nvim_put(vim.split(next, "\n", { plain = true }), "c", false, true)
          end)
          if self:is_focused() then
            vim.cmd.startinsert()
          end
        end
      end)
    end
  end)
end

function M:open_win()
  if self:win_valid() or not self.buf then
    return
  end

  self.win = vim.api.nvim_open_win(self.buf, true, {
    split = "right",
    win = -1,
    style = "minimal",
    width = math.min(math.floor(vim.o.columns * 0.4 + 0.5), 120),
  })

  vim.wo[self.win].winfixwidth = true
  self:wo()
end

function M:focus()
  self:show()

  if not self:is_running() then
    return
  end

  vim.api.nvim_set_current_win(self.win)
  vim.cmd.startinsert()
end

function M:blur()
  if not self:is_focused() then
    return
  end

  vim.cmd.wincmd "p"
  vim.cmd.stopinsert()
end

function M:is_focused()
  return vim.api.nvim_get_current_win() == self.win
end

function M:show()
  self:start()

  if not self:is_running() then
    return
  end

  self:open_win()
end

function M:hide()
  if self:win_valid() then
    self:blur()
    vim.api.nvim_win_close(self.win, true)
    self.win = nil
  end
end

function M:close()
  if self.closed then
    return self
  end

  self.closed = true

  M.terminals[self.id] = nil

  if self.timer and not self.timer:is_closing() then
    self.timer:close()
    self.timer = nil
  end

  self:hide()

  if self:is_running() then
    vim.fn.jobstop(self.job)
    self.job = nil
  end

  if self.buf and vim.api.nvim_buf_is_valid(self.buf) then
    vim.api.nvim_buf_delete(self.buf, { force = true })
    self.buf = nil
  end

  vim.api.nvim_clear_autocmds { group = self.group }
  vim.api.nvim_del_augroup_by_id(self.group)
end

function M:toggle()
  if self:win_valid() then
    self:hide()
  else
    self:show()
    self:focus()
  end
end

function M:send(input)
  self:show()

  if not self:is_running() then
    return
  end

  table.insert(self.queue, input)

  self:focus()
end

function M:submit()
  if not self:is_running() then
    return
  end

  self:send "\r"
end

function M:keys()
  vim.keymap.set({ "n", "t" }, "<C-.>", function()
    self:hide()
  end, { buf = self.buf })
end

return M

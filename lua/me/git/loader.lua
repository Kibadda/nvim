local M = {}

local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local running = {}
local timer

local function redraw()
  vim.cmd.redrawstatus()
end

function M.start(cmd)
  table.insert(running, cmd)

  if not timer then
    timer = assert(vim.uv.new_timer())
    timer:start(80, 80, vim.schedule_wrap(redraw))
  end
end

function M.stop(cmd)
  for i, c in ipairs(running) do
    if c == cmd then
      table.remove(running, i)
      break
    end
  end

  if #running == 0 and timer then
    timer:stop()
    timer:close()
    timer = nil
    redraw()
  end
end

function M.text()
  if #running == 0 then
    return ""
  end

  local names = {}
  for _, cmd in ipairs(running) do
    table.insert(names, cmd[1])
  end

  return table.concat(names, ", ") .. " " .. spinner[(math.floor(vim.uv.hrtime() / 8e7) % #spinner) + 1]
end

return M

local M = {}

---@param timeout number
---@param callback function
---@return uv_timer_t?
function M.timeout(timeout, callback)
  local timer = vim.loop.new_timer()
  if timer then
    timer:start(timeout, 0, function()
      M.clear(timer)
      callback()
    end)
  end
  return timer
end

---@param interval number
---@param callback function
---@return uv_timer_t?
function M.interval(interval, callback)
  local timer = vim.loop.new_timer()
  if timer then
    timer:start(interval, interval, function()
      callback()
    end)
  end
  return timer
end

---@param timer? uv_timer_t
function M.clear(timer)
  if timer then
    timer:stop()
    if not timer:is_closing() then
      timer:close()
    end
  end
end

return M

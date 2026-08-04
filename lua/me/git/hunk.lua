local M = {
  types = {
    add = "Added",
    change = "Changed",
    delete = "Removed",
  }
}

local ns = vim.api.nvim_create_namespace "me.git.diff"

function M.set_diff_extmarks(bufnr, marks)
  if vim.bo[bufnr].buftype ~= "" then
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local nlines = vim.api.nvim_buf_line_count(bufnr)
  local opts = { number_hl_group = "", priority = 100 }

  for lnum, hl in pairs(marks) do
    if lnum <= nlines then
      opts.number_hl_group = hl
      vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, 0, opts)
    end
  end
end

local function get_ranges()
  local bufnr = vim.api.nvim_get_current_buf()
  local hunks = require("me.git.status").cache[bufnr].hunks or {}

  local sorted = vim.deepcopy(hunks)
  table.sort(sorted, function(a, b)
    return a.buf_start < b.buf_start
  end)

  local ranges = {}
  for _, hunk in ipairs(sorted) do
    local from = hunk.buf_count > 0 and hunk.buf_start or math.max(hunk.buf_start, 1)
    local to = hunk.buf_count > 0 and hunk.buf_start + hunk.buf_count - 1 or from
    local cur = ranges[#ranges]
    if cur and from <= cur.to + 1 then
      cur.to = math.max(cur.to, to)
    else
      table.insert(ranges, { from = from, to = to })
    end
  end

  return ranges
end

function M.textobject()
  local ranges = get_ranges()

  if #ranges == 0 then
    vim.notify "No diff hunks"
    return
  end

  local cur_line = vim.fn.line "."
  local region
  for _, r in ipairs(ranges) do
    if r.from <= cur_line and cur_line <= r.to then
      region = r
      break
    end
  end

  if not region then
    vim.notify "No hunk under cursor"
    return
  end

  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    vim.cmd "normal! \27"
  end

  vim.cmd(string.format("normal! %dGV%dG", region.from, region.to))
end

function M.goto(direction)
  local ranges = get_ranges()
  local n = #ranges

  if n == 0 then
    vim.notify "No diff hunks"
    return
  end

  local cur_line = vim.fn.line "."
  local count = vim.v.count1

  local init
  if direction == "next" then
    init = 0
    for i = n, 1, -1 do
      if ranges[i].from <= cur_line then
        init = i
        break
      end
    end
    init = init + count
  else
    init = n + 1
    for i = 1, n do
      if cur_line <= ranges[i].to then
        init = i
        break
      end
    end
    init = init - count
  end

  local res = (init - 1) % n + 1

  vim.cmd "normal! m'"
  local line = ranges[res].from
  local _, col = vim.fn.getline(line):find "^%s*"
  vim.api.nvim_win_set_cursor(0, { line, col })
  vim.cmd "normal! zv"
end

return M

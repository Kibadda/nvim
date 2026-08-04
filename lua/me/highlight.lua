local M = {}

local ns = vim.api.nvim_create_namespace "me.highlight"

local keywords = {
  TODO = "DiagnosticInfo",
  CRTX = "DiagnosticWarn",
  FIX = "DiagnosticError",
}

local function walk(node, bufnr, comments)
  if node:type() == "comment" then
    table.insert(comments, node)
  end
  for child in node:iter_children() do
    walk(child, bufnr, comments)
  end
end

local function highlight(bufnr)
  vim.schedule(function()
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

    local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
    if not ok or not parser then
      return
    end

    local trees = parser:parse()
    local tree = type(trees) == "table" and trees[1] or trees

    if not tree then
      return
    end

    local root = tree:root()
    if not root then
      return
    end

    local comments = {}
    walk(root, bufnr, comments)

    for _, node in ipairs(comments) do
      local sr, sc = node:range()
      local text = vim.treesitter.get_node_text(node, bufnr)
      if text then
        local row, col = sr, sc
        for line in vim.gsplit(text, "\n", { plain = true }) do
          for keyword, hl in pairs(keywords) do
            local from = 1
            while true do
              local s, e = line:find("%f[%w]" .. keyword .. "%f[%W]", from)
              if not s then
                break
              end
              vim.hl.range(bufnr, ns, hl, { row, col + s - 1 }, { row, col + e }, { priority = 150 })
              from = e + 1
            end
          end
          row = row + 1
          col = 0
        end
      end
    end
  end)
end

--- @type uv.uv_timer_t[]
local timers = {}

function M.cmd(bufnr, debounce)
  if debounce then
    if timers[bufnr] then
      timers[bufnr]:close()
    end

    timers[bufnr] = assert(vim.uv.new_timer())
    timers[bufnr]:start(150, 0, function()
      highlight(bufnr)
    end)
  else
    highlight(bufnr)
  end
end

function M.clear(bufnr)
  if timers[bufnr] and not timers[bufnr]:is_closing() then
    timers[bufnr]:close()
  end

  timers[bufnr] = nil
end

return M

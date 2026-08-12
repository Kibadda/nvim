local M = {}

--- @alias me.formatter.tool { cmd: string[], filetypes: string[] }

--- @type me.formatter.tool[]
M.tools = {
  {
    cmd = {
      "stylua",
      "--search-parent-directories",
      "--respect-ignores",
      "--stdin-filepath",
      "$FILE",
      "-",
    },
    filetypes = { "lua" },
  },
}

--- @param tool me.formatter.tool
function M.format(tool)
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)

  local cmd = {}
  for _, arg in ipairs(tool.cmd) do
    table.insert(cmd, arg == "$FILE" and name or arg)
  end

  local result = vim
    .system(cmd, {
      stdin = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n"),
    })
    :wait()

  if result.code ~= 0 then
    vim.notify("[" .. tool.cmd[1] .. "]\n" .. (result.stderr or ""), vim.log.levels.WARN)
    return
  end

  local lines = vim.split(result.stdout, "\n", { plain = true })
  if lines[#lines] == "" then
    lines[#lines] = nil
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

return M

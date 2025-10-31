local M = {}

local dir = vim.fn.stdpath "data" .. "/session"

local function save(session)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  vim.cmd.mksession {
    args = { session },
    bang = true,
  }
end

function M.new()
  local session

  vim.ui.input({ prompt = "Session name: " }, function(input)
    session = input
  end)

  if not session or session == "" then
    return
  end

  if vim.fn.filereadable(dir .. "/" .. session) == 1 then
    return
  end

  save(dir .. "/" .. session)
end

function M.update()
  if not vim.v.this_session or vim.v.this_session == "" or vim.fn.filereadable(vim.v.this_session) == 0 then
    return
  end

  save(vim.v.this_session)
end

function M.list()
  local sessions = {}

  for name, type in vim.fs.dir(dir) do
    if type == "file" then
      table.insert(sessions, name)
    end
  end

  table.sort(sessions)

  return sessions
end

function M.load(session)
  if not session then
    vim.ui.select(M.lis(), { prompt = "Session" }, function(choice)
      session = choice
    end)
  end

  if not session or session == "" or vim.fn.filereadable(dir .. "/" .. session) == 0 then
    return
  end

  if vim.v.this_session and vim.v.this_session ~= "" then
    M.update()
  end

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.fn.buflisted(bufnr) == 1 then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end

  vim.cmd.source(dir .. "/" .. session)
end

function M.delete()
  if not vim.v.this_session or vim.v.this_session == "" or vim.fn.filereadable(vim.v.this_session) == 0 then
    return
  end

  if vim.fn.confirm("Delete session " .. vim.v.this_session .. "?", "&Yes\n&No", 2) == 1 then
    os.remove(vim.v.this_session)
  end
end

return M

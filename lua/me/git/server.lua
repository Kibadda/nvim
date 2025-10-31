local M = {}

local function readlines(file)
  local handle = assert(io.open(file))

  local lines = vim.split(handle:read "a", "\n")
  lines[#lines] = nil

  return lines
end

function M.start(file, client)
  local socket = vim.fn.sockconnect("pipe", client, { rpc = true })

  local filetype, spell, startinsert
  if file:find "COMMIT_EDITMSG" or file:find "MERGE_MSG" then
    filetype = "gitcommit"
    startinsert = true
    spell = true
  elseif file:find "git%-rebase%-todo" then
    filetype = "git_rebase"
  elseif file:find "ADD_EDIT.patch" then
    filetype = "diff"
  end

  local cancel = false

  local _, bufnr = require("me.git.utils").open_buffer {
    name = file,
    lines = readlines(file),
    options = {
      filetype = filetype,
      bufhidden = "wipe",
      spell = spell,
    },
    treesitter = true,
  }

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd.w { bang = true }
    if startinsert then
      vim.cmd.startinsert()
    end
  end)

  vim.api.nvim_buf_attach(bufnr, false, {
    on_detach = function()
      vim.treesitter.stop(bufnr)
      vim.rpcnotify(socket, "nvim_command", cancel and "cq" or "qall")
      vim.fn.chanclose(socket)
    end,
  })
end

return M

local M = {}

local function readlines(file)
  local handle = assert(io.open(file))

  local lines = vim.split(handle:read "a", "\n")
  lines[#lines] = nil

  return lines
end

function M.start(file, client)
  local socket = vim.fn.sockconnect("pipe", client, { rpc = true })

  local filetype, spell, lsp
  if file:find "COMMIT_EDITMSG" or file:find "MERGE_MSG" then
    filetype = "gitcommit"
    spell = true
    lsp = require("me.git.commands.commit").lsp
  elseif file:find "git%-rebase%-todo" then
    filetype = "git_rebase"
  elseif file:find "ADD_EDIT.patch" then
    filetype = "diff"
  end

  local bufnr = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_buf_set_name(bufnr, file)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, readlines(file))

  local win = vim.api.nvim_open_win(bufnr, true, {
    split = "below",
    win = 0,
    height = 20,
  })

  vim.bo[bufnr].filetype = filetype
  vim.bo[bufnr].bufhidden = "wipe"
  vim.wo[win].spell = spell
  vim.b[bufnr].lsp = lsp

  pcall(vim.treesitter.start, bufnr, filetype)

  local cancelled = false

  local function cancel()
    cancelled = true
    vim.cmd.stopinsert()
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end

  vim.keymap.set("n", "q", cancel, { buffer = bufnr })
  vim.keymap.set({ "i", "n" }, "<C-c>", cancel, { buffer = bufnr })

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd.w { bang = true }
    if vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] == "" then
      vim.cmd.startinsert()
    end
  end)

  vim.api.nvim_buf_attach(bufnr, false, {
    on_detach = function()
      pcall(vim.treesitter.stop, bufnr)
      vim.rpcnotify(socket, "nvim_command", cancelled and "qall!" or "qall")
      vim.fn.chanclose(socket)
    end,
  })

  require("me.git.lsp").attach()
end

return M

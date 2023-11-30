if vim.g.loaded_autocmds then
  return
end

vim.g.loaded_autocmds = 1

local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("BasicAutocmds", { clear = true })

autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("BufReadPost", {
  group = group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("VimResized", {
  group = group,
  callback = function()
    vim.cmd.wincmd "="
  end,
})

autocmd("BufEnter", {
  group = group,
  callback = function(args)
    vim.opt_local.formatoptions:remove "t"
    vim.opt_local.formatoptions:remove "o"
    vim.opt_local.formatoptions:append "n"

    if vim.bo[args.buf].buftype == "nofile" then
      vim.opt_local.statuscolumn = nil
    end
  end,
})

autocmd("FileType", {
  group = group,
  pattern = {
    "help",
    "man",
    "qf",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

autocmd({ "SessionLoadPost", "VimLeave", "FocusGained" }, {
  group = group,
  callback = function()
    if vim.g.started_as_db_client then
      return
    end
    local name
    if vim.v.exiting ~= vim.NIL then
      name = ""
    else
      name = "nvim " .. table.remove(vim.split(vim.v.this_session, "/"))
    end
    vim.system { "kitty", "@", "--to", vim.env.KITTY_LISTEN_ON, "set-tab-title", name }
  end,
})

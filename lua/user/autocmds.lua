local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

autocmd("TextYankPost", {
  group = augroup "HighlightYank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank {
      higroup = "Search",
      timeout = 200,
    }
  end,
})

autocmd("BufWritePre", {
  group = augroup "AutoCreateDir",
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

autocmd("BufEnter", {
  group = augroup "PluginFileKeymap",
  pattern = "*/lua/user/plugins/{*.lua,*/init.lua}",
  callback = function(args)
    require("user.utils.register").keymaps {
      [{ mode = "n", buffer = args.buf }] = {
        g = {
          P = { require("user.utils.plugin").open, "Open Plugin" },
        },
      },
    }
  end,
})

autocmd("BufReadPost", {
  group = augroup "GotoLastPlace",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("VimResized", {
  group = augroup "EqualizeSplitsOnResize",
  callback = function()
    vim.cmd.wincmd "="
  end,
})

autocmd("FileType", {
  group = augroup "UseSpellInGitCommits",
  pattern = { "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank {
      higroup = "Search",
      timeout = 200,
    }
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("SourcePluginFile", { clear = true }),
  pattern = "plugins.lua",
  callback = function()
    vim.cmd.source "<afile>"
  end,
})

vim.api.nvim_create_autocmd("TermClose", {
  group = vim.api.nvim_create_augroup("CloseBufferAfterTermClose", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "TelescopePrompt" then
      vim.cmd.bd { bang = true }
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("EnterInsertInTerm", { clear = true }),
  pattern = "term://*",
  callback = function()
    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("TermFileType", { clear = true }),
  pattern = "*",
  callback = function()
    require("user.utils.options").set {
      filetype = "term",
    }
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("AutoCreateDir", { clear = true }),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("RemoveWinbarOnFileBufType", { clear = true }),
  pattern = "HeirlineInitWinbar",
  callback = function(args)
    if
      vim.tbl_contains({ "prompt", "nofile", "help", "quickfix", "startify" }, vim.bo[args.buf].buftype)
      or vim.tbl_contains({ "gitcommit", "fugitive", "startify" }, vim.bo[args.buf].filetype)
    then
      vim.opt_local.winbar = nil
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("PluginFileKeymap", { clear = true }),
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

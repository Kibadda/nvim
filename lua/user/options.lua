local o = vim.opt
o.completeopt = "menuone,noselect,preview"
o.pumblend = 0
o.wildmode = "longest:full,full"
o.relativenumber = true
o.number = true
o.ignorecase = true
o.smartcase = true
o.splitright = true
o.splitbelow = true
o.updatetime = 250
o.scrolloff = 8
o.sidescrolloff = 8
o.cursorline = true
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true
o.breakindent = true
o.showbreak = "|-> "
o.linebreak = true
o.foldenable = false
o.clipboard = "unnamed,unnamedplus"
o.swapfile = false
o.undofile = true
o.shada = "!,'1000,<50,s10,h"
o.mouse = "nv"
o.diffopt = "internal,filler,closeoff,hiddenoff,algorithm:minimal"
o.laststatus = 3
o.signcolumn = "no"
o.showtabline = 2
o.timeoutlen = 100
o.termguicolors = true
o.textwidth = 120
o.fileformats = "unix"
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal,globals"
o.showmode = false
o.shortmess = "filmnxtToOWAIcCFS"
o.smoothscroll = true

-- vim.on_key(function(char)
--   if vim.fn.mode() == "n" then
--     vim.opt.hlsearch = vim.tbl_contains({ "n", "N", "*", "#", "?", "/", "z" }, vim.fn.keytrans(char))
--   end
-- end, vim.api.nvim_create_namespace "auto_hlsearch")

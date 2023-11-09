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
o.clipboard = "unnamed,unnamedplus"
o.swapfile = false
o.undofile = true
o.shada = "!,'1000,<50,s10,h"
o.mouse = "nv"
o.diffopt = "internal,filler,closeoff,hiddenoff,algorithm:minimal,linematch:50"
o.laststatus = 3
o.signcolumn = "no"
o.showtabline = 2
o.timeoutlen = 100
o.termguicolors = true
o.textwidth = 120
-- o.fileformats = "unix"
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal,globals"
o.showmode = false
o.shortmess = "filmnxtToOWAIcCFS"
o.smoothscroll = true
o.autowrite = true
o.confirm = true
o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep"
o.list = true
o.shiftround = true
o.winbar = "%{%v:lua.require'user.winbar'()%}"
o.foldenable = false
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = "v:lua.vim.treesitter.foldtext()"

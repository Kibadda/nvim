for k, v in pairs {
  completeopt = "menuone,noselect,preview",
  pumblend = 0,
  wildmode = "longest:full,full",
  relativenumber = true,
  number = true,
  ignorecase = true,
  smartcase = true,
  splitright = true,
  splitbelow = true,
  updatetime = 250,
  scrolloff = 8,
  sidescrolloff = 8,
  cursorline = true,
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 2,
  expandtab = true,
  breakindent = true,
  showbreak = "|-> ",
  linebreak = true,
  foldenable = false,
  clipboard = "unnamed,unnamedplus",
  swapfile = false,
  undofile = true,
  shada = "!,'1000,<50,s10,h",
  mouse = "nv",
  diffopt = "internal,filler,closeoff,hiddenoff,algorithm:minimal",
  laststatus = 3,
  signcolumn = "no",
  showtabline = 2,
  timeoutlen = 100,
  termguicolors = true,
  textwidth = 120,
  fileformats = "unix",
  sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal,globals",
  showmode = false,
  shortmess = "filmnxtToOWAIcCFS",
} do
  vim.opt[k] = v
end

vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    vim.opt.hlsearch = vim.tbl_contains({ "n", "N", "*", "#", "?", "/", "z" }, vim.fn.keytrans(char))
  end
end, vim.api.nvim_create_namespace "auto_hlsearch")

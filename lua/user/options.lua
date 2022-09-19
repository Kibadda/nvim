SetOptions {
  pumblend = 17,
  wildmode = "longest:full,full",
  wildoptions = "pum",
  cmdheight = 2,
  relativenumber = true,
  number = true,
  ignorecase = true,
  smartcase = true,
  splitright = true,
  splitbelow = true,
  updatetime = 1000,
  scrolloff = 8,
  sidescrolloff = 8,
  cursorline = true,
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 2,
  expandtab = true,
  breakindent = true,
  showbreak = "+++ ",
  linebreak = true,
  foldenable = false,
  modelines = 1,
  clipboard = "unnamedplus",
  inccommand = "split",
  swapfile = false,
  undofile = true,
  shada = { "!", "'1000", "<50", "s10", "h" },
  mouse = "nv",
  diffopt = { "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal" },
  laststatus = 3,
  signcolumn = "yes:2",
  timeoutlen = 100,
  termguicolors = true,
  winbar = "%=%m %f:%L ",
  formatoptions = GetFormatOptions(vim.opt),
  textwidth = 120,
}

SetGlobal("cursorhold", {
  updatetime = 250,
})

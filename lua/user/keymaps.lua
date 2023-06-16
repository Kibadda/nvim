local utils = require "user.utils"

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

local function nmap(lhs, rhs, desc)
  map("n", lhs, rhs, desc)
end
local function xmap(lhs, rhs, desc)
  map("x", lhs, rhs, desc)
end
local function imap(lhs, rhs, desc)
  map("i", lhs, rhs, desc)
end

map({ "n", "x" }, "j", utils.jump_direction "j", "Down")
map({ "n", "x" }, "k", utils.jump_direction "k", "Up")

nmap("<Leader>L", "<Cmd>Lazy<CR>", "Lazy")
nmap("<Leader>P", "<Cmd>PluginList<CR>", "Show Plugin List")
nmap("<Leader>S", "<Cmd>ScratchList<CR>", "Show Scratch List")
nmap("gB", function()
  vim.system { "xdg-open", vim.fn.expand "<cWORD>" }
end, "Open URL")
nmap("gH", "<Cmd>OpenGitInBrowser<CR>", "Open Current Git")
nmap("yA", "<Cmd>%y+<CR>", "Yank File Content")
nmap("<C-S-j>", "<Cmd>m .+1<CR>==", "Move Line Down")
nmap("<C-S-k>", "<Cmd>m .-2<CR>==", "Move Line Up")
nmap("U", "<C-r>", "Redo")
nmap("n", "nzz")
nmap("N", "Nzz")
nmap("*", "*zz")
nmap("#", "#zz")

xmap("y", "myy`y")
xmap("Y", "myY`y")
xmap("<", "<gv")
xmap(">", ">gv")
xmap("<C-S-j>", ":m '>+1<CR>gv=gv", "Move Lines Down")
xmap("<C-S-k>", ":m '<-2<CR>gv=gv", "Move Lines Up")

imap("<S-CR>", "<C-o>o", "New Line Top")
imap("<C-CR>", "<C-o>O", "New Line Bottom")
imap("<C-BS>", "<C-w>")
imap(",", ",<C-g>u")
imap(";", ";<C-g>u")
imap(".", ".<C-g>u")

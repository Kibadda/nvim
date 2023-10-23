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
map({ "i", "n" }, "<Esc>", "<Cmd>nohlsearch<CR><Esc>")

vim.keymap.set({ "x", "n", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set({ "x", "n", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

nmap("<Leader>L", "<Cmd>Lazy<CR>", "Lazy")
nmap("<Leader>sp", "<Cmd>PluginList<CR>", "Plugin")
nmap("<Leader>ss", "<Cmd>ScratchList<CR>", "Scratch")
nmap("<Leader>sT", function()
  require("user.themes").select()
end, "Theme")
nmap("gB", function()
  vim.ui.open(vim.fn.expand "<cWORD>")
end, "Open URL")
nmap("gH", "<Cmd>OpenGitInBrowser<CR>", "Open Current Git")
nmap("yA", "<Cmd>%y+<CR>", "Yank File Content")
nmap("<C-S-j>", "<Cmd>m .+1<CR>==", "Move Line Down")
nmap("<C-S-k>", "<Cmd>m .-2<CR>==", "Move Line Up")
nmap("U", "<C-r>", "Redo")
-- nmap("n", "nzz")
-- nmap("N", "Nzz")
-- nmap("*", "*zz")
-- nmap("#", "#zz")

xmap("y", "myy`y")
xmap("Y", "myY`y")
xmap("<", "<gv")
xmap(">", ">gv")
xmap("<C-S-j>", ":m '>+1<CR>gv=gv", "Move Lines Down")
xmap("<C-S-k>", ":m '<-2<CR>gv=gv", "Move Lines Up")
xmap("x", '"_d')

imap("<S-CR>", "<C-o>o", "New Line Top")
imap("<C-CR>", "<C-o>O", "New Line Bottom")
imap("<C-BS>", "<C-w>")
imap(",", ",<C-g>u")
imap(";", ";<C-g>u")
imap(".", ".<C-g>u")

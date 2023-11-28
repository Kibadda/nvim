if vim.g.loaded_keymaps then
  return
end

vim.g.loaded_keymaps = 1

local function jump_direction(direction)
  return function()
    local count = vim.v.count

    if count == 0 then
      vim.cmd.normal { ("g%s"):format(direction), bang = true }
      return
    end

    if count > 5 then
      vim.cmd.normal { "m'", bang = true }
    end

    vim.cmd.normal { ("%d%s"):format(count, direction), bang = true }
  end
end

local function map(mode, lhs, rhs, opts)
  if type(opts) == "string" then
    opts = { desc = opts }
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

map({ "n", "x" }, "j", jump_direction "j", "Down")
map({ "n", "x" }, "k", jump_direction "k", "Up")
map({ "i", "n" }, "<Esc>", "<Cmd>nohlsearch<CR><Esc>")

map({ "x", "n", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "x", "n", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

map("n", "gB", function()
  vim.ui.open(vim.fn.expand "<cWORD>" --[[@as string]])
end, "Open URL")
map("n", "gH", function()
  local result = vim.system({ "git", "remote" }, { cwd = vim.loop.cwd() }):wait()
  local remote = vim.trim(result.stdout)

  result = vim.system({ "git", "config", "--get", ("remote.%s.url"):format(remote) }, { cwd = vim.loop.cwd() }):wait()
  local url = vim.trim(result.stdout)
  if vim.startswith(url, "git") then
    url = url:gsub("%.git", ""):gsub(":", "/"):gsub("git@", "https://")
  end

  vim.ui.open(url)
end, "Open Current Git")

map("n", "yA", "<Cmd>%y+<CR>", "Yank File Content")
map("n", "<C-S-j>", "<Cmd>m .+1<CR>==", "Move Line Down")
map("n", "<C-S-k>", "<Cmd>m .-2<CR>==", "Move Line Up")
map("n", "U", "<C-r>", "Redo")

map("x", "y", "myy`y")
map("x", "Y", "myY`y")
map("x", "<", "<gv")
map("x", ">", ">gv")
map("x", "<C-S-j>", ":m '>+1<CR>gv=gv", "Move Lines Down")
map("x", "<C-S-k>", ":m '<-2<CR>gv=gv", "Move Lines Up")
map("x", "x", '"_d')
map("x", "gB", function()
  local spos = vim.fn.getpos "v"
  local epos = vim.fn.getpos "."
  if spos and epos then
    local text = vim.api.nvim_buf_get_text(0, spos[2] - 1, spos[3] - 1, epos[2] - 1, epos[3], {})
    if #text > 0 then
      vim.ui.open(table.concat(text))
    end
  end
end)

map("i", "<S-CR>", "<C-o>o", "New Line Top")
map("i", "<C-CR>", "<C-o>O", "New Line Bottom")
map("i", "<C-BS>", "<C-w>")
map("i", ",", ",<C-g>u")
map("i", ";", ";<C-g>u")
map("i", ".", ".<C-g>u")

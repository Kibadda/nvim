if vim.g.loaded_plugin_macro then
  return
end

vim.g.loaded_plugin_macro = 1

local function normal(cmd)
  vim.cmd.normal { cmd, bang = true }
end

local function setMacro(recording)
  vim.fn.setreg("a", recording, "c")
end

local function getMacro()
  return vim.api.nvim_replace_termcodes(vim.fn.keytrans(vim.fn.getreg "a"), true, true, true)
end

local previous
vim.keymap.set("n", "q", function()
  if vim.fn.reg_recording() == "" then
    normal "qa"
  else
    previous = getMacro()
    normal "q"
    setMacro(getMacro():sub(1, -2))

    if getMacro() == "" then
      setMacro(previous)
    end
  end
end)

vim.keymap.set("n", "Q", function()
  normal(vim.v.count1 .. "@a")
end)

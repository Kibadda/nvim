if not CheckPlugin "neoscroll" then
  return
end

require("neoscroll").setup {
  mappings = {
    "<C-u>",
    "<C-d>",
    "zt",
    "zz",
    "zb",
  },
  pre_hook = function()
    vim.wo.cursorline = false
  end,
  post_hook = function()
    vim.wo.cursorline = true
  end,
}

RegisterKeymaps("n", "", {
  ["<C-u>"] = { "Scroll cursor up" },
  ["<C-d>"] = { "Scroll cursor down" },
})

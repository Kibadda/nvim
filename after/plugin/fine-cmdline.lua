if not pcall(require, "fine-cmdline") then
  return
end

require("fine-cmdline").setup {
  cmdline = {
    prompt = " ",
  },
}

RegisterKeymaps("n", "", {
  ["<CR>"] = { "<Cmd>FineCmdline<CR>", "Cmd Line" },
})

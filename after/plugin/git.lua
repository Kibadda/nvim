if not pcall(require, "gitsigns") then
  return
end

require("gitsigns").setup {}

RegisterKeymaps("n", "<Leader>", {
  g = {
    name = "Git",
    d = { "<Cmd>Gitsigns diffthis<CR>", "Diff" },
    j = { "<Cmd>Gitsigns next_hunk<CR>", "Next Hunk" },
    k = { "<Cmd>Gitsigns prev_hunk<CR>", "Prev Hunk" },
    l = { "<Cmd>Gitsigns blame_line<CR>", "Blame Line" },
    s = { "<Cmd>Telescope git_status<CR>", "Status" },
    g = { "<Cmd>OpenTerminal lazygit<CR>", "Lazygit" },
    b = { "<Cmd>Telescope git_branches<CR>", "Checkout Branches" },
    c = { "<Cmd>Telescope git_commits<CR>", "Checkout Commit" },
    C = { "<Cmd>Telescope git_bcommits<CR>", "Checkout Commit (current file)" },
  },
})

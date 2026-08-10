vim.bo.bufhidden = "delete"

vim.keymap.set("n", "q", "<Cmd>bdelete<CR>", { buf = 0 })

local utils = require "user.utils"

utils.keymaps {
  n = {
    ["<Leader>"] = {
      L = { "<Cmd>Lazy<CR>", "Lazy" },
      Q = { utils.detach_from_tmux, "Detach" },
      P = { require("user.utils.plugin").list, "New Plugin File" },
      n = { utils.new_scratch, "New Scratch" },
      K = { utils.load_extra_keymaps, "Load .nvim-keymaps.lua" },
      c = {
        function()
          local curbufnr = vim.api.nvim_get_current_buf()
          local buflist = vim.api.nvim_list_bufs()
          for _, bufnr in ipairs(buflist) do
            if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and vim.fn.getbufvar(bufnr, "bufpersist") ~= 1 then
              vim.cmd.bd(tostring(bufnr))
            end
          end
        end,
        "Close unused buffers",
      },
    },
    g = {
      B = { utils.open_url, "Open URL" },
      H = { utils.open_in_github, "Open current github" },
    },
    y = {
      A = { "<Cmd>%y+<CR>", "Yank file content" },
    },
    n = { "nzz", "next search" },
    N = { "Nzz", "next search" },
    ["#"] = { "#zz", "next search" },
    ["*"] = { "*zz", "next search" },
    ["<C-S-j>"] = { "<Cmd>m .+1<CR>==", "Move line down" },
    ["<C-S-k>"] = { "<Cmd>m .-2<CR>==", "Move line up" },
    j = { utils.jump_direction "j", "Down" },
    k = { utils.jump_direction "k", "Up" },
    U = { "<C-r>", "Redo" },
  },
  x = {
    y = { "myy`y", "yank" },
    Y = { "myY`y", "Yank" },
    ["<"] = { "<gv", "dedent" },
    [">"] = { ">gv", "indent" },
    ["<C-S-j>"] = { ":m '>+1<CR>gv=gv", "Move lines down" },
    ["<C-S-k>"] = { ":m '<-2<CR>gv=gv", "Move lines up" },
    j = { utils.jump_direction "j", "Down" },
    k = { utils.jump_direction "k", "Up" },
  },
  i = {
    -- this needs mapping in kitty.conf
    -- default behaviour <S-CR> == <C-CR> == <CR>
    -- explanation: https://www.reddit.com/r/neovim/comments/mbj8m5/how_to_setup_ctrlshiftkey_mappings_in_neovim_and/
    ["<S-CR>"] = { "<C-o>o", "New line on bottom" },
    ["<C-CR>"] = { "<C-o>O", "New line on top" },
    -- <C-h> == <C-BS>
    ["<C-h>"] = { "<C-w>", "Remove previous word" },
    [","] = { ",<C-g>u", "" },
    [";"] = { ";<C-g>u", "" },
    ["."] = { ".<C-g>u", "" },
  },
}

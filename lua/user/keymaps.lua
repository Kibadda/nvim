local utils = require "user.utils"

utils.keymaps {
  n = {
    ["<Leader>"] = {
      L = { "<Cmd>Lazy<CR>", "Lazy" },
      P = { "<Cmd>PluginList<CR>", "New Plugin File" },
      n = { "<Cmd>ScratchList<CR>", "New Scratch" },
      K = {
        function()
          local files = vim.fs.find(".nvim-keymaps.lua", {
            type = "file",
            path = vim.loop.cwd(),
          })

          if #files == 0 then
            return
          end

          vim.cmd.luafile(files[1])
        end,
        "Load .nvim-keymaps.lua",
      },
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
      B = {
        function()
          os.execute("xdg-open " .. vim.fn.expand "<cWORD>")
        end,
        "Open URL",
      },
      H = { "<Cmd>OpenGitInBrowser<CR>", "Open current github" },
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
    ["<S-CR>"] = { "<C-o>o", "New line on bottom" },
    ["<C-CR>"] = { "<C-o>O", "New line on top" },
    ["<C-BS>"] = { "<C-w>", "Remove previous word" },
    [","] = { ",<C-g>u", "" },
    [";"] = { ";<C-g>u", "" },
    ["."] = { ".<C-g>u", "" },
  },
}

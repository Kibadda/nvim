return {
  "echasnovski/mini.extra",
  dependencies = {
    "echasnovski/mini.pick",
  },
  keys = {
    { "<Leader>e", "<Cmd>Pick explorer<CR>", desc = "Explorer" },
    { "<Leader>E", "<Cmd>Pick explorer cwd='%:p:h'<CR>", desc = "Explorer Current" },
  },
  init = function()
    local group = vim.api.nvim_create_augroup("OpenPickFindFilesIfDirectory", { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.cd(data.file)
          vim.cmd.argdelete "*"
          vim.cmd.bdelete()
          require "mini.extra"
          require("mini.pick").registry.explorer()
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      pattern = "*/",
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.bdelete()
          require "mini.extra"
          require("mini.pick").registry.explorer { cwd = vim.fn.fnamemodify(data.file, ":.") }
        end
      end,
    })
  end,
  opts = {},
  config = function(_, opts)
    require("mini.extra").setup(opts)

    MiniPick.registry.explorer = require "user.plugins.mini-extra.explorer"
  end,
}

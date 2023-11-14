return {
  "stevearc/conform.nvim",
  init = function()
    vim.api.nvim_create_autocmd("BufNew", {
      group = vim.api.nvim_create_augroup("ConformAugroup", { clear = true }),
      callback = function(args)
        local conform = require "conform"
        if #conform.list_formatters(args.buf) > 0 then
          vim.b[args.buf].formatter = conform.format
        end
      end,
    })
  end,
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
    },
    notify_on_error = false,
  },
}

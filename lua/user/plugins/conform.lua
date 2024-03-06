return {
  "stevearc/conform.nvim",
  init = function()
    vim.api.nvim_create_autocmd("BufEnter", {
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
      sh = { "beautysh" },
      zsh = { "beautysh" },
    },
    notify_on_error = false,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    require("conform").formatters.beautysh = {
      prepend_args = function(self, ctx)
        return { "--indent-size", vim.bo[ctx.buf].shiftwidth }
      end,
    }
  end,
}

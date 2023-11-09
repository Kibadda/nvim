return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = "Neogit",
  keys = {
    { "<Leader>G", "<Cmd>Neogit<CR>", desc = "Open Neogit" },
  },
  init = function()
    vim.cmd.cabbrev "G Neogit"

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("Neogit", { clear = true }),
      pattern = "NeogitCommitMessage",
      callback = function()
        vim.opt_local.spell = true
      end,
    })
  end,
  opts = {
    disable_hint = true,
    disable_insert_on_commit = "auto",
    console_timeout = 5000,
  },
}

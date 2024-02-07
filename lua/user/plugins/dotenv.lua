return {
  "tpope/vim-dotenv",
  lazy = false,
  config = function()
    local envfile = vim.fn.stdpath "config" .. "/.env"
    if vim.fn.filereadable(vim.fn.expand(envfile)) == 0 then
      return
    end

    vim.cmd.Dotenv(envfile)
  end,
}

return {
  "Kibadda/laravel-docs.nvim",
  dev = true,
  cmd = { "LaravelDocs", "LaravelDocsUpdate" },
  init = function()
    require("user.utils").keymaps {
      n = {
        ["<Leader>"] = {
          s = {
            l = { "<Cmd>LaravelDocs<CR>", "Laravel Docs" },
          },
        },
      },
    }
  end,
  config = true,
}

return {
  "Kibadda/laravel-docs.nvim",
  dev = true,
  cmd = { "LaravelDocs", "LaravelDocsUpdate" },
  keys = {
    { "<Leader>sl", "<Cmd>LaravelDocs<CR>", desc = "Laravel Docs" },
  },
  opts = true,
}

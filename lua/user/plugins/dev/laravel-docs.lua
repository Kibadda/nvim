local M = {
  "Kibadda/laravel-docs.nvim",
  dev = true,
  cmd = "LaravelDocs",
}

function M.config()
  require("telescope").load_extension "laravel-docs"
end

return M

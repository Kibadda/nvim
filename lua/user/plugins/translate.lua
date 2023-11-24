return {
  "uga-rosa/translate.nvim",
  dependencies = {
    "tpope/vim-dotenv",
  },
  cmd = "Translate",
  keys = {
    { "<Leader>te", ":Translate -output=replace en<CR>", desc = "English", mode = "x" },
    { "<Leader>td", ":Translate -output=replace de<CR>", desc = "German", mode = "x" },
  },
  opts = {
    default = {
      command = "deepl_free",
    },
  },
  config = function(_, opts)
    vim.g.deepl_api_auth_key = vim.env.DEEPL_API_AUTH_KEY
    require("translate").setup(opts)
  end,
}

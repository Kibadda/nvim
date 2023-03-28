return {
  "uga-rosa/translate.nvim",
  dependencies = {
    "tpope/vim-dotenv",
  },
  cmd = "Translate",
  opts = {
    default = {
      command = "deepl_free",
    },
  },
  init = function()
    require("user.utils").keymaps {
      x = {
        ["<Leader>"] = {
          t = {
            name = "Translate",
            e = { ":Translate -output=replace en<CR>", "To english" },
            d = { ":Translate -output=replace de<CR>", "To german" },
          },
        },
      },
    }
  end,
  config = function()
    require("user.utils").set_global_options {
      deepl_api_auth_key = vim.env.DEEPL_API_AUTH_KEY,
    }
  end,
}

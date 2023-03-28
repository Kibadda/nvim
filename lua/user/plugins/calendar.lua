return {
  "itchyny/calendar.vim",
  dependencies = {
    "tpope/vim-dotenv",
  },
  cmd = "Calendar",
  opts = {
    locale = "de",
    first_day = "monday",
    date_endian = "little",
    date_separator = ".",
    date_month_name = true,
    date_full_month_name = true,
    week_number = true,
    frame = "default",
    google_calendar = true,
    google_api_key = vim.env.CALENDAR_GOOGLE_API_KEY,
    google_client_id = vim.env.CALENDAR_GOOGLE_CLIENT_ID,
    google_client_secret = vim.env.CALENDAR_GOOGLE_CLIENT_SECRET,
  },
  init = function()
    require("user.utils").keymaps {
      n = {
        ["<Leader>"] = {
          C = { "<Cmd>Calendar<CR>", "Open calendar" },
        },
      },
    }
  end,
  config = function(_, opts)
    require("user.utils").set_global_options(opts, "calendar")
  end,
}

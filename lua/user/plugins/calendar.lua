return {
  "itchyny/calendar.vim",
  dependencies = {
    "tpope/vim-dotenv",
  },
  cmd = "Calendar",
  keys = {
    { "<Leader>C", "<Cmd>Calendar<CR>", desc = "Calendar" },
  },
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
  },
  config = function(_, opts)
    opts.google_api_key = vim.env.CALENDAR_GOOGLE_API_KEY
    opts.google_client_id = vim.env.CALENDAR_GOOGLE_CLIENT_ID
    opts.google_client_secret = vim.env.CALENDAR_GOOGLE_CLIENT_SECRET
    require("user.utils").set_global_options(opts, "calendar")
  end,
}

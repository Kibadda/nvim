return {
  "romainl/vim-qf",
  enabled = false,
  event = "VeryLazy",
  keys = {
    { "<C-q>", "<Plug>(qf_qf_toggle_stay)", desc = "Quickfix toggle" },
    { "<C-Up>", "<Plug>(qf_qf_previous)", desc = "Quickfix prev" },
    { "<C-Down>", "<Plug>(qf_qf_next)", desc = "Quickfix next" },
  },
}

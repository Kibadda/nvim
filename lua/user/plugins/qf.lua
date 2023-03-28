return {
  "romainl/vim-qf",
  event = "VeryLazy",
  init = function()
    require("user.utils").keymaps {
      n = {
        ["<C-q>"] = { "<Plug>(qf_qf_toggle_stay)", "QF: toggle" },
        ["<C-Up>"] = { "<Plug>(qf_qf_previous)", "QF: prev" },
        ["<C-Down>"] = { "<Plug>(qf_qf_next)", "QF: next" },
      },
    }
  end,
}

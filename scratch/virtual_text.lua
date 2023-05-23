local ns = vim.api.nvim_create_namespace "virtual_text_test"

local one = vim.api.nvim_buf_set_extmark(4, ns, 30, 45, {
  end_row = 30,
  hl_group = "TodoBgTODO",
  virt_text = { { "options:", "@keyword" }, { " ", "Normal" } },
  virt_text_pos = "inline",
})

local two = vim.api.nvim_buf_set_extmark(4, ns, 30, 51, {
  end_row = 30,
  hl_group = "TodoBgTODO",
  virt_text = { { "group:", "@keyword" }, { " ", "Normal" } },
  virt_text_pos = "inline",
})

vim.print(ns, one, two)

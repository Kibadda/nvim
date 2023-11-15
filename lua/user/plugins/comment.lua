return {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  opts = {
    opleader = {
      line = "gc",
      block = "gb",
    },
    mappings = {
      basic = true,
      extra = true,
    },
    toggler = {
      line = "gcc",
      block = "gbc",
    },
    ignore = "^$",
    pre_hook = function()
      if vim.bo.filetype == "smarty" then
        return "{*%s*}"
      end
    end,
  },
  config = function(_, opts)
    require("Comment").setup(opts)

    local comment_ft = require "Comment.ft"
    comment_ft.set("smarty", { "{*%s*}", "{*%s*}" })
  end,
}

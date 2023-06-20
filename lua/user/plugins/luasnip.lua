return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  config = function()
    require("luasnip").cleanup()

    require("luasnip.loaders.from_lua").load {
      paths = vim.fn.stdpath "config" .. "/snippets",
    }
  end,
  enabled = false,
}

vim.api.nvim_buf_create_user_command(0, "X", function()
  vim.cmd.write()
  vim.cmd.luafile "%"
end, {
  bang = false,
  nargs = 0,
  desc = "Save and source",
})

vim.lsp.start {
  name = "lua-language-server",
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", "stylua.toml", ".git" },
  before_init = function(params, config)
    require("neodev.lsp").before_init(params, config)
  end,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      format = {
        enable = false,
      },
      workspace = {
        checkThirdParty = false,
      },
      hint = {
        enable = true,
        arrayIndex = "Disable",
      },
      completion = {
        callSnippet = "Replace",
      },
    },
  },
}

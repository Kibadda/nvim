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
  settings = (function()
    local config = {
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

    require("neodev.lsp").on_new_config(config, "")

    return config.settings
  end)(),
  init_options = {},
}

if
  vim.api.nvim_buf_get_name(0):find(vim.fn.stdpath "config" --[[@as string]])
then
  require("user.config-lsp").start()
end

return {
  cmd = { "lua-language-server" },
  root_markers = { ".luarc.json", "stylua.toml", ".stylua.toml", "lua/" },
  filetypes = { "lua" },
  before_init = function(params, config)
    if not params.rootPath or type(params.rootPath) ~= "string" then
      return
    end

    local library = {}

    if vim.fn.stdpath "config" == params.rootPath then
      table.insert(library, vim.env.VIMRUNTIME .. "/lua")

      for _, plugin in ipairs(vim.pack.get()) do
        table.insert(library, plugin.path .. "/lua")
      end
    end

    if vim.fn.isdirectory(params.rootPath .. "/lua") == 1 then
      table.insert(library, params.rootPath .. "/lua")
    end

    --- @diagnostic disable-next-line:undefined-field
    config.settings.Lua.workspace.library = library
  end,
  settings = {
    Lua = {
      format = {
        enable = false,
      },
      workspace = {
        checkThirdParty = false,
      },
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
      },
      hint = {
        enable = true,
        arrayIndex = "Disable",
      },
      completion = {
        callSnippet = "Replace",
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

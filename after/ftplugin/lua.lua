vim.lsp.start {
  name = "lua-language-server",
  cmd = { "lua-language-server" },
  root_markers = { ".luarc.json", "stylua.toml", ".git" },
  before_init = function(params, config)
    if not params.rootPath then
      return
    end

    config.settings.Lua.workspace.library = config.settings.Lua.workspace.library or {}

    -- if inside neovim config
    ---@diagnostic disable-next-line:param-type-mismatch
    if params.rootPath:find(vim.fn.stdpath "config") then
      config.settings.Lua.runtime.version = "LuaJIT"

      -- add vimruntime
      table.insert(config.settings.Lua.workspace.library, vim.env.VIMRUNTIME .. "/lua")

      -- add lazy plugins
      for _, plugin in ipairs(require("lazy").plugins()) do
        ---@diagnostic disable-next-line:param-type-mismatch
        for _, p in ipairs(vim.fn.expand(plugin.dir .. "/lua", false, true)) do
          table.insert(config.settings.Lua.workspace.library, p)
        end
      end
    end

    -- if inside lua project
    if vim.fn.isdirectory(params.rootPath .. "/lua") == 1 then
      -- add current workspace
      table.insert(config.settings.Lua.workspace.library, params.rootPath .. "/lua")
    end
  end,
  settings = {
    Lua = {
      runtime = {
        pathStrict = true,
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

---@diagnostic disable-next-line:param-type-mismatch
if vim.api.nvim_buf_get_name(0):find(vim.fn.stdpath "config") then
  require("user.config-lsp").start()
end

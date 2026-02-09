--- @type vim.lsp.Config
return {
  cmd = { "copilot-language-server", "--stdio" },
  root_markers = { ".git" },
  init_options = {
    editorInfo = {
      name = "Neovim",
      version = tostring(vim.version()),
    },
    editorPluginInfo = {
      name = "Neovim",
      version = tostring(vim.version()),
    },
  },
  settings = {
    telemetry = {
      telemetryLevel = "all",
    },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "CopilotSignIn", function()
      client:request("signIn", vim.empty_dict(), function(err, result)
        if err then
          return
        end
        if result.command then
          local code = result.userCode
          local command = result.command
          vim.fn.setreg("+", code)
          vim.fn.setreg("*", code)
          client:exec_cmd(command, { bufnr = bufnr }, function(cmd_err, cmd_result)
            if cmd_err then
              return
            end
            if cmd_result.status == "OK" then
              vim.notify "Done"
            end
          end)
        end
      end)
    end, {})
    vim.api.nvim_buf_create_user_command(bufnr, "CopilotSignOut", function()
      client:request("signOut", vim.empty_dict(), function(err)
        if err then
          return
        end
        vim.notify "Done"
      end)
    end, {})
  end,
}

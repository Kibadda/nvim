if vim.g.loaded_plugin_codex then
  return
end

vim.g.loaded_plugin_codex = 1

local codex = require "me.codex"

vim.api.nvim_create_user_command("Codex", function(args)
  codex.open { prompt = args.args }
end, {
  nargs = "*",
})

vim.api.nvim_create_user_command("CodexBuffer", function(args)
  codex.buffer {
    ask = args.args == "",
    prompt = args.args,
  }
end, {
  nargs = "*",
})

vim.api.nvim_create_user_command("CodexSelection", function(args)
  codex.selection {
    ask = args.args == "",
    line1 = args.line1,
    line2 = args.line2,
    prompt = args.args,
  }
end, {
  nargs = "*",
  range = true,
})

vim.keymap.set("n", "<Leader>cx", function()
  codex.open()
end, { desc = "Codex" })

vim.keymap.set("n", "<Leader>cf", function()
  codex.buffer { ask = true }
end, { desc = "Codex Buffer" })

vim.keymap.set("x", "<Leader>cs", function()
  codex.selection { ask = true }
end, { desc = "Codex Selection" })

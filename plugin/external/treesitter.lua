vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } }, { load = true })

if vim.g.loaded_plugin_treesitter then
  return
end

vim.g.loaded_plugin_treesitter = 1

--- @type (string|table)[]
local parsers = {
  "gitcommit",
  "git_rebase",
  "diff",
  "html",
  "javascript",
  "lua",
  "markdown",
  "markdown_inline",
  "php",
  "php_only",
  "regex",
  "sql",
  "typescript",
  "nix",
  "bash",
  "typst",

  {
    name = "smarty",
    install_info = {
      path = vim.fn.expand "$HOME/Projects/Personal/tree-sitter-smarty",
      files = { "src/parser.c", "src/scanner.c" },
      queries = "queries/smarty",
    },
  },
}

local function add_parsers()
  local treesitter_parsers = require "nvim-treesitter.parsers"

  for _, config in ipairs(parsers) do
    if type(config) == "table" then
      treesitter_parsers[config.name] = config
    end
  end
end

local group = vim.api.nvim_create_augroup("Treesitter", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "TSUpdate",
  callback = add_parsers,
})

add_parsers()

local parser_names = vim.tbl_map(function(parser)
  return type(parser) == "string" and parser or parser.name
end, parsers)

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = parser_names,
  callback = function(args)
    vim.treesitter.start()
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require("nvim-treesitter").install(parser_names)

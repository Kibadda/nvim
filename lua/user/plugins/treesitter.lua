return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    ensure_install = {
      "javascript",
      "json",
      "jsonc",
      "typescript",
      "css",
      "php",
      "php_only",
      "phpdoc",
      "html",
      "sql",
      "http",
      "regex",
      "gitcommit",
      "gitignore",
      "gitattributes",
      "git_rebase",
      "git_config",
      "toml",
      "hyprlang",
    },
  },
  init = function(plugin)
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NvimTreesitter", { clear = true }),
      pattern = vim.list_extend({ "lua", "c", "markdown", "sh", "smarty" }, plugin.opts.ensure_install),
      callback = function(args)
        if args.match ~= "lua" then
          vim.treesitter.start()
        end
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
  config = function(_, opts)
    if vim.env.LOCATION == "work" then
      local parsers = require("nvim-treesitter.parsers").configs

      parsers.smarty = {
        install_info = {
          -- url = "https://github.com/Kibadda/tree-sitter-smarty",
          url = "/home/michael/Projects/Personal/tree-sitter-smarty",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "dev",
        },
        filetype = { "smarty" },
        maintainers = { "Kibadda" },
      }

      vim.opt.runtimepath:append(vim.fn.expand "$HOME/Projects/Personal/tree-sitter-smarty")
    end

    require("nvim-treesitter").setup(opts)
  end,
}

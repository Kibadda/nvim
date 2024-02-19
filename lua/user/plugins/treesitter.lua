return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
  },
  opts = {
    ensure_installed = {
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
    },
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-Space>",
        node_incremental = "<C-Space>",
        node_decremental = "<C-BS>",
      },
    },
    indent = {
      enable = true,
    },
    autotag = {
      enable = true,
      filetypes = {
        "html",
        "smarty",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "outer function" },
          ["if"] = { query = "@function.inner", desc = "inner function" },
          ["aa"] = { query = "@parameter.outer", desc = "outer function argument" },
          ["ia"] = { query = "@parameter.inner", desc = "inner function argument" },
        },
        selection_modes = {
          ["@function.outer"] = "V",
          ["@function.inner"] = "V",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]a"] = "@parameter.inner",
        },
        goto_next_end = {
          ["]A"] = "@parameter.inner",
        },
        goto_previous_start = {
          ["[a"] = "@parameter.inner",
        },
        goto_previous_end = {
          ["[A"] = "@parameter.inner",
        },
      },
    },
  },
  config = function(_, opts)
    ---@type table<string,ParserInfo>
    local parsers = require("nvim-treesitter.parsers").get_parser_configs()

    if vim.env.LOCATION == "work" then
      parsers.smarty = {
        install_info = {
          -- url = "https://github.com/Kibadda/tree-sitter-smarty",
          url = "/home/michael/Projects/Personal/tree-sitter-smarty",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "dev",
        },
        filetype = "smarty",
        maintainers = { "Kibadda" },
      }

      vim.opt.runtimepath:append(vim.fn.expand "$HOME/Projects/Personal/tree-sitter-smarty")
    end

    parsers.hyprlang = {
      install_info = {
        url = "https://github.com/tree-sitter-grammars/tree-sitter-hyprlang",
        files = { "src/parser.c" },
        branch = "master",
      },
      filetype = "hyprlang",
      maintainers = { "luckasRanarison" },
    }

    require("nvim-treesitter.configs").setup(opts)
  end,
}

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdateSync",
  dependencies = {
    "nvim-treesitter/playground",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
  },
  opts = {
    ensure_installed = {
      "bash",
      "javascript",
      "json",
      "jsonc",
      "python",
      "typescript",
      "tsx",
      "css",
      "php",
      "phpdoc",
      "haskell",
      "html",
      "sql",
      "http",
      "markdown",
      "markdown_inline",
      "regex",
      "gitcommit",
      "gitignore",
      "gitattributes",
      "git_rebase",
      "snippets",
      -- "smarty",
      -- "vue",
      -- "ocaml",
      -- "yaml",
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
    playground = {
      enable = true,
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
    local parsers = require("nvim-treesitter.parsers").get_parser_configs()

    parsers.smarty = {
      install_info = {
        url = "https://github.com/Kibadda/tree-sitter-smarty",
        -- url = "/home/michael/plugins/tree-sitter-smarty",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "master",
      },
    }

    parsers.snippets = {
      install_info = {
        url = "https://github.com/Kibadda/tree-sitter-snippets",
        -- url = "/home/michael/plugins/tree-sitter-snippets",
        files = { "src/parser.c" },
        branch = "main",
      },
    }

    require("nvim-treesitter.configs").setup(opts)
  end,
}

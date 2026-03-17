if vim.g.loaded_plugin_fake then
  return
end

vim.g.loaded_plugin_fake = 1

local function parse_flake_nix(buf, fun)
  local parser = assert(vim.treesitter.get_parser(buf, "nix"))
  local query = assert(vim.treesitter.query.get("nix", "flake_inputs"))

  parser:parse()

  for _, match in query:iter_matches(parser:trees()[1]:root(), buf, 0, -1) do
    local input = nil
    local range = nil
    local url = nil

    for id, nodes in ipairs(match) do
      if query.captures[id] == "input" then
        input = vim.treesitter.get_node_text(nodes[1], buf)
        local sline, srow, eline, erow = vim.treesitter.get_node_range(nodes[1])
        range = {
          start = { line = sline, character = srow },
          ["end"] = { line = eline, character = erow },
        }
      elseif query.captures[id] == "url" then
        url = vim.treesitter.get_node_text(nodes[1], buf)
      end
    end

    if input and url then
      local split = vim.split(url, "/")

      fun(input, split[1]:gsub("github%:", "https://github.com/") .. "/" .. split[2], range)
    end
  end
end

--- @type fake.config
vim.g.fake = {
  {
    enabled = function(buf)
      return vim.uri_from_bufnr(buf):find "advent%-of%-code" ~= nil
    end,
    codeactions = function(buf)
      local codeactions = {}

      local year, month = vim.uri_from_bufnr(buf):match "lua/advent%-of%-code/([^/]+)/([^/]+)/init%.lua"

      if year and month then
        table.insert(codeactions, {
          title = "open",
          command = {
            title = "open",
            command = "open_url",
            arguments = {
              url = ("https://adventofcode.com/%s/day/%s"):format(year, tonumber(month)),
            },
          },
        })
      end

      return codeactions
    end,
    snippets = {
      parse = "--- @param lines string[]\nfunction M:parse(lines)\n\tfor _, line in ipairs(lines) do\n\t\t$0\n\tend\nend",
    },
  },
  {
    filetype = "php",
    snippets = {
      debug = "Util::getLogger()->debug($0);",
      gst = "public function get$2(): $3 {\n\treturn \\$this->$1;\n}\n\npublic function set$2($3 \\$$1): void {\n\t\\$this->$1 = \\$$1;\n}",
      gs = "public function get$2() {\n\treturn \\$this->$1;\n}\n\npublic function set$2($$1) {\n\t\\$this->$1 = \\$$1;\n}",
    },
  },
  {
    filetype = { "javascript", "typescript" },
    snippets = {
      log = "console.log($0);",
    },
  },
  {
    filename = "flake.nix",
    commands = {
      update_input = function(arguments)
        if not arguments then
          return
        end

        local cmd = { "nix", "flake", "update" }

        if arguments.input then
          table.insert(cmd, arguments.input)
        else
          arguments.input = "all"
        end

        vim.system(cmd, nil, function(out)
          vim.schedule(function()
            if out.code ~= 0 then
              vim.notify(
                "error when updating input '" .. arguments.input .. "': " .. (out.stderr or "n/a"),
                vim.log.levels.ERROR
              )
            else
              vim.notify("updated input '" .. arguments.input .. "'", vim.log.levels.WARN)
            end
          end)
        end)
      end,
    },
    codeactions = function(buf)
      --- @type lsp.CodeAction[]
      local actions = {
        {
          title = "all: update",
          command = {
            title = "all: update",
            command = "update_input",
            arguments = {},
          },
        },
      }

      parse_flake_nix(buf, function(input, url)
        table.insert(actions, {
          title = input .. ": open",
          command = {
            title = "open",
            command = "open_url",
            arguments = { url = url },
          },
        })
        table.insert(actions, {
          title = input .. ": update",
          command = {
            title = "update",
            command = "update_input",
            arguments = { input = input },
          },
        })
      end)

      return actions
    end,
    codelenses = function(buf)
      --- @type lsp.CodeLens[]
      local lenses = {}

      parse_flake_nix(buf, function(input, url, range)
        table.insert(lenses, {
          range = range,
          command = {
            title = "open",
            command = "open_url",
            arguments = { url = url },
          },
        })
        table.insert(lenses, {
          range = range,
          command = {
            title = "update",
            command = "update_input",
            arguments = { input = input },
          },
        })
      end)

      return lenses
    end,
  },
}

vim.pack.add { "https://github.com/Kibadda/fake.nvim" }

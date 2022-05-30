local colors = require "user.plugins.visual.feline_theme.colors"

local vi_mode_colors = {
  NORMAL = colors.green,
  INSERT = colors.blue,
  VISUAL = colors.violet,
  OP = colors.green,
  BLOCK = colors.blue,
  REPLACE = colors.red,
  ["V-REPLACE"] = colors.red,
  ENTER = colors.cyan,
  MORE = colors.cyan,
  SELECT = colors.orange,
  COMMAND = colors.magenta,
  SHELL = colors.green,
  TERM = colors.blue,
  NONE = colors.yellow,
}

local vi_mode_text = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  [""] = "V-BLOCK",
  V = "V-LINE",
  c = "COMMAND",
  no = "UNKOWN",
  s = "UNKOWN",
  S = "UNKOWN",
  ic = "UNKOWN",
  R = "REPLACE",
  Rv = "UNKOWN",
  cv = "UNKOWN",
  ce = "UNKOWN",
  r = "REPLACE",
  rm = "UNKOWN",
  t = "INSERT",
}

local function file_osinfo()
  local os = vim.bo.file_format:upper()
  local icon
  if os == "UNIX" then
    icon = " "
  elseif os == "MAC" then
    icon = " "
  else
    icon = " "
  end
  return icon .. os
end

local function get_filename(component, modifiers)
  local modifiers_str = table.concat(modifiers, ":")
  local filename = vim.fn.expand("%" .. modifiers_str)
  local extension = vim.fn.expand "%:e"
  local modified_str

  local icon = component.icon or require("nvim-web-devicons").get_icon(filename, extension, { default = true })

  if filename == "" then
    filename = "unnamed"
  end

  if vim.bo.modified then
    local modified_icon = component.file_modified_icon or "●"
    modified_str = modified_icon .. " "
  else
    modified_str = ""
  end

  return icon .. " " .. filename .. " " .. modified_str
end

local lsp = require "feline.providers.lsp"
local vi_mode_utils = require "feline.providers.vi_mode"
local cursor = require "feline.providers.cursor"

local comps = {
  vi_mode = {
    left = {
      provider = function()
        local current_text = " " .. vi_mode_text[vim.fn.mode()] .. " "
        return current_text
      end,
      hl = function()
        local val = {
          name = vi_mode_utils.get_mode_highlight_name(),
          fg = colors.bg,
          bg = vi_mode_utils.get_mode_color(),
          style = "bold",
        }
        return val
      end,
    },
    right = {
      provider = "▊",
      hl = function()
        local val = {
          name = vi_mode_utils.get_mode_highlight_name(),
          fg = vi_mode_utils.get_mode_color(),
        }
        return val
      end,
      left_sep = " ",
    },
  },
  file = {
    info = {
      provider = require("user.plugins.visual.feline_theme.file_name").get_current_ufn,
      hl = {
        fg = colors.bg,
        style = "bold",
      },
      left_sep = " ",
    },
    encoding = {
      provider = "file_encoding",
      left_sep = " ",
      hl = {
        fg = colors.violet,
        style = "bold",
      },
    },
    type = {
      provider = "file_type",
    },
    os = {
      provider = file_osinfo,
      left_sep = " ",
      hl = {
        fg = colors.violet,
        style = "bold",
      },
    },
  },
  line_percentage = {
    provider = "line_percentage",
    left_sep = " ",
    hl = {
      style = "bold",
    },
  },
  position = {
    provider = function()
      local pos = cursor.position()
      return " " .. pos .. " "
    end,
    left_sep = " ",
    hl = function()
      local val = {
        name = vi_mode_utils.get_mode_highlight_name(),
        fg = colors.bg,
        bg = vi_mode_utils.get_mode_color(),
        style = "bold",
      }
      return val
    end,
  },
  scroll_bar = {
    provider = "scroll_bar",
    left_sep = " ",
    hl = {
      fg = colors.blue,
      style = "bold",
    },
  },
  diagnos = {
    err = {
      provider = "diagnostic_errors",
      enabled = function()
        return lsp.diagnostics_exist "Error"
      end,
      hl = {
        fg = colors.red,
      },
    },
    warn = {
      provider = "diagnostic_warnings",
      enabled = function()
        return lsp.diagnostics_exist "Warn"
      end,
      hl = {
        fg = colors.yellow,
      },
    },
    hint = {
      provider = "diagnostic_hints",
      enabled = function()
        return lsp.diagnostics_exist "Hint"
      end,
      hl = {
        fg = colors.cyan,
      },
    },
    info = {
      provider = "diagnostic_info",
      enabled = function()
        return lsp.diagnostics_exist "Info"
      end,
      hl = {
        fg = colors.blue,
      },
    },
  },
  lsp = {
    name = {
      provider = "lsp_client_names",
      left_sep = " ",
      icon = " ",
      hl = {
        fg = colors.yellow,
      },
    },
  },
  git = {
    branch = {
      provider = "git_branch",
      icon = " ",
      left_sep = " ",
      hl = {
        fg = colors.violet,
        style = "bold",
      },
    },
    add = {
      provider = "git_diff_added",
      hl = {
        fg = colors.green,
      },
    },
    change = {
      provider = "git_diff_changed",
      hl = {
        fg = colors.orange,
      },
    },
    remove = {
      provider = "git_diff_removed",
      hl = {
        fg = colors.red,
      },
    },
  },
}

local properties = {
  force_inactive = {
    filetypes = {
      "NvimTree",
      "packer",
    },
    buftypes = {
      "terminal",
    },
    bufnames = {},
  },
}

local components = {
  active = {
    {
      comps.vi_mode.left,
      comps.file.info,
      comps.lsp.name,
      comps.diagnos.err,
      comps.diagnos.warn,
      comps.diagnos.hint,
      comps.diagnos.info,
    },
    {},
    {
      comps.git.add,
      comps.git.change,
      comps.git.remove,
      -- comps.file.os,
      comps.git.branch,
      comps.scroll_bar,
      comps.line_percentage,
      -- comps.position,
    },
  },
  inactive = {
    {
      comps.file.info,
    },
    {},
    {
      comps.file.os,
    },
  },
}

require("feline").setup {
  default_bg = colors.bg,
  default_fg = colors.fg,
  components = components,
  properties = properties,
  vi_mode_colors = vi_mode_colors,
}

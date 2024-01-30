-- slightly changed version of https://github.com/MariaSolOs/dotfiles/blob/arch/.config/nvim/colors/miss-dracula.lua

-- Reset highlighting.
vim.cmd.highlight "clear"
if vim.fn.exists "syntax_on" then
  vim.cmd.syntax "reset"
end
vim.o.termguicolors = true
vim.g.colors_name = "kibadda"

local colors = {
  bg = "#0E1419",
  black = "#000000",
  bright_blue = "#D0B5F3",
  bright_cyan = "#BCF4F5",
  bright_green = "#97EDA2",
  bright_magenta = "#E7A1D7",
  bright_red = "#EC6A88",
  bright_white = "#FFFFFF",
  bright_yellow = "#F6F6B6",
  comment = "#B08BBB",
  cyan = "#A7DFEF",
  fg = "#F6F6F5",
  fuchsia = "#E11299",
  green = "#87E58E",
  grey = "#A9ABAC",
  gutter_fg = "#4B5263",
  lavender = "#6272A4",
  lilac = "#6D5978",
  menu = "#21222C",
  nontext = "#3B4048",
  orange = "#FFBFA9",
  pink = "#E48CC1",
  purple = "#BAA0E8",
  red = "#E95678",
  selection = "#3C4148",
  transparent_black = "#1E1F29",
  transparent_blue = "#19272C",
  transparent_green = "#22372c",
  transparent_red = "#342231",
  transparent_yellow = "#202624",
  visual = "#3E4452",
  white = "#F6F6F5",
  yellow = "#E8EDA2",
}

-- local colors = {
--   transparent = "NONE",
--   white = "#FEFEFE",
--   black = "#010101",

--   grey = "#334155",
--   lightgrey = "#D1D5DB",
--   darkgrey = "#151D2B",

--   red = "#BF7471",
--   lightred = "#FCA5A5",

--   green = "#98BC99",
--   lightgreen = "#B5E8B0",

--   blue = "#A5B4FC",
--   lightblue = "#DDD6FE",
--   darkblue = "#374151",

--   cyan = "#BAE6FD",
--   lightcyan = "#BCF4F5",

--   yellow = "#E8D4B0",
--   lightyellow = "#F6F6B6",

--   orange = "#FBC19D",

--   magenta = "#957FB8",

--   pink = "#FF0088",

--   bg = "#111827",
--   fg = "#D1D5DB",
-- }

-- Terminal colors.
vim.g.terminal_color_0 = colors.transparent_black
vim.g.terminal_color_1 = colors.red
vim.g.terminal_color_2 = colors.green
vim.g.terminal_color_3 = colors.yellow
vim.g.terminal_color_4 = colors.purple
vim.g.terminal_color_5 = colors.pink
vim.g.terminal_color_6 = colors.cyan
vim.g.terminal_color_7 = colors.white
vim.g.terminal_color_8 = colors.selection
vim.g.terminal_color_9 = colors.bright_red
vim.g.terminal_color_10 = colors.bright_green
vim.g.terminal_color_11 = colors.bright_yellow
vim.g.terminal_color_12 = colors.bright_blue
vim.g.terminal_color_13 = colors.bright_magenta
vim.g.terminal_color_14 = colors.bright_cyan
vim.g.terminal_color_15 = colors.bright_white
vim.g.terminal_color_background = colors.bg
vim.g.terminal_color_foreground = colors.fg

-- Groups used for my statusline.
---@type table<string, vim.api.keyset.highlight>
local statusline_groups = {}
for mode, color in pairs {
  Normal = "purple",
  Pending = "pink",
  Visual = "yellow",
  Insert = "green",
  Command = "cyan",
  Other = "orange",
} do
  statusline_groups["StatuslineMode" .. mode] = { fg = colors.transparent_black, bg = colors[color] }
  statusline_groups["StatuslineModeSeparator" .. mode] = { fg = colors[color], bg = "NONE" }
end
statusline_groups = vim.tbl_extend("error", statusline_groups, {
  StatuslineItalic = { fg = colors.grey, bg = "NONE", italic = true },
  StatuslineSpinner = { fg = colors.bright_green, bg = "NONE", bold = true },
  StatuslineTitle = { fg = colors.bright_white, bg = "NONE", bold = true },
})

---@type table<string, vim.api.keyset.highlight>
local groups = vim.tbl_extend("error", statusline_groups, {
  -- Builtins.
  Boolean = { fg = colors.cyan },
  Character = { fg = colors.green },
  ColorColumn = { bg = colors.selection },
  Comment = { fg = colors.comment },
  Conceal = { fg = colors.comment },
  Conditional = { fg = colors.pink },
  Constant = { fg = colors.yellow },
  Cursor = { fg = colors.black, bg = colors.white },
  CursorColumn = { bg = colors.transparent_black },
  CursorLine = { bg = colors.selection },
  CursorLineNr = { fg = colors.lilac, bold = true },
  Define = { fg = colors.purple },
  Directory = { fg = colors.cyan },
  EndOfBuffer = { fg = colors.bg },
  Error = { fg = colors.bright_red },
  ErrorMsg = { fg = colors.bright_red },
  FoldColumn = {},
  Folded = { bg = colors.transparent_black },
  Function = { fg = colors.yellow },
  Identifier = { fg = colors.cyan },
  IncSearch = { fg = colors.black, bg = colors.fuchsia },
  Include = { fg = colors.purple },
  Keyword = { fg = colors.cyan },
  Label = { fg = colors.cyan },
  LineNr = { fg = colors.lilac },
  Macro = { fg = colors.purple },
  MatchParen = { fg = colors.fg, underline = true },
  NonText = { fg = colors.nontext },
  Normal = { fg = colors.fg, bg = "NONE" },
  NormalFloat = { fg = colors.fg, bg = "NONE" },
  Number = { fg = colors.orange },
  Pmenu = { fg = colors.white, bg = colors.transparent_blue },
  PmenuSbar = { bg = colors.transparent_blue },
  PmenuSel = { fg = colors.cyan, bg = colors.selection },
  PmenuThumb = { bg = colors.selection },
  PreCondit = { fg = colors.cyan },
  PreProc = { fg = colors.yellow },
  Question = { fg = colors.purple },
  Repeat = { fg = colors.pink },
  Search = { fg = colors.bg, bg = colors.orange },
  SignColumn = { bg = colors.bg },
  Special = { fg = colors.green, italic = true },
  SpecialComment = { fg = colors.comment, italic = true },
  SpecialKey = { fg = colors.nontext },
  SpellBad = { fg = colors.bright_red, underline = true },
  SpellCap = { fg = colors.yellow },
  SpellLocal = { fg = colors.yellow },
  SpellRare = { fg = colors.yellow },
  Statement = { fg = colors.purple },
  StatusLine = { fg = colors.white, bg = "NONE" },
  StorageClass = { fg = colors.pink },
  Structure = { fg = colors.yellow },
  Substitute = { fg = colors.fuchsia, bg = colors.orange, bold = true },
  Title = { fg = colors.cyan },
  Todo = { fg = colors.purple, bold = true, italic = true },
  Type = { fg = colors.cyan },
  TypeDef = { fg = colors.yellow },
  Underlined = { fg = colors.cyan, underline = true },
  VertSplit = { fg = colors.white },
  Visual = { bg = colors.visual },
  VisualNOS = { fg = colors.visual },
  WarningMsg = { fg = colors.yellow },
  WildMenu = { fg = colors.transparent_black, bg = colors.white },

  -- TreeSitter.
  ["@annotation"] = { fg = colors.yellow },
  ["@attribute"] = { fg = colors.cyan },
  ["@boolean"] = { fg = colors.purple },
  ["@character"] = { fg = colors.green },
  ["@constant"] = { fg = colors.purple },
  ["@constant.builtin"] = { fg = colors.purple },
  ["@constant.macro"] = { fg = colors.cyan },
  ["@constructor"] = { fg = colors.cyan },
  ["@error"] = { fg = colors.bright_red },
  ["@function"] = { fg = colors.green },
  ["@function.builtin"] = { fg = colors.cyan },
  ["@function.macro"] = { fg = colors.green },
  ["@function.method"] = { fg = colors.green },
  ["@keyword"] = { fg = colors.pink },
  ["@keyword.conditional"] = { fg = colors.pink },
  ["@keyword.exception"] = { fg = colors.purple },
  ["@keyword.function"] = { fg = colors.cyan },
  ["@keyword.function.ruby"] = { fg = colors.pink },
  ["@keyword.include"] = { fg = colors.pink },
  ["@keyword.operator"] = { fg = colors.pink },
  ["@keyword.repeat"] = { fg = colors.pink },
  ["@label"] = { fg = colors.cyan },
  ["@markup"] = { fg = colors.orange },
  ["@markup.emphasis"] = { fg = colors.yellow, italic = true },
  ["@markup.heading"] = { fg = colors.pink, bold = true },
  ["@markup.link"] = { fg = colors.orange, bold = true },
  ["@markup.link.uri"] = { fg = colors.yellow, italic = true },
  ["@markup.list"] = { fg = colors.cyan },
  ["@markup.raw"] = { fg = colors.yellow },
  ["@markup.strong"] = { fg = colors.orange, bold = true },
  ["@markup.underline"] = { fg = colors.orange },
  ["@module"] = { fg = colors.orange },
  ["@number"] = { fg = colors.purple },
  ["@number.float"] = { fg = colors.green },
  ["@operator"] = { fg = colors.pink },
  ["@parameter.reference"] = { fg = colors.orange },
  ["@property"] = { fg = colors.purple },
  ["@punctuation.bracket"] = { fg = colors.fg },
  ["@punctuation.delimiter"] = { fg = colors.fg },
  ["@string"] = { fg = colors.yellow },
  ["@string.escape"] = { fg = colors.cyan },
  ["@string.regexp"] = { fg = colors.red },
  ["@string.special.symbol"] = { fg = colors.purple },
  ["@structure"] = { fg = colors.purple },
  ["@tag"] = { fg = colors.cyan },
  ["@tag.attribute"] = { fg = colors.green },
  ["@tag.delimiter"] = { fg = colors.cyan },
  ["@type"] = { fg = colors.bright_cyan },
  ["@type.builtin"] = { fg = colors.cyan, italic = true },
  ["@type.qualifier"] = { fg = colors.pink },
  ["@variable"] = { fg = colors.fg },
  ["@variable.builtin"] = { fg = colors.purple },
  ["@variable.member"] = { fg = colors.orange },
  ["@variable.parameter"] = { fg = colors.orange },

  -- Semantic tokens.
  ["@class"] = { fg = colors.cyan },
  ["@decorator"] = { fg = colors.cyan },
  ["@enum"] = { fg = colors.cyan },
  ["@enumMember"] = { fg = colors.purple },
  ["@event"] = { fg = colors.cyan },
  ["@interface"] = { fg = colors.cyan },
  ["@lsp.type.class"] = { fg = colors.cyan },
  ["@lsp.type.decorator"] = { fg = colors.green },
  ["@lsp.type.enum"] = { fg = colors.cyan },
  ["@lsp.type.enumMember"] = { fg = colors.purple },
  ["@lsp.type.function"] = { fg = colors.green },
  ["@lsp.type.interface"] = { fg = colors.cyan },
  ["@lsp.type.macro"] = { fg = colors.cyan },
  ["@lsp.type.method"] = { fg = colors.green },
  ["@lsp.type.namespace"] = { fg = colors.orange },
  ["@lsp.type.parameter"] = { fg = colors.orange },
  ["@lsp.type.property"] = { fg = colors.purple },
  ["@lsp.type.struct"] = { fg = colors.cyan },
  ["@lsp.type.type"] = { fg = colors.bright_cyan },
  ["@lsp.type.variable"] = { fg = colors.fg },
  ["@modifier"] = { fg = colors.cyan },
  ["@regexp"] = { fg = colors.yellow },
  ["@struct"] = { fg = colors.cyan },
  ["@typeParameter"] = { fg = colors.cyan },

  -- LSP.
  DiagnosticDeprecated = { strikethrough = true, fg = colors.fg },
  DiagnosticError = { fg = colors.red },
  DiagnosticFloatingError = { fg = colors.red },
  DiagnosticFloatingHint = { fg = colors.cyan },
  DiagnosticFloatingInfo = { fg = colors.cyan },
  DiagnosticFloatingWarn = { fg = colors.yellow },
  DiagnosticHint = { fg = colors.cyan },
  DiagnosticInfo = { fg = colors.cyan },
  DiagnosticUnderlineError = { undercurl = true, sp = colors.red },
  DiagnosticUnderlineHint = { undercurl = true, sp = colors.cyan },
  DiagnosticUnderlineInfo = { undercurl = true, sp = colors.cyan },
  DiagnosticUnderlineWarn = { undercurl = true, sp = colors.yellow },
  DiagnosticUnnecessary = { fg = colors.white, italic = true },
  DiagnosticVirtualTextError = { fg = colors.red, bg = "NONE" },
  DiagnosticVirtualTextHint = { fg = colors.cyan, bg = "NONE" },
  DiagnosticVirtualTextInfo = { fg = colors.cyan, bg = "NONE" },
  DiagnosticVirtualTextWarn = { fg = colors.yellow, bg = "NONE" },
  DiagnosticWarn = { fg = colors.yellow },
  LspCodeLens = { fg = colors.cyan },
  LspInlayHint = { fg = colors.lavender, italic = true },
  LspReferenceRead = { bg = colors.transparent_blue },
  LspReferenceText = {},
  LspReferenceWrite = { bg = colors.transparent_red },
  LspSignatureActiveParameter = { bold = true, underline = true, sp = colors.fg },

  -- Completions.
  CmpItemAbbrDeprecated = { link = "DiagnosticDeprecated" },
  CmpItemAbbrMatch = { fg = colors.cyan, bg = "NONE" },
  CmpItemKind = { bg = "NONE" },
  CmpItemKindClass = { link = "@type" },
  CmpItemKindColor = { link = "DevIconCss" },
  CmpItemKindConstant = { link = "@constant" },
  CmpItemKindConstructor = { link = "@type" },
  CmpItemKindEnum = { link = "@field" },
  CmpItemKindEnumMember = { link = "@field" },
  CmpItemKindEvent = { link = "@constant" },
  CmpItemKindField = { link = "@field" },
  CmpItemKindFile = { link = "Directory" },
  CmpItemKindFolder = { link = "Directory" },
  CmpItemKindFunction = { link = "@function" },
  CmpItemKindInterface = { link = "@type" },
  CmpItemKindKeyword = { link = "@keyword" },
  CmpItemKindMethod = { link = "@method" },
  CmpItemKindModule = { link = "@namespace" },
  CmpItemKindOperator = { link = "@operator" },
  CmpItemKindProperty = { link = "@property" },
  CmpItemKindReference = { link = "@parameter.reference" },
  CmpItemKindSnippet = { link = "@text" },
  CmpItemKindStruct = { link = "@structure" },
  CmpItemKindText = { link = "@text" },
  CmpItemKindTypeParameter = { link = "@parameter" },
  CmpItemKindUnit = { link = "@field" },
  CmpItemKindValue = { link = "@field" },
  CmpItemKindVariable = { link = "@variable" },
  CmpItemMenu = { fg = colors.grey },

  -- Make whitespace less prominent.
  Whitespace = { fg = "#292d32" },

  -- Diffs.
  DiffAdd = { fg = colors.green, bg = colors.transparent_green },
  DiffChange = { fg = colors.yellow, bg = colors.transparent_yellow },
  DiffDelete = { fg = colors.red, bg = colors.transparent_red },
  DiffText = { fg = colors.bright_white, bg = colors.transparent_black },
  DiffviewFolderSign = { fg = colors.cyan },
  DiffviewNonText = { fg = colors.lilac },
  diffAdded = { fg = colors.bright_green, bold = true },
  diffChanged = { fg = colors.bright_yellow, bold = true },
  diffRemoved = { fg = colors.bright_red, bold = true },

  -- Command line.
  MoreMsg = { fg = colors.bright_white, bold = true },
  MsgArea = { fg = colors.cyan },
  MsgSeparator = { fg = colors.lilac },

  -- Winbar styling.
  WinBar = { fg = colors.fg, bg = "NONE" },
  WinBarNC = { link = "WinBar" },

  -- Quickfix window.
  QuickFixLine = { italic = true, bg = colors.transparent_red },
  qfPath = { fg = colors.bright_blue },
  qfPosition = { fg = colors.pink, underline = true },

  -- Gitsigns.
  GitSignsAdd = { fg = colors.bright_green },
  GitSignsChange = { fg = colors.cyan },
  GitSignsDelete = { fg = colors.bright_red },

  -- Bufferline.
  BufferLineBufferSelected = { bg = "NONE" },
  BufferLineFill = { bg = "NONE" },
  TabLine = { fg = colors.comment, bg = colors.bg },
  TabLineFill = { bg = colors.bg },
  TabLineSel = { bg = colors.purple },

  -- Nicer yanky highlights.
  YankyPut = { link = "Visual" },
  YankyYanked = { link = "Visual" },
})

for group, opts in pairs(groups) do
  vim.api.nvim_set_hl(0, group, opts)
end

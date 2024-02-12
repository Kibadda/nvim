-- Based on mfussenegger/gruvbox-material

vim.cmd.highlight "clear"
if vim.g.syntax_on then
  vim.cmd.syntax "reset"
end
vim.g.colors_name = "gruvbox-transparent"

local colors = {
  black = "#504945",
  red = "#ea6962",
  green = "#a9b665",
  yellow = "#d8a657",
  blue = "#7daea3",
  magenta = "#d3869b",
  cyan = "#89b482",
  white = "#d4be98",
  bright_black = "#504945",
  bright_red = "#ea6962",
  bright_green = "#a9b665",
  bright_yellow = "#d8a657",
  bright_blue = "#7daea3",
  bright_magenta = "#d3869b",
  bright_cyan = "#89b482",
  bright_white = "#d4be98",
}

vim.g.colors = colors
vim.g.terminal_color_0 = colors.black
vim.g.terminal_color_1 = colors.red
vim.g.terminal_color_2 = colors.green
vim.g.terminal_color_3 = colors.yellow
vim.g.terminal_color_4 = colors.blue
vim.g.terminal_color_5 = colors.magenta
vim.g.terminal_color_6 = colors.cyan
vim.g.terminal_color_7 = colors.white
vim.g.terminal_color_8 = colors.bright_black
vim.g.terminal_color_9 = colors.bright_red
vim.g.terminal_color_10 = colors.bright_green
vim.g.terminal_color_11 = colors.bright_yellow
vim.g.terminal_color_12 = colors.bright_blue
vim.g.terminal_color_13 = colors.bright_magenta
vim.g.terminal_color_14 = colors.bright_cyan
vim.g.terminal_color_15 = colors.bright_white

local theme = {
  diffIndexLine = { link = "Purple" },
  diffLine = { link = "Grey" },
  diffOldFile = { link = "Yellow" },
  diffChanged = { link = "Blue" },
  Operator = { fg = "#e78a4e" },
  InclineNormalNC = { fg = "#928374" },
  TargetFileName = { link = "Grey" },
  DefinitionCount = { link = "Grey" },
  ReferencesCount = { link = "Grey" },
  String = { fg = colors.bright_green },
  Number = { fg = colors.bright_magenta },
  SpecialKey = { fg = colors.bright_black },
  EndOfBuffer = { fg = colors.bright_black },
  TermCursor = { reverse = true },
  TermCursorNC = {},
  NonText = { fg = colors.bright_black },
  Directory = { fg = colors.bright_green },
  ErrorMsg = { underline = true, fg = colors.bright_red, bold = true },
  DiagnosticInformation = { link = "DiagnosticInfo" },
  Search = { fg = "#1d2021", bg = colors.bright_green },
  CurSearch = {},
  MoreMsg = { fg = colors.bright_yellow, bold = true },
  ModeMsg = { fg = colors.bright_white, bold = true },
  LineNr = { fg = colors.bright_black },
  LineNrAbove = { link = "LineNr" },
  LineNrBelow = { link = "LineNr" },
  CursorLineNr = { fg = colors.white },
  CursorLineSign = { link = "SignColumn" },
  DiagnosticWarning = { link = "DiagnosticWarn" },
  LineDiagTuncateLine = { link = "Yellow" },
  LspLinesDiagBorder = { link = "Yellow" },
  DefinitionIcon = { link = "Blue" },
  DiagnosticVirtualTextHint = { link = "VirtualTextHint" },
  DiagnosticVirtualTextError = { link = "VirtualTextError" },
  DiagnosticVirtualTextWarn = { link = "VirtualTextWarning" },
  WarningMsg = { fg = colors.bright_yellow, bold = true },
  DiagnosticVirtualTextInfo = { link = "VirtualTextInfo" },
  DiagnosticUnderlineHint = { underline = true, special = "#d3d3d3" },
  DiagnosticUnderlineError = { underline = true, special = "#ff0000" },
  DiagnosticUnderlineWarn = { underline = true, special = "#ffa500" },
  DiagnosticUnderlineInfo = { underline = true, special = "#add8e6" },
  DiagnosticFloatingHint = { link = "HintFloat" },
  DiagnosticFloatingError = { link = "ErrorFloat" },
  DiagnosticFloatingWarn = { link = "WarningFloat" },
  DiagnosticFloatingInfo = { link = "InfoFloat" },
  DiagnosticSignHint = { link = "GreenSign" },
  DiagnosticSignError = { link = "RedSign" },
  DiagnosticSignWarn = { link = "YellowSign" },
  DiagnosticSignInfo = { link = "BlueSign" },
  DefinitionPreviewTitle = { fg = colors.bright_blue, bold = true },
  IndentBlanklineSpaceCharBlankline = { link = "LineNr" },
  IndentBlanklineSpaceChar = { link = "LineNr" },
  IndentBlanklineChar = { link = "LineNr" },
  IndentBlanklineContextChar = { link = "Grey" },
  TroubleCode = { link = "Grey" },
  TroubleSource = { link = "Grey" },
  TroubleText = { link = "Fg" },
  NormalFloat = { fg = "#ddc7a1" },
  FloatermBorder = { link = "Grey" },
  LspSignatureActiveParameter = { link = "Search" },
  Error = { fg = colors.bright_red },
  Warning = {},
  Blamer = { link = "Grey" },
  IncSearch = { fg = "#1d2021", bg = colors.bright_red },
  SignatureMarkerText = { link = "PurpleSign" },
  SignatureMarkText = { link = "BlueSign" },
  StatusLineTerm = { fg = "#ddc7a1" },
  NvimInvalidStringBody = { link = "NvimStringBody" },
  NvimInvalidEnvironmentSigil = { link = "NvimInvalidOptionSigil" },
  NvimInvalidFloat = { link = "NvimInvalidNumber" },
  multiple_cursors_cursor = { link = "Cursor" },
  PurpleSign = { fg = colors.bright_magenta },
  Orange = { fg = "#e78a4e" },
  Bold = {},
  Function = { fg = colors.bright_cyan },
  Keyword = { fg = colors.bright_red },
  Constant = { link = "Purple" },
  lspInlayHintsParameter = { link = "LineNr" },
  lspInlayHintsType = { link = "LineNr" },
  lspReference = { link = "CurrentWord" },
  LspHintHighlight = { link = "HintText" },
  LspInformationHighlight = { link = "InfoText" },
  LspWarningHighlight = { link = "WarningText" },
  LspErrorHighlight = { link = "ErrorText" },
  NvimInvalidStringQuote = { link = "NvimInvalidString" },
  NvimInvalidString = { link = "NvimInvalidValue" },
  NvimInvalidEnvironmentName = { link = "NvimInvalidIdentifier" },
  NvimInvalidOptionScopeDelimiter = { link = "NvimInvalidIdentifierScopeDelimiter" },
  NvimInvalidOptionScope = { link = "NvimInvalidIdentifierScope" },
  NvimInvalidOptionName = { link = "NvimInvalidIdentifier" },
  NvimInvalidOptionSigil = { link = "NvimInvalidIdentifier" },
  NvimInvalidNumberPrefix = { link = "NvimInvalidNumber" },
  NvimInvalidNumber = { link = "NvimInvalidValue" },
  NvimInvalidRegister = { link = "NvimInvalidValue" },
  NvimInvalidArrow = { link = "NvimInvalidDelimiter" },
  NvimInvalidComma = { link = "NvimInvalidDelimiter" },
  NvimInvalidColon = { link = "NvimInvalidDelimiter" },
  NvimInvalidIdentifierKey = { link = "NvimInvalidIdentifier" },
  NvimInvalidIdentifierName = { link = "NvimInvalidIdentifier" },
  MarkdownH3 = {},
  diffAdded = { link = "Green" },
  VimGroup = {},
  Delimeter = {},
  Terminal = { fg = colors.bright_white },
  ErrorText = { undercurl = true, special = colors.bright_red },
  InfoText = { undercurl = true, special = colors.bright_blue },
  GitGutterChange = { link = "BlueSign" },
  LspCodeLens = { link = "VirtualTextInfo" },
  LspCodeLensSeparator = { link = "VirtualTextHint" },
  diffFile = { link = "Aqua" },
  diffNewFile = { link = "Orange" },
  diffRemoved = { link = "Red" },
  ToolbarLine = { fg = "#ddc7a1" },
  YellowSign = { fg = colors.bright_yellow },
  BlueSign = { fg = colors.bright_blue },
  GreenSign = { fg = colors.bright_green },
  Boolean = { fg = colors.bright_magenta },
  MatchParen = { bg = "#3c3836" },
  Ignore = { fg = "#928374" },
  NvimInternalError = { fg = "#ff0000" },
  NvimAssignment = { link = "Operator" },
  NvimPlainAssignment = { link = "NvimAssignment" },
  NvimAugmentedAssignment = { link = "NvimAssignment" },
  NvimAssignmentWithAddition = { link = "NvimAugmentedAssignment" },
  NvimAssignmentWithSubtraction = { link = "NvimAugmentedAssignment" },
  NvimAssignmentWithConcatenation = { link = "NvimAugmentedAssignment" },
  NvimOperator = { link = "Operator" },
  NvimUnaryOperator = { link = "NvimOperator" },
  NvimUnaryPlus = { link = "NvimUnaryOperator" },
  NvimUnaryMinus = { link = "NvimUnaryOperator" },
  NvimNot = { link = "NvimUnaryOperator" },
  NvimBinaryOperator = { link = "NvimOperator" },
  NvimComparison = { link = "NvimBinaryOperator" },
  NvimComparisonModifier = { link = "NvimComparison" },
  NvimBinaryPlus = { link = "NvimBinaryOperator" },
  NvimBinaryMinus = { link = "NvimBinaryOperator" },
  NvimConcat = { link = "NvimBinaryOperator" },
  NvimConcatOrSubscript = { link = "NvimConcat" },
  NvimOr = { link = "NvimBinaryOperator" },
  NvimAnd = { link = "NvimBinaryOperator" },
  NvimMultiplication = { link = "NvimBinaryOperator" },
  NvimDivision = { link = "NvimBinaryOperator" },
  NvimMod = { link = "NvimBinaryOperator" },
  NvimTernary = { link = "NvimOperator" },
  NvimTernaryColon = { link = "NvimTernary" },
  NvimParenthesis = { link = "Delimiter" },
  NvimLambda = { link = "NvimParenthesis" },
  NvimNestingParenthesis = { link = "NvimParenthesis" },
  NvimCallingParenthesis = { link = "NvimParenthesis" },
  NvimSubscript = { link = "NvimParenthesis" },
  NvimSubscriptBracket = { link = "NvimSubscript" },
  NvimSubscriptColon = { link = "NvimSubscript" },
  NvimCurly = { link = "NvimSubscript" },
  NvimContainer = { link = "NvimParenthesis" },
  NvimDict = { link = "NvimContainer" },
  NvimList = { link = "NvimContainer" },
  NvimIdentifier = { link = "Identifier" },
  NvimIdentifierScope = { link = "NvimIdentifier" },
  NvimIdentifierScopeDelimiter = { link = "NvimIdentifier" },
  NvimIdentifierName = { link = "NvimIdentifier" },
  NvimIdentifierKey = { link = "NvimIdentifier" },
  NvimColon = { link = "Delimiter" },
  NvimComma = { link = "Delimiter" },
  NvimArrow = { link = "Delimiter" },
  NvimRegister = { link = "SpecialChar" },
  NvimNumber = { link = "Number" },
  NvimFloat = { link = "NvimNumber" },
  NvimNumberPrefix = { link = "Type" },
  NvimOptionSigil = { link = "Type" },
  NvimOptionName = { link = "NvimIdentifier" },
  NvimOptionScope = { link = "NvimIdentifierScope" },
  NvimOptionScopeDelimiter = { link = "NvimIdentifierScopeDelimiter" },
  NvimEnvironmentSigil = { link = "NvimOptionSigil" },
  NvimEnvironmentName = { link = "NvimIdentifier" },
  NvimString = { link = "String" },
  NvimStringBody = { link = "NvimString" },
  NvimStringQuote = { link = "NvimString" },
  NvimStringSpecial = { link = "SpecialChar" },
  NvimSingleQuote = { link = "NvimStringQuote" },
  NvimSingleQuotedBody = { link = "NvimStringBody" },
  NvimSingleQuotedQuote = { link = "NvimStringSpecial" },
  NvimDoubleQuote = { link = "NvimStringQuote" },
  NvimDoubleQuotedBody = { link = "NvimStringBody" },
  NvimDoubleQuotedEscape = { link = "NvimStringSpecial" },
  NvimFigureBrace = { link = "NvimInternalError" },
  NvimSingleQuotedUnknownEscape = { link = "NvimInternalError" },
  NvimSpacing = { link = "Normal" },
  NvimInvalidSingleQuotedUnknownEscape = { link = "NvimInternalError" },
  NvimInvalid = { link = "Error" },
  NvimInvalidAssignment = { link = "NvimInvalid" },
  NvimInvalidPlainAssignment = { link = "NvimInvalidAssignment" },
  NvimInvalidAugmentedAssignment = { link = "NvimInvalidAssignment" },
  NvimInvalidAssignmentWithAddition = { link = "NvimInvalidAugmentedAssignment" },
  NvimInvalidAssignmentWithSubtraction = { link = "NvimInvalidAugmentedAssignment" },
  NvimInvalidAssignmentWithConcatenation = { link = "NvimInvalidAugmentedAssignment" },
  NvimInvalidOperator = { link = "NvimInvalid" },
  NvimInvalidUnaryOperator = { link = "NvimInvalidOperator" },
  NvimInvalidUnaryPlus = { link = "NvimInvalidUnaryOperator" },
  NvimInvalidUnaryMinus = { link = "NvimInvalidUnaryOperator" },
  NvimInvalidNot = { link = "NvimInvalidUnaryOperator" },
  NvimInvalidBinaryOperator = { link = "NvimInvalidOperator" },
  NvimInvalidComparison = { link = "NvimInvalidBinaryOperator" },
  NvimInvalidComparisonModifier = { link = "NvimInvalidComparison" },
  NvimInvalidBinaryPlus = { link = "NvimInvalidBinaryOperator" },
  NvimInvalidBinaryMinus = { link = "NvimInvalidBinaryOperator" },
  NvimInvalidConcat = { link = "NvimInvalidBinaryOperator" },
  NvimInvalidConcatOrSubscript = { link = "NvimInvalidConcat" },
  NvimInvalidOr = { link = "NvimInvalidBinaryOperator" },
  NvimInvalidAnd = { link = "NvimInvalidBinaryOperator" },
  NvimInvalidMultiplication = { link = "NvimInvalidBinaryOperator" },
  NvimInvalidDivision = { link = "NvimInvalidBinaryOperator" },
  NvimInvalidMod = { link = "NvimInvalidBinaryOperator" },
  NvimInvalidTernary = { link = "NvimInvalidOperator" },
  NvimInvalidTernaryColon = { link = "NvimInvalidTernary" },
  NvimInvalidDelimiter = { link = "NvimInvalid" },
  NvimInvalidParenthesis = { link = "NvimInvalidDelimiter" },
  NvimInvalidLambda = { link = "NvimInvalidParenthesis" },
  NvimInvalidNestingParenthesis = { link = "NvimInvalidParenthesis" },
  NvimInvalidCallingParenthesis = { link = "NvimInvalidParenthesis" },
  NvimInvalidSubscript = { link = "NvimInvalidParenthesis" },
  NvimInvalidSubscriptBracket = { link = "NvimInvalidSubscript" },
  NvimInvalidSubscriptColon = { link = "NvimInvalidSubscript" },
  NvimInvalidCurly = { link = "NvimInvalidSubscript" },
  NvimInvalidContainer = { link = "NvimInvalidParenthesis" },
  NvimInvalidDict = { link = "NvimInvalidContainer" },
  NvimInvalidList = { link = "NvimInvalidContainer" },
  NvimInvalidValue = { link = "NvimInvalid" },
  NvimInvalidIdentifier = { link = "NvimInvalidValue" },
  NvimInvalidIdentifierScope = { link = "NvimInvalidIdentifier" },
  NvimInvalidIdentifierScopeDelimiter = { link = "NvimInvalidIdentifier" },
  SignColumn = { fg = colors.bright_white },
  CursorLineFold = { link = "FoldColumn" },
  FoldColumn = { fg = colors.bright_black },
  StatusLine = { fg = "#ddc7a1" },
  StatusLineNC = { fg = "#928374" },
  WinSeparator = { link = "VertSplit" },
  VertSplit = { fg = colors.bright_black },
  Title = { fg = "#e78a4e", bold = true },
  Visual = { bg = colors.black },
  VisualNC = {},
  WildMenu = { fg = "#000000", bg = "#ffff00" },
  Folded = { fg = "#928374" },
  DiffAdd = { bg = "#32361a" },
  DiffChange = { bg = "#0d3138" },
  DiffDelete = { bg = "#3c1f1e" },
  DiffText = { fg = "#1d2021", bg = colors.bright_blue },
  Conceal = { fg = colors.bright_black },
  SpellBad = { undercurl = true, special = colors.bright_red },
  NvimInvalidStringSpecial = { link = "NvimStringSpecial" },
  NvimInvalidSingleQuote = { link = "NvimInvalidStringQuote" },
  NvimInvalidSingleQuotedBody = { link = "NvimInvalidStringBody" },
  NvimInvalidSingleQuotedQuote = { link = "NvimInvalidStringSpecial" },
  NvimInvalidDoubleQuote = { link = "NvimInvalidStringQuote" },
  NvimInvalidDoubleQuotedBody = { link = "NvimInvalidStringBody" },
  NvimInvalidDoubleQuotedEscape = { link = "NvimInvalidStringSpecial" },
  NvimInvalidDoubleQuotedUnknownEscape = { link = "NvimInvalidValue" },
  NvimInvalidFigureBrace = { link = "NvimInvalidDelimiter" },
  NvimInvalidSpacing = { link = "ErrorMsg" },
  NvimDoubleQuotedUnknownEscape = { link = "NvimInvalidValue" },
  MarkdownBoldDelimiter = {},
  MarkdownBold = {},
  MarkdownHeadingRule = {},
  MarkdownHeading = {},
  MarkdownHeadingDelimiter = {},
  MarkdownH6 = {},
  MarkdownH5 = {},
  MarkdownH4 = {},
  Normal = { fg = colors.bright_white },
  MarkdownH2 = {},
  MarkdownH1 = {},
  MarkdownRule = {},
  CurrentWord = { bg = colors.black },
  HintText = { undercurl = true, special = colors.bright_green },
  WarningText = { undercurl = true, special = colors.bright_yellow },
  MatchParenCur = { bold = true },
  MatchWord = { underline = true },
  MatchWordCur = { underline = true },
  Question = { fg = colors.bright_yellow },
  CurrentWordTwins = { link = "CurrentWord" },
  CursorWord0 = { link = "CurrentWord" },
  CursorWord1 = { link = "CurrentWord" },
  healthError = { link = "Red" },
  healthSuccess = { link = "Green" },
  healthWarning = { link = "Yellow" },
  Yellow = { fg = colors.bright_yellow },
  Fg = { fg = colors.bright_white },
  Blue = { fg = colors.bright_blue },
  Purple = { fg = colors.bright_magenta },
  RedItalic = { fg = colors.bright_red },
  OrangeItalic = { fg = "#e78a4e" },
  YellowItalic = { fg = colors.bright_yellow },
  GreenItalic = { fg = colors.bright_green },
  AquaItalic = { fg = colors.bright_cyan },
  BlueItalic = { fg = colors.bright_blue },
  PurpleItalic = { fg = colors.bright_magenta },
  RedBold = { fg = colors.bright_red },
  OrangeBold = { fg = "#e78a4e" },
  YellowBold = { fg = colors.bright_yellow },
  GreenBold = { fg = colors.bright_green },
  AquaBold = { fg = colors.bright_cyan },
  BlueBold = { fg = colors.bright_blue },
  PurpleBold = { fg = colors.bright_magenta },
  OrangeSign = { fg = "#e78a4e" },
  AquaSign = { fg = colors.bright_cyan },
  ErrorLine = {},
  WarningLine = {},
  InfoLine = {},
  HintLine = {},
  HopNextKey = { fg = "#e78a4e", bold = true },
  HopNextKey1 = { fg = colors.bright_green, bold = true },
  HopNextKey2 = { link = "Green" },
  HopPreview = { fg = "#b8bb26", bold = true },
  HopUnmatched = { link = "Grey" },
  HopCursor = { link = "Cursor" },
  HighlightedyankRegion = { link = "Visual" },
  LspErrorVirtual = { link = "VirtualTextError" },
  LspWarningVirtual = { link = "VirtualTextWarning" },
  LspInformationVirtual = { link = "VirtualTextInfo" },
  LspHintVirtual = { link = "VirtualTextHint" },
  SpellCap = { undercurl = true, special = colors.bright_blue },
  SpellRare = { undercurl = true, special = colors.bright_magenta },
  SpellLocal = { undercurl = true, special = colors.bright_cyan },
  Pmenu = { fg = "#ddc7a1" },
  PmenuSel = { fg = "#928374" },
  PmenuSbar = { bg = "#3c3836" },
  PmenuThumb = { bg = "#7c6f64" },
  TabLine = { fg = "#ddc7a1" },
  TabLineSel = { fg = "#1d2021" },
  TabLineFill = { fg = "#ddc7a1" },
  CursorColumn = { bg = "#282828" },
  CursorLine = { bg = "#2b2622" },
  ColorColumn = { bg = "#282828" },
  QuickFixLine = { fg = colors.bright_magenta, bold = true },
  Whitespace = { fg = colors.bright_black },
  NormalNC = {},
  MsgSeparator = { link = "StatusLine" },
  MsgArea = {},
  FloatBorder = { fg = "#928374" },
  WinBar = { bold = true },
  WinBarNC = { link = "Grey" },
  Grey = { fg = "#928374" },
  Cursor = { reverse = true },
  lCursor = { fg = "#1d2021" },
  Substitute = { fg = "#1d2021", bg = colors.bright_yellow },
  FloatShadow = { bg = "#000000", blend = 80 },
  FloatShadowThrough = { bg = "#000000", blend = 100 },
  Todo = { italic = true, fg = colors.bright_magenta },
  Character = { fg = colors.bright_green },
  Float = { fg = colors.bright_magenta },
  Identifier = { fg = colors.bright_blue },
  Conditional = { fg = colors.bright_red },
  Statement = { fg = colors.bright_red },
  Repeat = { fg = colors.bright_red },
  Label = { fg = "#e78a4e" },
  Exception = { fg = colors.bright_red },
  Include = { fg = colors.bright_magenta },
  PreProc = { fg = colors.bright_magenta },
  Define = { fg = colors.bright_magenta },
  Macro = { fg = colors.bright_cyan },
  PreCondit = { fg = colors.bright_magenta },
  StorageClass = { fg = "#e78a4e" },
  Structure = { fg = "#e78a4e" },
  Typedef = { fg = colors.bright_red },
  Tag = { fg = "#e78a4e" },
  Special = { fg = colors.bright_yellow },
  SpecialChar = { fg = colors.bright_yellow },
  Delimiter = { fg = colors.bright_white },
  SpecialComment = { italic = true, fg = "#928374" },
  Debug = { fg = "#e78a4e" },
  DiagnosticError = { fg = "#ff0000" },
  DiagnosticWarn = { fg = "#ffa500" },
  DiagnosticInfo = { fg = "#add8e6" },
  DiagnosticHint = { fg = "#d3d3d3" },
  VirtualTextError = { link = "DiagnosticError" },
  VirtualTextWarning = { link = "DiagnosticWarn" },
  VirtualTextInfo = { link = "DiagnosticInfo" },
  VirtualTextHint = { link = "DiagnosticHint" },
  ErrorFloat = { fg = colors.bright_red },
  WarningFloat = { fg = colors.bright_yellow },
  InfoFloat = { fg = colors.bright_blue },
  HintFloat = { fg = colors.bright_green },
  RedSign = { fg = colors.bright_red },
  LspReferenceText = { link = "CurrentWord" },
  LspReferenceRead = { link = "CurrentWord" },
  LspReferenceWrite = { link = "CurrentWord" },
  Underlined = { underline = true },
  Comment = { fg = "#928374" },
  Aqua = { fg = colors.bright_cyan },
  Red = { fg = colors.bright_red },
  Green = { fg = colors.bright_green },
  VimOption = {},
  ToolbarButton = { fg = "#1d2021" },
  StatusLineTermNC = { fg = "#928374" },
  GPGHighlightUnknownRecipient = { link = "ErrorMsg" },
  GPGError = { link = "ErrorMsg" },
  GPGWarning = { link = "WarningMsg" },
  MarkdownOrderedListMarker = {},
  MarkdownListMarker = {},
  MarkdownCodeBlock = {},
  MarkdownCodeDelimiter = {},
  MarkdownCode = {},
  MarkdownLinkTextDelimiter = {},
  MarkdownLinkDelimiter = {},
  MarkdownLinkText = {},
  MarkdownUrl = {},
  MarkdownItalicDelimiter = {},
  MarkdownItalic = {},
  Italic = {},
  debugPC = { bg = "#324232" },
  Type = { fg = colors.bright_yellow },
  vCursor = { link = "Cursor" },
  iCursor = { link = "Cursor" },
  CursorIM = { link = "Cursor" },
  VisualNOS = { bg = "#3c3836" },
  debugBreakpoint = { fg = "#1d2021", bg = colors.bright_red },
  ["@markup.emphasis"] = { fg = colors.cyan, italic = true },
  ["@markup.heading"] = { link = "Title" },
  ["@markup.link"] = { fg = colors.yellow, bold = true },
  ["@markup.link.uri"] = { fg = colors.magenta, italic = true },
  ["@markup.list"] = { fg = colors.cyan },
  ["@markup.raw"] = { fg = colors.green },
  ["@markup.strong"] = { fg = colors.red, bold = true },
  ["@markup.underline"] = { link = "Underlined" },
  ["@variable.member"] = { link = "Identifier" },
  ["@lsp.mod.defaultLibrary"] = { link = "Special" },
  ["@lsp.mod.global"] = { link = "Constant" },
  ["@lsp.typemod.property"] = { link = "Identifier" },
  ["@lsp.typemod.member"] = { link = "Identifier" },
  ["@lsp.typemod.function"] = { link = "Function" },
  ["@tag"] = { fg = colors.red },
  ["@tag.attribute"] = { fg = colors.yellow },
  ["@tag.delimiter"] = { fg = colors.black },
  TreesitterContextBottom = { underline = true, special = "#928374" },
  TreesitterContextLineNumberBottom = { link = "TreesitterContextBottom" },
}
for k, v in pairs(theme) do
  vim.api.nvim_set_hl(0, k, v)
end

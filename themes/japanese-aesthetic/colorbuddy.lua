local colorbuddy = require("colorbuddy")
colorbuddy.colorscheme("active-theme")

local colors = require("skypex.colors")
local Color = colorbuddy.Color
local Group = colorbuddy.Group
local c = colorbuddy.colors
local g = colorbuddy.groups
local s = colorbuddy.styles

Color.new("primary", colors.primary)
Color.new("secondary", colors.secondary)
Color.new("tertiary", colors.tertiary)
Color.new("quaternary", colors.quaternary)
Color.new("red", colors.red)
Color.new("pink", colors.pink)
Color.new("green", colors.green)
Color.new("yellow", colors.yellow)
Color.new("blue", colors.blue)
Color.new("cyan", colors.cyan)
Color.new("purple", colors.purple)
Color.new("orange", colors.orange)

Color.new("hint", colors.info)
Color.new("info", colors.info)
Color.new("warning", colors.warning)
Color.new("error", colors.error)

local bg = colors.none
Color.new("background0", colors.background0)
Color.new("background1", colors.background1)
Color.new("background2", colors.background2)
Color.new("background3", colors.background3)

Group.new("Splash", c.yellow)

Group.new("Normal", c.primary, bg)
Group.new("InvNormal", c.tertiary, bg)
Group.new("NormalFloat", c.primary)
Group.new("FloatBorder", c.secondary)

Group.new("LineNr", c.secondary, c.none)
Group.new("EndOfBuffer", c.secondary, nil)
Group.new("SignColumn", nil, c.none)
Group.new("VertSplit", g.FloatBorder, g.FloatBorder)

Group.new("ErrorMsg", c.red)
Group.new("WarningMsg", c.orange)
Group.new("MoreMsg", c.cyan)

-- Cursor
Group.new("Cursor", c.primary)
Group.new("CursorColumn", nil, c.background0)
Group.new("CursorLine", nil, c.none)
Group.new("CursorLineNr", c.primary, c.background0)

-- Files
Group.new("Directory", c.primary)

-- Search
Group.new("Search", c.background0, c.blue)
Group.new("IncSearch", c.background0, c.orange)

-- Visual
Group.new("Visual", nil, c.background2)
Group.new("VisualMode", g.Visual, g.Visual)
Group.new("VisualLineMode", g.Visual, g.Visual)

-- Popup Menu
Group.new("Title", c.primary)
Group.new("Pmenu", c.primary, c.background0)
Group.new("PmenuSel", c.primary, c.background1)
Group.new("PmenuSbar", nil, c.background0)
Group.new("PmenuThumb", nil, c.background1)

-- TabLine
Group.new("TabLine", c.secondary, c.background1)
Group.new("TabLineFill", nil, c.background1)
Group.new("TabLineSel", c.primary, nil)

-- StatusLine
-- Disabled due to: https://github.com/vim/vim/issues/13366#issuecomment-1790617530
-- Group.new("StatusLine", c.mono_3, c.mono_2)
-- Group.new("StatusLineNC", c.mono_3, c.mono_2)

-- Standard Syntax
Group.new("Boolean", c.red)
Group.new("Character", c.secondary)
Group.new("Comment", c.quaternary, nil)
Group.new("Conceal", c.secondary)
Group.new("Constant", c.cyan)
Group.new("Error", c.pink)
Group.new("Folded", c.background2, c.background1)
Group.new("Function", c.yellow)
Group.new("Identifier", c.cyan)
Group.new("Label", c.background2)
Group.new("MatchParen", c.primary, nil)
Group.new("NonText", c.background0, nil)
Group.new("Number", c.orange)
Group.new("PreProc", c.yellow)
Group.new("Question", c.primary, c.background1)
Group.new("Special", c.cyan, nil)
Group.new("SpecialKey", c.pink, nil)
Group.new("SpellBad", c.pink)
Group.new("SpellCap", c.primary)
Group.new("SpellLocal", c.background2)
Group.new("SpellRare", c.pink)
Group.new("Statement", c.purple)
Group.new("Todo", c.pink)
Group.new("Type", c.purple)

-- Treesitter Syntax Highlighting
-- See :help treesitter-highlight-groups
Group.new("@boolean", c.red)
Group.new("@character", c.red)
Group.new("@character.special", c.red)
Group.new("@comment", c.quaternary, nil)
Group.new("@conditional", c.purple, nil)
Group.new("@constant", c.red)
Group.new("@constant.builtin", c.red)
Group.new("@constant.macro", c.cyan)
Group.new("@constructor", c.yellow)
Group.new("@debug", c.pink)
Group.new("@define", c.purple, nil)
Group.new("@exception", c.purple)
Group.new("@field", c.cyan)
Group.new("@float", c.orange)
Group.new("@function", c.yellow)
Group.new("@function.builtin", c.yellow)
Group.new("@function.call", c.yellow)
Group.new("@function.macro", c.yellow)
Group.new("@include", c.purple, nil)
Group.new("@keyword", c.purple, nil)
Group.new("@keyword.function", c.purple, nil)
Group.new("@keyword.operator", c.red, nil)
Group.new("@keyword.return", c.purple, nil)
Group.new("@label", c.cyan)
Group.new("@macro", c.pink)
Group.new("@method", c.yellow)
Group.new("@method.call", c.yellow)
Group.new("@namespace", c.blue)
Group.new("@none", c.red)
Group.new("@module", c.pink)
Group.new("@number", c.orange)
Group.new("@operator", c.red, nil)
Group.new("@parameter", c.cyan)
Group.new("@preproc", c.secondary, nil)
Group.new("@property", c.pink)
Group.new("@punctuation", c.primary)
Group.new("@punctuation.bracket", c.yellow)
Group.new("@punctuation.delimiter", c.primary)
Group.new("@punctuation.special", c.red)
Group.new("@repeat", c.purple, nil)
Group.new("@storageclass", c.purple)
Group.new("@string", c.green)
Group.new("@string.escape", c.green)
Group.new("@string.special", c.red)
Group.new("@string.regexp", c.blue)
Group.new("@structure", c.cyan)
Group.new("@tag", c.pink)
Group.new("@tag.attribute", c.pink)
Group.new("@tag.delimiter", c.pink)
Group.new("@text.literal", c.green)
Group.new("@text.reference", c.red)
Group.new("@text.title", c.pink)
Group.new("@text.todo", c.pink)
Group.new("@text.underline", c.green)
Group.new("@text.uri", c.purple)
Group.new("@type", c.yellow)
Group.new("@identifier", c.yellow)
Group.new("@type.builtin", c.purple)
Group.new("@type.definition", c.yellow)
Group.new("@variable", c.cyan)
Group.new("@variable.builtin", c.pink)

-- Semantic Highlighting
Group.new("DiagnosticError", c.error)
Group.new("DiagnosticHint", c.hint)
Group.new("DiagnosticInfo", c.info)
Group.new("DiagnosticWarn", c.warning)
Group.new("DiagnosticSignError", c.error)
Group.new("DiagnosticSignHint", c.hint)
Group.new("DiagnosticSignInfo", c.info)
Group.new("DiagnosticSignWarn", c.warning)

-- Lsp
Group.new("LspInlayHint", c.secondary)
Group.new("LspCodeLens", g.NonText, g.NonText)
Group.new("LspCodeLensSeparator", g.LspCodeLens, g.LspCodeLens)
Group.new("LspReferenceRead", nil, c.background0)
Group.new("LspReferenceText", g.Visual, g.Visual)
Group.new("LspReferenceWrite", g.LspReferenceRead, g.LspReferenceRead)
Group.new("LspReferenceTarget", g.LspReferenceText, g.LspReferenceText)
Group.new("LspSignatureActiveParameter", g.Visual, g.Visual)

-- Git
Group.new("DiffAdd", c.green)
Group.new("DiffChange", c.cyan)
Group.new("DiffDelete", c.red)
Group.new("SignifySignAdd", g.DiffAdd)
Group.new("SignifySignChange", g.DiffChange)
Group.new("SignifySignDelete", g.DiffDelete)

Group.new("DiffText", c.tertiary, c.primary)
Group.new("GitBlameMsg", g.DiffText, g.DiffText)
Group.new("GitSignsCurrentLineBlame", c.orange, bg)
Group.new("gitsignscurrentlineblame", c.orange, bg)

Group.new("GitSignsAdd", g.DiffAdd, g.DiffAdd)
Group.new("GitSignsChange", g.DiffChange, g.DiffChange)
Group.new("GitSignsDelete", g.DiffDelete, g.DiffDelete)
Group.new("GitSignsChangedelete", g.DiffDelete, g.DiffDelete)
Group.new("GitSignsTopdelete", g.DiffDelete, g.DiffDelete)

Group.new("GitSignsAddNr", g.DiffAdd, g.DiffAdd)
Group.new("GitSignsChangeNr", g.DiffChange, g.DiffChange)
Group.new("GitSignsDeleteNr", g.DiffDelete, g.DiffDelete)
Group.new("GitSignsChangedeleteNr", g.DiffDelete, g.DiffDelete)
Group.new("GitSignsTopdeleteNr", g.DiffDelete, g.DiffDelete)

Group.new("GitSignsAddLn", g.DiffAdd, g.DiffAdd)
Group.new("GitSignsChangeLn", g.DiffChange, g.DiffChange)
Group.new("GitSignsDeleteLn", g.DiffDelete, g.DiffDelete)

Group.new("GitSignsStagedAdd", g.GitSignsAdd, g.GitSignsAdd)
Group.new("GitSignsStagedChange", g.GitSignsChange, g.GitSignsChange)
Group.new("GitSignsStagedDelete", g.GitSignsDelete, g.GitSignsDelete)
Group.new("GitSignsStagedChangedelete", g.GitSignsChangedelete, g.GitSignsChangedelete)
Group.new("GitSignsStagedTopdelete", g.GitSignsTopdelete, g.GitSignsTopdelete)

Group.new("GitSignsStagedAddNr", g.GitSignsAddNr, g.GitSignsAddNr)
Group.new("GitSignsStagedChangeNr", g.GitSignsChangeNr, g.GitSignsChangeNr)
Group.new("GitSignsStagedDeleteNr", g.GitSignsDeleteNr, g.GitSignsDeleteNr)
Group.new("GitSignsStagedChangedeleteNr", g.GitSignsChangedeleteNr, g.GitSignsChangedeleteNr)
Group.new("GitSignsStagedTopdeleteNr", g.GitSignsTopdeleteNr, g.GitSignsTopdeleteNr)

Group.new("GitSignsStagedAddLn", g.GitSignsAddLn, g.GitSignsAddLn)
Group.new("GitSignsStagedChangeLn", g.GitSignsChangeLn, g.GitSignsChangeLn)
Group.new("GitSignsStagedDeleteLn", g.GitSignsDeleteLn, g.GitSignsDeleteLn)

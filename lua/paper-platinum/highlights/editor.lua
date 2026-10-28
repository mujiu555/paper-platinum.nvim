return function(c, o)
  local transparent = require("paper-platinum.util").transparent
  local bg = transparent(o, "editor") and "NONE" or c.bg
  local float = transparent(o, "floats") and "NONE" or (o.ui.float_style == "plain" and c.bg or c.bg_float)
  local popup = transparent(o, "popups") and "NONE" or c.bg_popup
  local border = o.ui.relief == "classic" and c.border_highlight or c.border
  if not o.ui.borders then border = float end
  local h = {
    Normal = { fg = c.fg, bg = bg }, NormalNC = { fg = c.fg, bg = bg },
    NormalFloat = { fg = c.fg, bg = float },
    Cursor = { fg = c.cursor_fg, bg = c.cursor_bg }, CursorLine = { bg = c.cursorline },
    CursorColumn = { bg = c.cursorline }, ColorColumn = { bg = c.bg_alt },
    CursorLineNr = { fg = c.blue, bold = true }, LineNr = { fg = c.fg_muted, bg = bg },
    SignColumn = { fg = c.fg_muted, bg = bg }, FoldColumn = { fg = c.fg_muted, bg = bg },
    Folded = { fg = c.fg_alt, bg = c.bg_alt }, Visual = { bg = c.bg_visual },
    Search = { fg = c.fg, bg = c.search }, IncSearch = { fg = c.selection_fg, bg = c.selection, bold = true },
    MatchParen = { fg = c.blue, bg = c.bg_highlight, bold = true, underline = true },
    StatusLine = { fg = c.fg, bg = c.bg_statusline, bold = o.ui.relief == "classic" },
    StatusLineNC = { fg = c.fg_muted, bg = c.bg_alt },
    WinSeparator = { fg = o.ui.borders and c.border or c.bg_alt, bg = bg },
    TabLine = { fg = c.fg_muted, bg = c.bg_alt }, TabLineFill = { bg = c.bg_alt },
    TabLineSel = { fg = c.blue, bg = c.bg, bold = true },
    Pmenu = { fg = c.fg, bg = popup },
    PmenuSel = { fg = c.selection_fg, bg = c.selection, bold = true },
    PmenuSbar = { bg = transparent(o, "popups") and "NONE" or c.bg_highlight },
    PmenuThumb = { bg = transparent(o, "popups") and "NONE" or c.border_shadow },
    PmenuKind = { fg = c.type, bg = popup }, PmenuExtra = { fg = c.fg_muted, bg = popup },
    PmenuMatch = { fg = c.blue, bold = true, underline = true },
    PmenuMatchSel = { fg = c.selection_fg, bold = true, underline = true },
    FloatBorder = { fg = border, bg = float }, FloatTitle = { fg = c.blue, bg = float, bold = true },
    FloatFooter = { fg = c.fg_muted, bg = float },
    PaperBorderLight = { fg = o.ui.borders and (o.ui.relief == "flat" and c.border or c.border_highlight) or float, bg = float },
    PaperBorderShadow = { fg = o.ui.borders and (o.ui.relief == "classic" and c.border_shadow or c.border) or float, bg = float },
    Directory = { fg = c.blue }, Title = { fg = c.blue, bold = true },
    NonText = { fg = c.fg_disabled }, EndOfBuffer = { fg = c.fg_disabled, bg = bg },
    Whitespace = { fg = c.border }, SpecialKey = { fg = c.fg_disabled }, Conceal = { fg = c.fg_muted },
    Question = { fg = c.success, bold = true }, MoreMsg = { fg = c.info }, ModeMsg = { fg = c.fg_alt, bold = true },
    WarningMsg = { fg = c.warning, bold = true }, ErrorMsg = { fg = c.error, bold = true },
    DiffAdd = { bg = c.diff_add }, DiffChange = { bg = c.diff_change },
    DiffDelete = { fg = c.brick, bg = c.diff_delete }, DiffText = { bg = c.diff_text, bold = true },
    Added = { fg = c.success }, Changed = { fg = c.info }, Removed = { fg = c.error },
    SpellBad = { sp = c.error, undercurl = true }, SpellCap = { sp = c.warning, undercurl = true },
    SpellLocal = { sp = c.info, underline = true }, SpellRare = { sp = c.hint, underdotted = true },
    QuickFixLine = { bg = c.bg_visual, bold = true },
    Bold = { bold = true }, Italic = { italic = true },
    WinBar = { fg = c.fg_alt, bg = bg }, WinBarNC = { fg = c.fg_muted, bg = bg },
    FloatShadow = { bg = transparent(o, "floats") and "NONE" or c.border_shadow, blend = 65 },
    FloatShadowThrough = { bg = transparent(o, "floats") and "NONE" or c.border_shadow, blend = 85 },
  }
  local link = require("paper-platinum.util").links
  link(h, "lCursor CursorIM TermCursor", "Cursor")
  link(h, "LineNrAbove LineNrBelow", "LineNr")
  link(h, "CursorLineFold CursorLineSign", "CursorLine")
  link(h, "VisualNOS", "Visual"); link(h, "CurSearch", "IncSearch")
  link(h, "Substitute", "IncSearch"); link(h, "ComplMatchIns", "PmenuMatch")
  link(h, "VertSplit", "WinSeparator"); link(h, "WildMenu PmenuKindSel PmenuExtraSel", "PmenuSel")
  link(h, "MsgArea", "Normal"); link(h, "MsgSeparator", "WinSeparator")
  link(h, "SnippetTabstop", "Visual")
  link(h, "StatusLineTerm", "StatusLine"); link(h, "StatusLineTermNC", "StatusLineNC")
  if vim.fn.has("nvim-0.12") == 1 then
    h.PmenuBorder = { fg = border, bg = popup }
    h.PmenuShadow = { bg = transparent(o, "popups") and "NONE" or c.border_shadow, blend = 65 }
    h.PmenuShadowThrough = { bg = transparent(o, "popups") and "NONE" or c.border_shadow, blend = 85 }
    link(h, "DiffTextAdd", "DiffText")
    link(h, "OkMsg", "DiagnosticOk"); link(h, "StderrMsg", "ErrorMsg")
    link(h, "StdoutMsg", "Normal"); link(h, "PreInsert ComplHint ComplHintMore", "Comment")
    link(h, "SnippetTabstopActive", "Visual")
  end
  return h
end

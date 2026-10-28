-- Public highlight names; provenance and support scope: doc/SOURCES.md.
return function(c, o)
  local sidebar_bg = require("paper-platinum.util").transparent(o, "sidebars") and "NONE" or c.bg
  return {
    NeoTreeNormal = { fg = c.fg, bg = sidebar_bg },
    NeoTreeNormalNC = { fg = c.fg, bg = sidebar_bg },
    NeoTreeFloatNormal = { link = "NormalFloat" },
    NeoTreeFloatBorder = { link = "FloatBorder" },
    NeoTreeFloatTitle = { link = "FloatTitle" },
    NeoTreeDirectoryName = { link = "Directory" },
    NeoTreeDirectoryIcon = { link = "Directory" },
    NeoTreeRootName = { link = "Title" },
    NeoTreeFileName = { fg = c.fg },
    NeoTreeGitAdded = { link = "Added" },
    NeoTreeGitDeleted = { link = "Removed" },
    NeoTreeGitModified = { link = "Changed" },
    NeoTreeGitConflict = { link = "DiagnosticWarn" },
    NeoTreeGitIgnored = { link = "Comment" },
    NeoTreeIndentMarker = { link = "NonText" },
    NeoTreeCursorLine = { link = "CursorLine" },
    NeoTreeWinSeparator = { link = "WinSeparator" },
    NeoTreeTitleBar = { fg = c.fg_alt, bg = sidebar_bg },
    NeoTreeSignColumn = { fg = c.fg_muted, bg = sidebar_bg },
    NeoTreeEndOfBuffer = { link = "EndOfBuffer" },
    NeoTreeStatusLine = { fg = c.fg_muted, bg = sidebar_bg },
    NeoTreeStatusLineNC = { fg = c.fg_muted, bg = sidebar_bg },
    NeoTreeDimText = { link = "Comment" },
  }
end

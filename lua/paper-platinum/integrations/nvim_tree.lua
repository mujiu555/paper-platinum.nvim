-- Public highlight names; provenance and support scope: doc/SOURCES.md.
return function(c, o)
  local sidebar_bg = require("paper-platinum.util").transparent(o, "sidebars") and "NONE" or c.bg
  return {
    NvimTreeNormal = { fg = c.fg, bg = sidebar_bg },
    NvimTreeNormalNC = { fg = c.fg, bg = sidebar_bg },
    NvimTreeNormalFloat = { link = "NormalFloat" },
    NvimTreeWinSeparator = { link = "WinSeparator" },
    NvimTreeCursorLine = { link = "CursorLine" },
    NvimTreeFolderName = { link = "Directory" },
    NvimTreeOpenedFolderName = { link = "Directory" },
    NvimTreeEmptyFolderName = { link = "Comment" },
    NvimTreeFolderIcon = { link = "Directory" },
    NvimTreeRootFolder = { link = "Title" },
    NvimTreeGitDirty = { link = "Changed" },
    NvimTreeGitNew = { link = "Added" },
    NvimTreeGitDeleted = { link = "Removed" },
    NvimTreeIndentMarker = { link = "NonText" },
    NvimTreeSignColumn = { fg = c.fg_muted, bg = sidebar_bg },
    NvimTreeEndOfBuffer = { link = "EndOfBuffer" },
    NvimTreeWindowPicker = { link = "IncSearch" },
  }
end

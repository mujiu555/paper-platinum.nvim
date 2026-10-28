-- Public highlight names; provenance and support scope: doc/SOURCES.md.
return function(c)
  return {
    SnacksNormal = { link = "NormalFloat" },
    SnacksNormalNC = { link = "NormalFloat" },
    SnacksTitle = { link = "FloatTitle" },
    SnacksFooter = { link = "FloatFooter" },
    SnacksWinBar = { link = "WinBar" },
    SnacksWinBarNC = { link = "WinBarNC" },
    SnacksWinSeparator = { link = "WinSeparator" },
    SnacksWinKey = { link = "Keyword" },
    SnacksWinKeySep = { link = "NonText" },
    SnacksWinKeyDesc = { link = "Function" },
    SnacksPickerMatch = { link = "PmenuMatch" },
    SnacksPickerSearch = { link = "Search" },
    SnacksPickerPrompt = { link = "Function" },
    SnacksPickerDirectory = { link = "Directory" },
    SnacksPickerDir = { link = "Comment" },
    SnacksPickerSelected = { link = "Special" },
    SnacksPickerTree = { link = "NonText" },
    SnacksDashboardHeader = { link = "Title" },
    SnacksDashboardDesc = { fg = c.fg },
    SnacksDashboardKey = { link = "Function" },
    SnacksDashboardFooter = { link = "Comment" },
  }
end

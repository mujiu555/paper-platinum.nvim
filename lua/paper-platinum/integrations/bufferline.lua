-- Public highlight names; provenance and support scope: doc/SOURCES.md.
return function(c)
  return {
    BufferLineFill = { link = "TabLineFill" },
    BufferLineBackground = { link = "TabLine" },
    BufferLineBufferSelected = { link = "TabLineSel" },
    BufferLineBufferVisible = { link = "TabLine" },
    BufferLineTab = { link = "TabLine" },
    BufferLineTabSelected = { link = "TabLineSel" },
    BufferLineTabClose = { link = "TabLine" },
    BufferLineCloseButton = { link = "TabLine" },
    BufferLineCloseButtonVisible = { link = "TabLine" },
    BufferLineCloseButtonSelected = { link = "TabLineSel" },
    BufferLineSeparator = { link = "WinSeparator" },
    BufferLineSeparatorVisible = { link = "WinSeparator" },
    BufferLineSeparatorSelected = { link = "WinSeparator" },
    BufferLineIndicatorSelected = { link = "Function" },
    BufferLineModified = { link = "Constant" },
    BufferLineModifiedVisible = { link = "Constant" },
    BufferLineModifiedSelected = { link = "Constant" },
    BufferLineError = { link = "DiagnosticError" },
    BufferLineWarning = { link = "DiagnosticWarn" },
  }
end

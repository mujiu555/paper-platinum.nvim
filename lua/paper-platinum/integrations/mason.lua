-- Public highlight names; provenance and support scope: doc/SOURCES.md.
return function(c)
  return {
    MasonNormal = { link = "NormalFloat" },
    MasonHeader = { link = "PmenuSel" },
    MasonHeaderSecondary = { link = "StatusLine" },
    MasonHighlight = { link = "Function" },
    MasonHighlightBlock = { link = "PmenuSel" },
    MasonHighlightBlockBold = { link = "PmenuSel" },
    MasonHighlightSecondary = { link = "Constant" },
    MasonHighlightBlockSecondary = { link = "StatusLine" },
    MasonHighlightBlockBoldSecondary = { link = "StatusLine" },
    MasonMuted = { link = "Comment" },
    MasonMutedBlock = { link = "TabLine" },
    MasonMutedBlockBold = { link = "TabLine" },
    MasonError = { link = "ErrorMsg" },
    MasonWarning = { link = "WarningMsg" },
    MasonHeading = { link = "Title" },
  }
end

-- Public highlight names; provenance and support scope: doc/SOURCES.md.
return function(c)
  return {
    DiffviewNormal = { link = "Normal" },
    DiffviewWinSeparator = { link = "WinSeparator" },
    DiffviewFilePanelTitle = { link = "Title" },
    DiffviewFilePanelCounter = { link = "Number" },
    DiffviewFilePanelFileName = { fg = c.fg },
    DiffviewFilePanelRootPath = { link = "Title" },
    DiffviewFilePanelSelected = { link = "Visual" },
    DiffviewFilePanelPath = { link = "Comment" },
    DiffviewFilePanelInsertions = { link = "Added" },
    DiffviewFilePanelDeletions = { link = "Removed" },
    DiffviewFilePanelConflicts = { link = "DiagnosticWarn" },
    DiffviewStatusAdded = { link = "Added" },
    DiffviewStatusModified = { link = "Changed" },
    DiffviewStatusDeleted = { link = "Removed" },
    DiffviewDiffDelete = { link = "DiffDelete" },
  }
end

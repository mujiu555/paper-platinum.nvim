-- Public highlight names; provenance and support scope: doc/SOURCES.md.
return function(c)
  return {
    GitSignsAdd = { link = "Added" },
    GitSignsChange = { link = "Changed" },
    GitSignsDelete = { link = "Removed" },
    GitSignsChangedelete = { link = "DiagnosticWarn" },
    GitSignsTopdelete = { link = "Removed" },
    GitSignsUntracked = { link = "Added" },
    GitSignsAddLn = { link = "DiffAdd" },
    GitSignsChangeLn = { link = "DiffChange" },
    GitSignsDeletePreview = { link = "DiffDelete" },
    GitSignsAddPreview = { link = "DiffAdd" },
    GitSignsAddInline = { link = "DiffAdd" },
    GitSignsChangeInline = { link = "DiffText" },
    GitSignsDeleteInline = { link = "DiffDelete" },
    GitSignsCurrentLineBlame = { link = "Comment" },
  }
end

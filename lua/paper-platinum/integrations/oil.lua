-- Public highlight names; provenance and support scope: doc/SOURCES.md.
return function(c)
  return {
    OilDir = { link = "Directory" },
    OilDirIcon = { link = "Directory" },
    OilFile = { fg = c.fg },
    OilHidden = { link = "Comment" },
    OilSocket = { link = "Special" },
    OilLink = { link = "Type" },
    OilOrphanLink = { link = "DiagnosticError" },
    OilCreate = { link = "Added" },
    OilDelete = { link = "Removed" },
    OilMove = { link = "Changed" },
    OilCopy = { link = "Added" },
    OilChange = { link = "Changed" },
    OilPurge = { link = "Removed" },
    OilRestore = { link = "Added" },
  }
end

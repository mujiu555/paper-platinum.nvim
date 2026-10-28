return function(c)
  local h = {
    LspReferenceText = { bg = c.bg_highlight }, LspReferenceRead = { bg = c.bg_highlight, underline = true },
    LspReferenceWrite = { bg = c.bg_highlight, bold = true, underline = true },
    LspReferenceTarget = { bg = c.bg_visual },
    LspInlayHint = { fg = c.fg_muted, bg = c.bg_alt }, LspCodeLens = { fg = c.fg_muted },
    LspCodeLensSeparator = { fg = c.border }, LspSignatureActiveParameter = { bg = c.bg_visual, bold = true },
  }
  -- Broad server classifications must not erase finer Tree-sitter captures.
  for _, name in ipairs({ "variable", "string", "comment", "keyword", "operator", "number", "regexp" }) do
    h["@lsp.type." .. name] = {}
  end
  local types = {
    class = "Type", enum = "Type", struct = "Type", type = "Type", typeParameter = "Type",
    interface = "PaperInterface", namespace = "PaperNamespace", parameter = "PaperParameter",
    property = "PaperProperty", enumMember = "Constant", event = "Special", decorator = "Special",
    ["function"] = "Function", method = "PaperMethod", macro = "Macro", modifier = "Keyword",
  }
  for name, target in pairs(types) do h["@lsp.type." .. name] = { link = target } end
  for _, mod in ipairs({ "abstract", "async", "declaration", "defaultLibrary", "definition", "documentation", "modification", "readonly", "static" }) do
    h["@lsp.mod." .. mod] = {}
  end
  h["@lsp.mod.deprecated"] = { strikethrough = true }
  for _, name in ipairs({ "variable", "property", "parameter" }) do
    h["@lsp.typemod." .. name .. ".readonly"] = { underline = true }
  end
  h["@lsp.typemod.function.async"] = { italic = true }
  h["@lsp.typemod.method.async"] = { italic = true }
  return h
end

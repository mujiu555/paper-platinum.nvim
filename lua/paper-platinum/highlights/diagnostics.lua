return function(c, o)
  local h = {}
  for name, key in pairs({ Error = "error", Warn = "warning", Info = "info", Hint = "hint", Ok = "success" }) do
    h["Diagnostic" .. name] = { fg = c[key] }
    h["DiagnosticSign" .. name] = { fg = c[key], bold = name == "Error" }
    -- Vivid errors/warnings also reach virtual prose, without colored backgrounds.
    local virtual_fg = o.vivid and (name == "Error" or name == "Warn") and c[key] or c.fg_muted
    h["DiagnosticVirtualText" .. name] = { fg = virtual_fg, sp = c[key], underline = name == "Error" }
    h["DiagnosticVirtualLines" .. name] = { fg = virtual_fg, sp = c[key], underline = name == "Error" }
    h["DiagnosticFloating" .. name] = { fg = c[key] }
    h["DiagnosticUnderline" .. name] = { sp = c[key], undercurl = name == "Error" or name == "Warn", underline = name == "Info", underdotted = name == "Hint" or name == "Ok" }
  end
  h.DiagnosticDeprecated = { strikethrough = true, sp = c.deprecated }
  h.DiagnosticUnnecessary = { fg = c.fg_muted }
  return h
end

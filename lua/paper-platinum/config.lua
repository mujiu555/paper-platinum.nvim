local M = {}
M.defaults = {
  style = "dark", transparent = false, vivid = false, terminal_colors = true,
  ui = { relief = "subtle", contrast = "normal", borders = true, float_style = "platinum" },
  styles = { comments = { italic = true }, keywords = { bold = false }, functions = {}, variables = {} },
  integrations = {
    treesitter = true, lsp = true, diagnostics = true, cmp = true, blink = true,
    telescope = true, fzf = true, nvim_tree = true, neo_tree = true, oil = true,
    gitsigns = true, diffview = true, which_key = true, lazy = true, mason = true,
    trouble = true, noice = true, notify = true, ibl = true, mini = true,
    snacks = true, flash = true, leap = true, render_markdown = true, bufferline = true,
  },
}
local current = vim.deepcopy(M.defaults)
local function choice(value, values, name)
  assert(vim.tbl_contains(values, value), "paper-platinum: invalid " .. name)
end
function M.resolve(opts)
  assert(opts == nil or type(opts) == "table", "paper-platinum: options must be a table")
  for key, value in pairs(opts or {}) do
    assert(M.defaults[key] ~= nil or key == "on_colors" or key == "on_highlights", "paper-platinum: unknown option " .. key)
    if type(M.defaults[key]) == "table" then
      assert(type(value) == "table", "paper-platinum: " .. key .. " must be a table")
      for subkey in pairs(value) do
        assert(M.defaults[key][subkey] ~= nil, "paper-platinum: unknown option " .. key .. "." .. subkey)
      end
    end
  end
  local c = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
  choice(c.style, { "light", "dark" }, "style")
  choice(c.ui.relief, { "flat", "subtle", "classic" }, "ui.relief")
  choice(c.ui.contrast, { "low", "normal", "reading", "high" }, "ui.contrast")
  choice(c.ui.float_style, { "platinum", "plain" }, "ui.float_style")
  for _, k in ipairs({ "transparent", "vivid", "terminal_colors" }) do
    if k ~= "transparent" then assert(type(c[k]) == "boolean", "paper-platinum: " .. k .. " must be boolean") end
  end
  if type(c.transparent) == "table" then
    for key, value in pairs(c.transparent) do
      assert(({ editor = true, floats = true, sidebars = true, popups = true })[key], "paper-platinum: unknown transparent option " .. key)
      assert(type(value) == "boolean", "paper-platinum: transparent." .. key .. " must be boolean")
    end
  else
    assert(type(c.transparent) == "boolean", "paper-platinum: transparent must be a boolean or table")
  end
  assert(type(c.ui.borders) == "boolean", "paper-platinum: ui.borders must be boolean")
  for key, value in pairs(c.styles) do
    assert(type(value) == "table", "paper-platinum: styles." .. key .. " must be a highlight table")
  end
  for k, v in pairs(c.integrations) do
    assert(M.defaults.integrations[k] ~= nil, "paper-platinum: unknown integration " .. k)
    assert(type(v) == "boolean", "paper-platinum: integration " .. k .. " must be boolean")
  end
  for _, k in ipairs({ "on_colors", "on_highlights" }) do
    assert(c[k] == nil or type(c[k]) == "function", "paper-platinum: " .. k .. " must be a function")
  end
  return c
end
function M.setup(opts) current = M.resolve(opts) end
function M.get() return vim.deepcopy(current) end
return M

local count = 0
local function check(value, message)
  assert(value, message)
  count = count + 1
end
local function eq(a, b, message) check(vim.deep_equal(a, b), message .. ': ' .. vim.inspect(a)) end
local function hl(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
local function rgb(s) return tonumber(s:sub(2), 16) end
local function luminance(hex)
  local value = 0
  for i, weight in ipairs({ 0.2126, 0.7152, 0.0722 }) do
    local channel = tonumber(hex:sub(i * 2, i * 2 + 1), 16) / 255
    value = value + weight * (channel <= 0.04045 and channel / 12.92 or ((channel + 0.055) / 1.055) ^ 2.4)
  end
  return value
end
local function contrast(a, b)
  a, b = luminance(a), luminance(b)
  return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05)
end
local function run()
  vim.opt.rtp:prepend(vim.fn.getcwd())
  local theme = require('paper-platinum')
  local ac = #vim.api.nvim_get_autocmds({})
  local core = [[Normal NormalNC NormalFloat Comment Constant String Character Number Boolean Identifier Function Statement Conditional Repeat Label Operator Keyword Exception PreProc Include Define Macro Type StorageClass Structure Typedef Special Delimiter Todo Error Cursor CursorLine CursorColumn CursorLineNr LineNr SignColumn FoldColumn Folded Visual VisualNOS Search IncSearch CurSearch MatchParen ColorColumn StatusLine StatusLineNC WinSeparator VertSplit TabLine TabLineSel TabLineFill Pmenu PmenuSel PmenuSbar PmenuThumb FloatBorder FloatTitle FloatFooter Directory Title NonText EndOfBuffer Whitespace SpecialKey Conceal Question MoreMsg WarningMsg ErrorMsg DiffAdd DiffChange DiffDelete DiffText]]
  for _, style in ipairs({ 'light', 'dark' }) do
    for _, transparent in ipairs({ false, true }) do
      for _, relief in ipairs({ 'flat', 'subtle', 'classic' }) do
        theme.setup({ style = style, transparent = transparent, ui = { relief = relief } })
        vim.cmd.colorscheme('paper-platinum')
        local c = theme.colors()
        eq(vim.g.colors_name, 'paper-platinum', 'colors_name')
        eq(vim.o.background, style, 'background')
        check(vim.o.termguicolors, 'true color enabled')
        eq(hl('Normal').bg, not transparent and rgb(c.bg) or nil, 'Normal transparency')
        eq(hl('SignColumn').bg, not transparent and rgb(c.bg) or nil, 'gutter transparency')
        eq(hl('Normal').fg, rgb(c.fg), 'stable foreground')
        eq(hl('NormalFloat').bg, rgb(c.bg_float), 'opaque float')
        eq(hl('Pmenu').bg, rgb(c.bg_popup), 'opaque completion')
        check(hl('Visual').bg ~= hl('CursorLine').bg, 'selection distinct from current line')
        check(hl('Search').bg ~= hl('DiffDelete').bg, 'search distinct from errors')
        for group in core:gmatch('%S+') do check(not vim.tbl_isempty(hl(group)), 'missing ' .. group) end
        for _, group in ipairs({ '@function.method', '@variable.parameter', '@markup.heading', 'LspInlayHint', 'DiagnosticFloatingError', 'DiagnosticSignWarn', 'DiagnosticVirtualLinesHint' }) do
          check(not vim.tbl_isempty(hl(group)), 'modern group: ' .. group)
        end
        eq(hl('@lsp.type.variable'), {}, 'broad LSP tokens preserve Tree-sitter')
        eq(hl('@lsp.type.function'), hl('Function'), 'LSP matches syntax')
        check(hl('@lsp.mod.deprecated').strikethrough and not hl('@lsp.mod.deprecated').fg, 'modifier is additive')
        eq(hl('DiagnosticVirtualTextError').fg, rgb(c.fg_muted), 'virtual text subdued')
        check(hl('DiagnosticUnderlineError').undercurl, 'error has a shape cue')
        for i = 0, 15 do eq(vim.g['terminal_color_' .. i], c.terminal[i + 1], 'ANSI palette') end
        local before = hl('Normal')
        vim.cmd.colorscheme('paper-platinum')
        eq(hl('Normal'), before, 'repeatable load')
      end
    end
    theme.load({ style = style })
    local c = theme.colors()
    for _, key in ipairs({ 'fg', 'comment', 'keyword', 'function', 'type', 'string', 'constant', 'parameter', 'property', 'error', 'warning', 'info', 'hint' }) do
      check(contrast(c[key], c.bg) >= 4.5, style .. ' contrast below 4.5: ' .. key)
    end
    check(contrast(c.fg, c.bg_float) >= 7, 'float text contrast')
    check(contrast(c.selection_fg, c.selection) >= 4.5, 'menu selection contrast')
    print(string.format('%s contrast: text %.2f, comments %.2f, strings %.2f', style, contrast(c.fg, c.bg), contrast(c.comment, c.bg), contrast(c.string, c.bg)))
  end
  eq(#vim.api.nvim_get_autocmds({}), ac, 'no theme autocmds')
  local all, colors = theme.highlights()
  for name, spec in pairs(all) do
    if spec.link then
      check(not vim.tbl_isempty(hl(spec.link)), name .. ' has unresolved link ' .. spec.link)
    end
  end
  local copy = theme.colors()
  copy.fg = '#123456'
  eq(theme.colors().fg, colors.fg, 'palette queries return independent copies')
  vim.o.winblend, vim.o.pumblend = 12, 18
  theme.load({})
  eq({ vim.o.winblend, vim.o.pumblend }, { 12, 18 }, 'blend options unchanged')
  vim.o.winblend, vim.o.pumblend = 0, 0
  for _, relief in ipairs({ 'flat', 'subtle', 'classic' }) do
    theme.load({ ui = { relief = relief } })
    local border = theme.border()
    eq(#border, 8, 'eight-part border')
    if relief == 'flat' then eq(border[1][2], border[4][2], 'flat border uniform')
    else check(hl(border[1][2]).fg ~= hl(border[4][2]).fg, 'directional relief colors') end
  end
  local before_error = hl('Normal')
  theme.setup({ on_colors = function() error('intentional callback failure') end })
  check(not pcall(theme.load), 'callback errors surfaced')
  eq(hl('Normal'), before_error, 'callback failure does not erase active theme')
  theme.load({ on_colors = function(c) c.string = '#526d43' end,
    on_highlights = function(h) h.Normal = { fg = '#abcdef', bg = '#123456', bold = true }; h.PaperTestCustom = { italic = true } end })
  eq(hl('String').fg, rgb('#526d43'), 'palette callback applied before mapping')
  eq(hl('Normal').fg, rgb('#abcdef'), 'final highlight callback')
  check(hl('Normal').bold, 'custom attribute')
  theme.load({ styles = { comments = { italic = false } } })
  check(not hl('Normal').bold and not hl('Comment').italic, 'stale attributes cleared')
  eq(hl('PaperTestCustom'), {}, 'stale custom groups cleared')
  vim.g.terminal_color_0 = '#123abc'
  theme.load({ terminal_colors = false })
  eq(vim.g.terminal_color_0, '#123abc', 'terminal colors opt out')
  theme.load({ ui = { borders = false, float_style = 'plain', contrast = 'high' } })
  eq(theme.border(), 'none', 'border opt out')
  eq(hl('FloatBorder').fg, hl('NormalFloat').bg, 'hidden border coloring')
  eq(hl('NormalFloat').bg, hl('Normal').bg, 'plain float')
  for _, style in ipairs({ 'light', 'dark' }) do
    for _, transparent in ipairs({ false, true }) do
      for _, ui_contrast in ipairs({ 'normal', 'high' }) do
        local opts = { style = style, transparent = transparent, ui = { contrast = ui_contrast } }
        theme.load(opts)
        local base, normal = theme.colors(), hl('Normal')
        opts.vivid = true
        theme.load(opts)
        eq(hl('Normal'), normal, 'vivid preserves surface and text contrast')
        eq(hl('String').fg, rgb(base.string), 'vivid preserves syntax palette')
        eq(theme.colors().terminal, base.terminal, 'vivid preserves ANSI palette')
        local accents = style == 'light'
          and { Error = '#c02636', Warn = '#8c5e00' }
          or { Error = '#f7768e', Warn = '#e0af68' }
        for name, color in pairs(accents) do
          for _, prefix in ipairs({ 'Diagnostic', 'DiagnosticSign', 'DiagnosticVirtualText', 'DiagnosticVirtualLines', 'DiagnosticFloating' }) do
            eq(hl(prefix .. name).fg, rgb(color), 'vivid ' .. prefix .. name)
          end
          eq(hl('DiagnosticUnderline' .. name).sp, rgb(color), 'vivid underline')
          for _, surface in ipairs({ 'bg', 'bg_float', 'cursorline' }) do
            check(contrast(color, base[surface]) >= 4.5, style .. ' vivid ' .. name .. ' contrast on ' .. surface)
          end
        end
        eq(hl('DiagnosticVirtualTextHint').fg, rgb(base.fg_muted), 'hints stay muted')
        eq(hl('NotifyERRORIcon').fg, rgb(accents.Error), 'plugin inherits vivid error')
        eq(hl('WarningMsg').fg, rgb(accents.Warn), 'editor inherits vivid warning')
        opts.vivid = false
        theme.load(opts)
        eq(hl('DiagnosticError').fg, rgb(base.error), 'vivid off restores palette')
        eq(hl('DiagnosticVirtualTextWarn').fg, rgb(base.fg_muted), 'vivid off restores virtual text')
      end
    end
  end
  theme.load({ vivid = true, on_colors = function(c) c.error = '#aa3344' end,
    on_highlights = function(h) h.DiagnosticWarn = { fg = '#bb8844' } end })
  eq(hl('DiagnosticVirtualTextError').fg, rgb('#aa3344'), 'palette override wins over vivid preset')
  eq(hl('DiagnosticWarn').fg, rgb('#bb8844'), 'highlight override wins over vivid preset')
  check(not pcall(theme.setup, { vivid = 'yes' }), 'vivid requires a boolean')
  local disabled = {}
  for name in pairs(require('paper-platinum.config').defaults.integrations) do disabled[name] = false end
  theme.load({ integrations = disabled })
  eq(hl('TelescopeNormal'), {}, 'disabled integration reset')
  check(not pcall(theme.setup, { style = 'unknown' }), 'invalid style rejected')
  check(not pcall(theme.setup, { integrations = { typo = true } }), 'invalid integration rejected')
  check(not pcall(theme.setup, { ui = { typo = true } }), 'invalid UI option rejected')
  check(not pcall(theme.setup, { styles = { comments = false } }), 'invalid style table rejected')
  theme.load({})
  -- Real parser and query, no third-party plugin required for the core suite.
  local b = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(b)
  vim.api.nvim_buf_set_lines(b, 0, -1, false, { 'local answer = 42', 'print("paper") -- readable' })
  vim.bo[b].filetype = 'lua'
  local parser = vim.treesitter.get_parser(b, 'lua')
  local tree = parser:parse()[1]
  local query = assert(vim.treesitter.query.get('lua', 'highlights'))
  local captures = 0
  for id in query:iter_captures(tree:root(), b) do
    local name = '@' .. query.captures[id]
    check(vim.fn.hlexists(name) == 1, 'real query capture resolves: ' .. name)
    captures = captures + 1
  end
  check(captures > 5, 'real Tree-sitter captures')
  vim.treesitter.start(b, 'lua')
  local ns = vim.api.nvim_create_namespace('paper-platinum-test')
  vim.diagnostic.set(ns, b, { { lnum = 0, col = 6, message = 'E: sample error', severity = vim.diagnostic.severity.ERROR } },
    { virtual_text = true, signs = true, underline = true })
  check(#vim.diagnostic.get(b) == 1, 'diagnostic API rendering')
  local float_buf, win = vim.diagnostic.open_float(b, { scope = 'buffer', border = theme.border() })
  check(float_buf and vim.api.nvim_win_is_valid(win), 'diagnostic float works with relief border')
  vim.api.nvim_win_close(win, true)
  vim.diagnostic.reset(ns)
  package.loaded['lualine.themes.paper-platinum'] = nil
  local line = require('lualine.themes.paper-platinum')
  check(line.normal.a.bg == theme.colors().selection, 'lualine export')
  vim.cmd.colorscheme('default')
  theme.load({ style = 'light' })
  check(not hl('Normal').reverse, 'switch from another theme')
  print('PASS: ' .. count .. ' assertions; Neovim ' .. tostring(vim.version()))
end
local ok, err = xpcall(run, debug.traceback)
if not ok then vim.api.nvim_err_writeln(err); vim.cmd('cquit 1') else vim.cmd('qa!') end

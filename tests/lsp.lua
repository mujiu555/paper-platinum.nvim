local function run()
  vim.opt.rtp:prepend(vim.fn.getcwd())
  local theme = require('paper-platinum')
  for _, style in ipairs({ 'light', 'dark' }) do
    theme.load({ style = style })
    local b = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(b)
    vim.api.nvim_buf_set_name(b, '/tmp/paper-lsp-' .. style .. '.lua')
    vim.api.nvim_buf_set_lines(b, 0, -1, false, { 'local answer = 42' })
    vim.bo[b].filetype = 'lua'
    vim.treesitter.start(b, 'lua')
    local id = assert(vim.lsp.start({ name = 'paper-fixture', cmd = { 'node', vim.fn.getcwd() .. '/tests/mock-lsp.js' }, root_dir = vim.fn.getcwd() }))
    assert(vim.wait(5000, function() local c = vim.lsp.get_client_by_id(id); return c and c.initialized end), 'LSP initialize timed out')
    vim.lsp.inlay_hint.enable(true, { bufnr = b })
    assert(vim.wait(5000, function() return #vim.lsp.inlay_hint.get({ bufnr = b }) > 0 end), 'inlay hint not applied')
    assert(vim.wait(5000, function() return #(vim.lsp.semantic_tokens.get_at_pos(b, 0, 6) or {}) > 0 end), 'semantic token not applied')
    assert(vim.wait(5000, function() return #vim.diagnostic.get(b) > 0 end), 'published diagnostic not rendered')
    local token = vim.lsp.semantic_tokens.get_at_pos(b, 0, 6)[1]
    assert(token.type == 'variable' and token.modifiers.readonly, 'token legend mismatch')
    assert(vim.api.nvim_get_hl(0, { name = '@lsp.type.variable' }).fg == nil, 'generic token overwrites syntax')
    vim.lsp.get_client_by_id(id):stop(true)
    vim.wait(2000, function() return vim.lsp.get_client_by_id(id) == nil end)
    vim.api.nvim_buf_delete(b, { force = true })
    print('PASS: ' .. style .. ' real LSP transport, semantic tokens, inlay hints, diagnostics')
  end
end
local ok, err = xpcall(run, debug.traceback)
if not ok then vim.api.nvim_err_writeln(err); vim.cmd('cquit 1') else vim.cmd('qa!') end

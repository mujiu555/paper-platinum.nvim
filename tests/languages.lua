local function run()
  vim.opt.rtp:prepend(vim.fn.getcwd())
  if vim.env.PAPER_QUERIES then vim.opt.rtp:append(vim.env.PAPER_QUERIES) end
  local theme = require('paper-platinum')
  local languages = { rs = 'rust', c = 'c', cpp = 'cpp', lua = 'lua', py = 'python', sh = 'bash', md = 'markdown', json = 'json', yaml = 'yaml', diff = 'diff' }
  local passed, skipped = 0, 0
  for _, style in ipairs({ 'light', 'dark' }) do
    theme.load({ style = style })
    for ext, lang in pairs(languages) do
      local b = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(b, 0, -1, false, vim.fn.readfile('tests/fixtures/example.' .. ext))
      local ok, parser = pcall(vim.treesitter.get_parser, b, lang)
      local query = ok and vim.treesitter.query.get(lang, 'highlights')
      if not ok or not query then
        print('SKIP ' .. style .. '/' .. lang .. ': parser or query unavailable')
        skipped = skipped + 1
      else
        local n = 0
        for id in query:iter_captures(parser:parse()[1]:root(), b) do
          local capture = '@' .. query.captures[id]
          -- Dotted captures inherit their nearest ancestor in Neovim.
          while capture ~= '' and vim.fn.hlexists(capture) == 0 do capture = capture:match('^(.*)%.[^.]+$') or '' end
          assert(capture ~= '', 'unresolved capture ' .. query.captures[id] .. ' in ' .. lang)
          n = n + 1
        end
        assert(n > 0, 'empty query result for ' .. lang)
        vim.treesitter.start(b, lang)
        passed = passed + 1
        print('PASS ' .. style .. '/' .. lang .. ': ' .. n .. ' captures')
      end
      vim.api.nvim_buf_delete(b, { force = true })
    end
  end
  print(string.format('Language cases: %d passed, %d skipped', passed, skipped))
end
local ok, err = xpcall(run, debug.traceback)
if not ok then vim.api.nvim_err_writeln(err); vim.cmd('cquit 1') else vim.cmd('qa!') end

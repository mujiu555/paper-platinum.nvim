-- Compare current low with a reference palette from before the redesign.
-- Frozen legacy palette fixture; independent of subsequent palette edits.
vim.opt.rtp:prepend(vim.fn.getcwd())
local legacy = dofile('tests/fixtures/legacy_palette.lua')
local theme = require('paper-platinum')
local config = require('paper-platinum.config')
local count=0
for _,style in ipairs({'light','dark'}) do
 for _,vivid in ipairs({false}) do
  for _,transparent in ipairs({false,true}) do
   for _,relief in ipairs({'flat','subtle','classic'}) do
    for _,float_style in ipairs({'plain','platinum'}) do
     for _,borders in ipairs({false,true}) do
      local opts=config.resolve({style=style,vivid=vivid,transparent=transparent,ui={contrast='low',relief=relief,float_style=float_style,borders=borders}})
      local old=vim.deepcopy(opts)
      old.ui.contrast='normal'
      local expected=legacy.get(old)
      local h,c=theme.highlights(opts)
      assert(vim.deep_equal(c,expected),'legacy palette mismatch')
      local groups={}
      for _,name in ipairs({'editor','syntax','treesitter','lsp','diagnostics'}) do
       groups=vim.tbl_extend('force',groups,require('paper-platinum.highlights.'..name)(expected,old))
      end
      groups=vim.tbl_extend('force',groups,require('paper-platinum.integrations').get(expected,old))
      assert(vim.deep_equal(h,groups),'legacy highlights mismatch')
      theme.load(opts)
      for name in pairs(h) do
       local resolved=vim.api.nvim_get_hl(0,{name=name,link=false})
       local target=name
       while groups[target] and groups[target].link do target=groups[target].link end
       local spec=groups[target]
       if spec and spec.fg and spec.fg:match('^#') then
        assert(resolved.fg==tonumber(spec.fg:sub(2),16),name..' resolved foreground mismatch')
       end
      end
      count=count+1
     end
    end
   end
  end
 end
end
for _,style in ipairs({'light','dark'}) do
 local low=theme.highlights({style=style,ui={contrast='low'}})
 local normal,c=theme.highlights({style=style,ui={contrast='normal'}})
 local expected=legacy.get(config.resolve({style=style,ui={contrast='high'}}))
 for _,key in ipairs({'fg','fg_muted','border','bg','bg_float','bg_popup','selection','cursor_bg'}) do
  assert(c[key]==expected[key],'normal must preserve legacy high '..key)
 end
 for _,group in ipairs({'Function','Type','String','Keyword','PaperParameter','PaperProperty'}) do
  assert(low[group].fg~=normal[group].fg,'normal needs distinct '..group)
 end
 assert(normal.PaperParameter.fg~=normal.PaperProperty.fg,'parameters and properties must differ')
 assert(normal['@variable.member'].link=='PaperProperty','Tree-sitter member mapping')
 assert(normal['@lsp.type.property'].link=='PaperProperty','LSP property mapping')
 assert(normal['@lsp.type.class'].link=='Type','LSP class mapping')
end
print('PASS: '..count..' legacy normal/low configurations, including resolved links; normal semantic enhancements checked')
vim.cmd('qa!')

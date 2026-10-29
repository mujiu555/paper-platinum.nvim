vim.opt.rtp:prepend(vim.fn.getcwd())
local theme = require('paper-platinum')
local contrast = require('paper-platinum.contrast')
local report = {'Mode | Style | Highlight | Category | Foreground | Background | Ratio | Minimum | Result'}
local checked = 0
local function run()
for _,mode in ipairs({"reading","high"}) do
 local profile = contrast.profiles[mode]
 for _,style in ipairs({'light','dark'}) do
  for _,relief in ipairs({'flat','subtle','classic'}) do
   for _,float_style in ipairs({'plain','platinum'}) do
    for _,transparent in ipairs({false,true}) do
     theme.load({style=style,transparent=transparent,ui={contrast=mode,relief=relief,float_style=float_style}})
     local h,c = theme.highlights()
     for name in pairs(h) do
      local s = vim.api.nvim_get_hl(0,{name=name,link=false})
      if s.fg then
       local fg = string.format('#%06x',s.fg)
       local backgrounds = {}
       if s.bg then backgrounds={string.format('#%06x',s.bg)}
       elseif not transparent then
        for _,key in ipairs({'bg','bg_float','bg_popup','cursorline','bg_visual','diff_add','diff_change','diff_text'}) do backgrounds[#backgrounds+1]=c[key] end
        if name == 'PmenuMatchSel' then backgrounds={c.selection} end
       end
       local category=contrast.category(name)
       -- Linked groups inherit the semantic category of their final target.
       local target=name
       while h[target] and h[target].link do target=h[target].link end
       category=contrast.category(target)
       if #backgrounds==0 then report[#report+1]=table.concat({mode,style,name,category,fg,'UNKNOWN','N/A',profile[category],'UNVERIFIABLE'},' | ') end
       for _,bg in ipairs(backgrounds) do
        local ratio=contrast.ratio(fg,bg)
        report[#report+1]=table.concat({mode,style,name,category,fg,bg,string.format('%.4f',ratio),profile[category],ratio>=profile[category] and 'PASS' or 'FAIL'},' | ')
        assert(ratio>=profile[category],report[#report])
        checked=checked+1
       end
      end
     end
    end
   end
  end
 end
end
end
local ok,err=xpcall(run,debug.traceback)
vim.fn.writefile(report,'doc/contrast-report.csv')
if not ok then print(err); vim.cmd('cquit 1') else print('PASS: '..checked..' contrast combinations'); vim.cmd('qa!') end

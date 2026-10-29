vim.opt.rtp:prepend(vim.fn.getcwd())
local theme=require('paper-platinum')
local profiles=require('paper-platinum.contrast').profiles
-- Independent WCAG sRGB reference implementation.
local luminances={}
local function lum(n)
 if luminances[n] then return luminances[n] end
 local result=0
 for i,w in ipairs({.2126,.7152,.0722}) do
  local v=math.floor(n/256^(3-i))%256/255
  result=result+w*(v<=.04045 and v/12.92 or ((v+.055)/1.055)^2.4)
 end
 luminances[n]=result
 return result
end
local function ratio(a,b) a,b=lum(a),lum(b); return (math.max(a,b)+.05)/(math.min(a,b)+.05) end
local function rgb(s) return tonumber(s:sub(2),16) end
local function hl(n) return vim.api.nvim_get_hl(0,{name=n,link=false}) end
local rows={'Mode,Style,Relief,Float,Vivid,Borders,Terminal,Transparency,Category,Minimum measured,Maximum measured,Measured,Unknown'}
local summary,objects={},{}
local configs,measured,unknown=0,0,0
local transparencies={false,true}
for bits=0,15 do
 local t={}
 for i,key in ipairs({'editor','floats','sidebars','popups'}) do t[key]=math.floor(bits/2^(i-1))%2==1 end
 transparencies[#transparencies+1]=t
end
local function run()
for _,mode in ipairs({'low','normal','reading','high'}) do
 for _,style in ipairs({'light','dark'}) do
  local key=mode..'/'..style
  summary[key]={}
  for _,relief in ipairs({'flat','subtle','classic'}) do
   for _,float in ipairs({'plain','platinum'}) do
    for _,vivid in ipairs({false,true}) do
     for _,borders in ipairs({false,true}) do
      for _,terminal in ipairs({false,true}) do
       for ti,transparent in ipairs(transparencies) do
        local opts={style=style,transparent=transparent,vivid=vivid,terminal_colors=terminal,ui={contrast=mode,relief=relief,float_style=float,borders=borders}}
        theme.load(opts)
        local h,c=theme.highlights()
        local cache={}
        local function hl(name)
         if not cache[name] then cache[name]=vim.api.nvim_get_hl(0,{name=name,link=false}) end
         return cache[name]
        end
        local stats={}
        local names=vim.tbl_keys(h); table.sort(names)
        for _,name in ipairs(names) do
         local spec=hl(name)
         if spec.fg then
          local target=name
          while h[target] and h[target].link do target=h[target].link end
          local category=require('paper-platinum.contrast').category(target)
          if category=='ui' and not borders then category='decoration' end
          if target=='Whitespace' or target=='NonText' or target=='EndOfBuffer' or target=='SpecialKey' then category='decoration' end
          local backgrounds={}
          if spec.bg then backgrounds={spec.bg}
          elseif target=='PmenuMatchSel' then backgrounds={hl('PmenuSel').bg}
          else
           -- Conservative cross-surface audit; not a claim that every plugin uses every surface.
           for _,surface in ipairs({'Normal','NormalFloat','Pmenu','CursorLine','Visual','DiffAdd','DiffChange','DiffDelete','DiffText','Search','StatusLine'}) do
            local bg=hl(surface).bg
            if bg then backgrounds[#backgrounds+1]=bg end
           end
          end
          stats[category]=stats[category] or {min=math.huge,max=0,n=0,unknown=0}
          local stat=stats[category]
          if not spec.bg and (transparent==true or type(transparent)=='table' and (transparent.editor or transparent.floats or transparent.popups or transparent.sidebars)) then
           stat.unknown=stat.unknown+1; unknown=unknown+1
          end
          for _,bg in ipairs(backgrounds) do
           local r=ratio(spec.fg,bg)
           stat.min=math.min(stat.min,r); stat.max=math.max(stat.max,r); stat.n=stat.n+1; measured=measured+1
          end
         end
        end
        for _,cat in ipairs({'text','comment','ui','decoration'}) do
         local s=stats[cat]
         if s then
          rows[#rows+1]=table.concat({mode,style,relief,float,tostring(vivid),tostring(borders),tostring(terminal),ti,cat,string.format('%.4f',s.min),string.format('%.4f',s.max),s.n,s.unknown},',')
          local total=summary[key][cat] or {min=math.huge,max=0}
          total.min=math.min(total.min,s.min); total.max=math.max(total.max,s.max); summary[key][cat]=total
         end
        end
        configs=configs+1
       end
      end
     end
    end
   end
  end
  theme.load({style=style,ui={contrast=mode}})
  objects[key]={}
  for _,name in ipairs({'Normal','@variable','@variable.parameter','@variable.member','@type','@function','@keyword','@string','@comment','@lsp.type.class','@lsp.type.property','@lsp.type.parameter','@lsp.type.function'}) do
   local spec=hl(name)
   objects[key][name]=string.format('#%06x / %.2f',spec.fg,ratio(spec.fg,hl('Normal').bg))
  end
  assert(not hl('@lsp.type.variable').fg,'broad LSP variable must preserve Tree-sitter')
 end
end
local out={'## Contrast measurements / 对比度实测','',string.format('Executed %d configurations; %d known-background comparisons; %d unknown-background observations (UNVERIFIABLE).',configs,measured,unknown),'',
'WCAG sRGB linearization. Matrix: 4 modes × 2 styles × 3 reliefs × 2 float styles × vivid on/off × borders on/off × terminal colors on/off × 18 transparency settings (false, true, all 16 surface masks). Default integrations enabled; callbacks and custom styles excluded. winblend/pumblend = 0.','',
'Foreground links are resolved by Neovim. Inherited foregrounds are conservatively compared against editor, float, menu, cursorline, visual, diff, search and status surfaces; these ranges are a stress audit, not proof of every plugin rendering combination. Transparent unknown surfaces are never certified. Disabled borders and decorative whitespace are excluded from UI minima. Low/normal are measured, not threshold-certified.','',
'| Mode | Style | Text range | Comments range | UI range |','| --- | --- | ---: | ---: | ---: |'}
for _,mode in ipairs({'low','normal','reading','high'}) do for _,style in ipairs({'light','dark'}) do
 local s=summary[mode..'/'..style]; local values={mode,style}
 for _,cat in ipairs({'text','comment','ui'}) do values[#values+1]=string.format('%.2f–%.2f',s[cat].min,s[cat].max) end
 out[#out+1]='| '..table.concat(values,' | ')..' |'
end end
out[#out+1]=''; out[#out+1]='### Semantic objects: low → normal / 语义对象对照'
out[#out+1]=''; out[#out+1]='Default opaque editor background. Each cell: foreground / contrast ratio. LSP generic variable/string/comment tokens stay additive and inherit Tree-sitter; they must not overwrite finer captures.'
out[#out+1]=''; out[#out+1]='| Highlight | Light low | Light normal | Dark low | Dark normal |'; out[#out+1]='| --- | --- | --- | --- | --- |'
for _,name in ipairs({'Normal','@variable','@variable.parameter','@variable.member','@type','@function','@keyword','@string','@comment','@lsp.type.class','@lsp.type.property','@lsp.type.parameter','@lsp.type.function'}) do
 local values={name}
 for _,key in ipairs({'low/light','normal/light','low/dark','normal/dark'}) do values[#values+1]=objects[key][name] end
 assert(objects['low/light'][name]~=objects['normal/light'][name],name..' unchanged in light')
 assert(objects['low/dark'][name]~=objects['normal/dark'][name],name..' unchanged in dark')
 out[#out+1]='| '..table.concat(values,' | ')..' |'
end
out[#out+1]=''; out[#out+1]='Full per-configuration category ranges: [contrast-matrix.csv](doc/contrast-matrix.csv). Reproduce: `nvim --headless -i NONE -u NONE -l tests/contrast_matrix.lua`.'
for _,file in ipairs({'README.md','README.cn.md'}) do
 local content=table.concat(vim.fn.readfile(file),'\n')
 content=content:gsub('\n<!%-%- contrast%-matrix:start %-%->.-<!%-%- contrast%-matrix:end %-%->','')
 content=content..'\n\n<!-- contrast-matrix:start -->\n'..table.concat(out,'\n')..'\n<!-- contrast-matrix:end -->'
 vim.fn.writefile(vim.split(content,'\n',{plain=true}),file)
end
vim.fn.writefile(rows,'doc/contrast-matrix.csv')
print(string.format('PASS matrix: %d configurations, %d measurements, %d unknown',configs,measured,unknown))
end
local ok,err=xpcall(run,debug.traceback)
if not ok then print(err); vim.cmd('cquit 1') else vim.cmd('qa!') end

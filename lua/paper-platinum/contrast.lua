local M = {}
M.profiles = {
  low = { legacy = true },
  normal = { legacy = true },
  reading = { text = 10, vivid_text = 4.5, ui = 5, comment = 4 },
  high = { text = 4.5, body = 14, ui = 8, comment = 6 },
}
local function channels(c)
  return { tonumber(c:sub(2,3),16), tonumber(c:sub(4,5),16), tonumber(c:sub(6,7),16) }
end
function M.luminance(c)
  local sum = 0
  for i, v in ipairs(channels(c)) do
    v = v / 255
    sum = sum + ({.2126,.7152,.0722})[i] * (v <= .04045 and v / 12.92 or ((v+.055)/1.055)^2.4)
  end
  return sum
end
function M.ratio(a,b)
  a,b = M.luminance(a),M.luminance(b)
  return (math.max(a,b)+.05)/(math.min(a,b)+.05)
end
local function mix(a,b,t)
  a,b = channels(a),channels(b)
  return string.format('#%02x%02x%02x', unpack(vim.tbl_map(function(i) return math.floor(a[i]+(b[i]-a[i])*t+.5) end,{1,2,3})))
end
function M.fit(color, backgrounds, minimum, endpoint, preserve_chroma)
  local function passes(c)
    for _, bg in ipairs(backgrounds) do if M.ratio(c,bg) < minimum then return false end end
    return true
  end
  if passes(color) then return color end
  assert(passes(endpoint), 'contrast: infeasible surface')
  local function candidate(t)
    if not preserve_chroma then return mix(color,endpoint,t) end
    -- Translate channels together instead of washing their differences into neutral ink.
    -- Clipping only reduces chroma at the gamut boundary; no saturation multiplier.
    local direction = endpoint == "#ffffff" and 1 or -1
    local rgb = channels(color)
    for i,v in ipairs(rgb) do rgb[i] = math.floor(math.max(0,math.min(255,v+direction*255*t))+.5) end
    return string.format("#%02x%02x%02x",unpack(rgb))
  end
  local lo,hi = 0,1
  for _ = 1,24 do local mid=(lo+hi)/2; if passes(candidate(mid)) then hi=mid else lo=mid end end
  return candidate(hi)
end
function M.palette(c,o)
  local p = M.profiles[o.ui.contrast]
  if o.ui.contrast == "low" then return end
  if p.legacy then
    c.fg = o.style == 'light' and '#20211d' or '#eeecdf'
    c.fg_muted = o.style == 'light' and '#53594e' or '#bac1ac'
    c.border = o.style == 'light' and '#777c72' or '#929986'
    return
  end
  local ink = o.style == 'light' and '#000000' or '#ffffff'
  local paper = o.style == 'light' and '#ffffff' or '#10110f'
  -- Reserve chromatic headroom; high contrast requires lighter paper/darker charcoal.
  for k,v in pairs(c) do
    if k:match('^bg') or k:match('^diff_') or k == 'cursorline' or k == 'search' then
      c[k] = M.fit(v,{ink},math.min(20,(p.body or p.text)*1.25),paper)
    end
  end
  c.selection = M.fit(c.selection,{paper},p.text,ink)
  c.selection_fg = M.fit(c.selection_fg,{c.selection},p.text,paper)
  c.cursor_bg, c.cursor_fg = c.selection,c.selection_fg
end
function M.category(name)
  local n = name:lower()
  if n:find('diagnostic') or n:find('error') or n:find('warning') or n:find('todo') then return 'text' end
  if n:find('comment') or n:find('inlayhint') or n:find('codelens') then return 'comment' end
  if n:find('border') or n:find('separator') then return 'ui' end
  return 'text'
end
function M.apply(h,c,o)
  if M.profiles[o.ui.contrast].legacy then return end
  local p = M.profiles[o.ui.contrast]
  local ink = o.style == 'light' and '#000000' or '#ffffff'
  local surfaces = {}
  for k,v in pairs(c) do
    if k:match('^bg') or k:match('^diff_') or k == 'cursorline' or k == 'search' then surfaces[#surfaces+1]=v end
  end
  for name,s in pairs(h) do
    if s.fg and s.fg:match('^#') and not (M.category(name)=='ui' and not o.ui.borders) then
      local backgrounds = s.bg and s.bg:match('^#') and {s.bg} or surfaces
      local endpoint = ink
      if s.bg == c.selection or s.bg == c.cursor_bg or name == 'PmenuMatchSel' then
        backgrounds = {c.selection}; endpoint = o.style == 'light' and '#ffffff' or '#000000'
      end
      local minimum = p[M.category(name)]
      -- Reading keeps its strong body text, but vivid syntax needs room for chroma.
      if o.vivid and p.vivid_text and M.category(name) == 'text'
          and name ~= 'Normal' and name ~= 'NormalNC' and name ~= 'NormalFloat' then
        minimum = p.vivid_text
      end
      if p.body and (name == 'Normal' or name == 'NormalNC' or name == 'NormalFloat' or (name == 'Identifier' and not o.vivid)) then
        minimum = p.body
        backgrounds = surfaces
      end
      s.fg = M.fit(s.fg,backgrounds,minimum,endpoint,o.ui.contrast == "high" or o.vivid)
    end
  end
end
return M


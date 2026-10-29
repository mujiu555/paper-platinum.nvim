-- Semantic accents inspired by VS Code's Dark/Light High Contrast themes.
-- Keep separate light/dark inks; these are adaptations, not a copied theme.
local palettes = {
  dark = {
    keyword='#ff85ef', ['function']='#fff06a', method='#ffd095',
    type='#40edc5', interface='#91ffc8', namespace='#a9a1ff',
    variable='#9cdcfe', parameter='#ffb879', property='#60e4ff',
    string='#ff9c72', number='#b5f58b', boolean='#65aaff', constant='#ffa5df',
    operator='#e8a3ff', preprocessor='#ff83bd', macro='#ffca42', attribute='#d7ba7d',
    comment='#83c875', deprecated='#c898bd',
    error='#ff6178', warning='#ffe254', info='#48d9ff', hint='#61eeb0', success='#91f06c',
    blue='#50bfff', green='#91f06c', teal='#40edc5', ochre='#ffca42', brick='#ff6178', purple='#e8a3ff',
  },
  light = {
    keyword='#a014a9', ['function']='#805300', method='#975016',
    type='#007b65', interface='#28752b', namespace='#6344ba',
    variable='#0451a5', parameter='#a34b0a', property='#00718a',
    string='#b5200d', number='#096d48', boolean='#1849c8', constant='#b12575',
    operator='#8030ad', preprocessor='#ac2862', macro='#926000', attribute='#795820',
    comment='#34722d', deprecated='#925071',
    error='#ce183b', warning='#986400', info='#006cae', hint='#00794e', success='#307824',
    blue='#0451a5', green='#307824', teal='#007b65', ochre='#926000', brick='#ce183b', purple='#8030ad',
  },
}
return function(c, opts)
  for key,value in pairs(palettes[opts.style]) do c[key]=value end
end

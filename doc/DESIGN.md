# Design and semantic contract

## Surfaces and hierarchy

Paper Platinum separates reading surfaces, controls, and focus states.

- `bg` is the paper or warm-charcoal reading surface. `bg_alt` supports folds, hints, and code blocks. `bg_highlight` marks local references and brackets rather than whole lines.
- `cursorline` makes a small luminance change. `bg_visual` uses grey-blue for a clearly selected region. Sand-colored `search` does not reuse error red.
- `bg_float` is a slightly greyer panel; `bg_popup` supports dense lists. `bg_statusline` forms a stable lower boundary without many saturated segments.
- `fg`, `fg_alt`, `fg_muted`, and `fg_disabled` mean body text, secondary text, readable explanations, and nonessential grid marks. Comments never use disabled text. Decorative marks and borders are exempt from the body-text contrast threshold.
- `border` is the ordinary edge; `border_highlight` and `border_shadow` provide optional directional edges. Borders distinguish objects without emphasizing every cell.
- `selection` and `selection_fg` define focused controls, including completion selection. Visual selection preserves syntax foregrounds.
- The Light block cursor uses saturated ultramarine `#003fba` with a light foreground, distinct from the grey-blue Visual selection. Its fill contrasts with the solid editor background at 7.55:1.
- Transparent mode clears supported NvimTree, Neo-tree, and Trouble sidebar surfaces in both styles. Float variants and completion menus retain solid backgrounds.
- The `transparent` option accepts `true` for editor, floats, sidebars, and popup menus, or a table with independent `editor`, `floats`, `sidebars`, and `popups` booleans. Omitted table fields stay opaque; selected completion items retain their focus color.

Light panels are slightly darker than paper, with lighter top edges. Dark panels are slightly lighter than charcoal, with deep grey shadow edges. Both are independently tuned rather than produced by channel inversion.

## Syntax and information

Purple-grey marks control flow; blue marks functions and methods; muted teal marks types, interfaces, and namespaces. Strings use grey-green, while fixed values use ochre. Functions and types have similar brightness but distinct hues. Variables retain body text, with parameters and properties one luminance step lower. Attributes and preprocessors share the annotation color; macros share the fixed-value color.

The generic deprecated group combines strikethrough and secondary text. LSP deprecated modifiers only add strikethrough so their higher priority does not erase syntax foregrounds. Selection is distinct from failure, and search is distinct from warning. LSP references use neutral backgrounds, with underline for reads and bold underline for writes.

Diagnostics use brick, ochre/sand, grey-blue, and grey-green. Default virtual text uses readable grey prose, with an additional underline for errors. Signs, prefixes, and line styles convey severity together. The example configuration supplies E/W/I/H; the theme does not force changes to diagnostic configuration.

## Native API limits

Highlights define character attributes. The theme creates no persistent windows, ongoing drawing, or true alpha. The eight-part `border()` array can provide light top/left edges and dark bottom/right edges. A uniform `FloatBorder` cannot express the same directional effect. Window creators decide whether to use borders, titles, or shadows.

`FloatShadow` blending belongs to Neovim's existing shadow mechanism. It neither changes compositor opacity nor creates a custom blurred shadow. All three relief levels use ordinary characters and RGB rather than double-layer GUI controls.

## Customization and stability

Each palette build returns a fresh copy. Semantic aliases are expanded before user callbacks, making semantic keys the intended customization interface. Full highlight definitions avoid attributes leaking from previous loads. The theme has no autocommands, wallpaper observation, background calculations, or cache invalidation machinery.

Plugins have their own lifecycles. The theme promises only the documented public mappings. Load order, forced redefinitions, private namespaces, and window-local `winhighlight` may override global highlights. New integration modules must verify upstream names and state their validation scope.

## Optional vivid accents

`vivid = true` independently enables saturated Error/Warn colors, including virtual text. It adds no syntax roles and remains independent of `transparent` and `ui.contrast`. Light uses deeper saturated red/gold; Dark uses bright red/sand-yellow. Both pairs meet 4.5:1 on their solid editor, float, and cursorline backgrounds. Transparent wallpaper composition is outside that guarantee.

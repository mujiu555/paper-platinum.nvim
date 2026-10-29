# Paper Platinum

[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)
[![conventional commit compliant](https://img.shields.io/badge/git%20commit-conventional%20commit-brightgreen.svg?style=flat-square)](https://www.conventionalcommits.org/en/v1.0.0/#specification)
[![git flow compliant](https://img.shields.io/badge/branch-git%20flow-brightgreen.svg?style=flat-square)](./doc/README.gitflow.md)

[English](README.md) | [Chinese documentation](README.cn.md)

A reading-focused, true-color Neovim theme with warm paper and charcoal surfaces,
restrained syntax colors, and Platinum-inspired window structure.
Pure Lua, with no runtime dependencies, background tasks, or theme autocommands.

Targets **Neovim 0.11+**, tested on **0.12.4**. The 0.11 documentation has been checked, but that version has not been tested at runtime. Kitty works even when Neovim reports `t_Co=256`: the theme enables `termguicolors`, and Kitty renders the RGB colors. A terminal limited to 256 palette colors has no dedicated `cterm` fallback palette.

## Background

Light and Dark palettes are independently tuned, not inverted.
The theme combines clear semantic colors with grey-scale UI surfaces, restrained borders, and focused selection states.
See [DESIGN.md](doc/DESIGN.md) for the visual and semantic contract.

| Light | Dark |
| --- | --- |
| ![Light](doc/images/light.png) | ![Dark](doc/images/dark.png) |

These are real Kitty + Neovim TUI captures using Lua/Rust Tree-sitter, native completion, and diagnostic examples. [Language galleries](doc/TESTING.md#visual-inspection) show Rust, C/C++, Lua, Python, Shell, Markdown, JSON, YAML, and Diff.

### Referencing

The implementation is independently designed. Reference themes are cited for design research and vivid semantic accents; their implementations are not included. Verified API sources and compatibility notes are in [SOURCES.md](doc/SOURCES.md).

## Install

This checkout can be used locally before the project is published. From the repository root:

```sh
mkdir -p ~/.local/share/nvim/site/pack/themes/start
ln -s "$PWD" ~/.local/share/nvim/site/pack/themes/start/paper-platinum.nvim
```

For lazy.nvim, use a local plugin spec:

```lua
{
  dir = '/absolute/path/to/paper-platinum.nvim',
  name = 'paper-platinum.nvim',
  main = 'paper-platinum',
  lazy = false,
  priority = 1000,
  opts = { style = 'light' },
  config = function(_, opts)
    require('paper-platinum').setup(opts)
    vim.cmd.colorscheme('paper-platinum')
  end,
}
```

For LazyVim, create `lua/plugins/paper-platinum.lua`:

```lua
return {
  {
    dir = '/absolute/path/to/paper-platinum.nvim',
    name = 'paper-platinum.nvim',
    main = 'paper-platinum',
    lazy = false,
    priority = 1000,
    opts = {
      style = 'light',
      transparent = false,
      vivid = false,
      ui = { contrast = 'normal', relief = 'subtle' },
    },
  },
  { 'LazyVim/LazyVim', opts = { colorscheme = 'paper-platinum' } },
  {
    'nvim-lualine/lualine.nvim',
    optional = true,
    opts = { options = { theme = 'paper-platinum' } },
  },
}
```

Keep the LazyVim colorscheme setting in one place. Restart Neovim after editing theme source files to clear Lua module caches. The local `dir` can later be replaced with the repository URL.

## Structure

```text
colors/paper-platinum.lua             :colorscheme entry point
lua/paper-platinum/palette.lua         semantic Light/Dark palettes
lua/paper-platinum/config.lua          validated public options
lua/paper-platinum/highlights/         editor, syntax, Tree-sitter, LSP, diagnostics
lua/paper-platinum/integrations/       optional plugin highlight maps
lua/lualine/themes/                    lualine theme export
examples/init.lua                      full setup example
tests/                                 headless tests, fixtures, and capture scripts
doc/                                   help, design, sources, and test records
```

Integrations only define highlight groups; they do not `require()` optional plugins. Their supported scope and limits are documented in [Plugin support](#related-efforts).

## Usage

Minimal setup:

```lua
require('paper-platinum').setup({ style = 'dark' })
vim.cmd.colorscheme('paper-platinum')
```

`:colorscheme paper-platinum` works without `setup()` and defaults to opaque Dark. It enables `termguicolors` and sets `background`. It does not change Kitty settings, `winblend`, or `pumblend`.

Light with vivid semantic colors and transparent editor background:

```lua
require('paper-platinum').setup({
  style = 'light',
  transparent = true,
  vivid = true,
  ui = { contrast = 'high', relief = 'subtle' },
})
vim.cmd.colorscheme('paper-platinum')
```

`setup(opts)` saves options; `:colorscheme` applies them and fires `ColorScheme`. Each call merges with defaults, not the previous call. `load(opts)` applies immediately but does not emit `ColorScheme`. Use `setup()` followed by `:colorscheme` when plugins need that event to refresh. Changing `background` does not automatically change the selected style.

### Options

```lua
require('paper-platinum').setup({
  style = 'dark',                 -- light | dark
  transparent = false,
  vivid = false,
  terminal_colors = true,
  ui = {
    relief = 'subtle',            -- flat | subtle | classic
    contrast = 'normal',          -- low | normal | reading | high
    borders = true,
    float_style = 'platinum',     -- platinum | plain
  },
  styles = {
    comments = { italic = true },
    keywords = { bold = false },
    functions = {},
    variables = {},
  },
  integrations = {
    treesitter = true, lsp = true, diagnostics = true,
    cmp = true, blink = true, telescope = true, fzf = true,
    nvim_tree = true, neo_tree = true, oil = true,
    gitsigns = true, diffview = true, which_key = true,
    lazy = true, mason = true, trouble = true, noice = true,
    notify = true, ibl = true, mini = true, snacks = true,
    flash = true, leap = true, render_markdown = true, bufferline = true,
  },
  -- on_colors = function(colors) end,
  -- on_highlights = function(highlights, colors) end,
})
```

`vivid = true` enables a full chromatic semantic palette: variables, parameters, properties, functions, methods, types, interfaces, namespaces, strings, numbers, booleans, comments and every diagnostic severity. It applies to all contrast modes. `vivid = false` preserves the existing mode palette. Custom color callbacks still run last.

`ui.contrast = 'high'` deepens body text and comments and strengthens borders independently of `vivid`. See [all options, color semantics, transparency, float borders, LSP priorities, and plugin support](README.cn.md) for the full reference in Chinese, or inspect the source-linked English notes in [DESIGN.md](doc/DESIGN.md), [SOURCES.md](doc/SOURCES.md), and [TESTING.md](doc/TESTING.md).

The Light block cursor uses vivid ultramarine (`#003fba`) with a light foreground, at 7.55:1 against the solid editor background. Contrast ratios have a maximum of 21:1, so 30–40:1 is not attainable with this metric.

For user highlight changes, `on_colors(colors)` runs before mappings and `on_highlights(highlights, colors)` runs last. Example:

```lua
require('paper-platinum').setup({
  on_colors = function(c) c.string = '#526d43' end,
  on_highlights = function(h, c)
    h.CursorLineNr = { fg = c.ochre, bold = true }
  end,
})
vim.cmd.colorscheme('paper-platinum')
```

Transparency is controlled by one option. `transparent = true` clears editor, float, sidebar, and popup menu surfaces; a table selects areas independently. `transparent = false` keeps every theme surface opaque:

```lua
require('paper-platinum').setup({
  style = 'light',
  transparent = {
    editor = true,
    floats = true,
    sidebars = true,
    popups = false,
  },
})
```

Table fields omitted or set to `false` remain opaque. The editor includes ordinary gutters; `sidebars` covers NvimTree, Neo-tree, and Trouble; `floats` covers `NormalFloat` and float borders; `popups` covers the completion menu and its border. Selected completion items keep their focus color. Kitty opacity, Neovim blending, and RGB backgrounds are separate mechanisms. The theme does not edit Kitty configuration.

For actual hover/diagnostic borders, pass `require('paper-platinum').border()` to the window API. Color highlights cannot add borders to windows by themselves. lualine has a separate theme interface: `require('lualine').setup({ options = { theme = 'paper-platinum' } })`.

### Options

The complete option reference and sample configuration are in [examples/init.lua](examples/init.lua) and [doc/paper-platinum.txt](doc/paper-platinum.txt).

## Plans

- Run the test suite on Neovim 0.11 in CI.
- Add interactive regression checks for the most widely used plugin windows.
- Recheck transparent composition against Kitty opacity and varied wallpapers.

Current completed checks and explicit limits are listed in [TESTING.md](doc/TESTING.md). The current environment verifies Neovim 0.12.4, not a 0.11 runtime.

## Related Efforts

| Integration | Supported highlight scope |
| --- | --- |
| nvim-cmp, blink.cmp | Menus, matches, kinds, documentation and signature windows |
| Telescope, fzf-lua | Main and preview windows, borders, titles, matches, selection |
| nvim-tree, neo-tree, Oil | Files, directories, Git states, selection |
| gitsigns, diffview | Git markers and diff panels |
| which-key, lazy.nvim, Mason, Trouble | Hints, management panels, diagnostic lists |
| Noice, nvim-notify | Command lines, messages and notifications |
| ibl, mini.nvim, Snacks.nvim | Indent guides and common UI modules |
| flash.nvim, Leap, render-markdown.nvim | Navigation and Markdown groups |
| bufferline.nvim, lualine.nvim | Bufferline groups and lualine theme export |

Mappings target verified public groups. Missing plugins do not cause errors. Plugin layouts, icon providers, external fzf colors, and forced plugin overrides may require plugin-specific configuration. See [SOURCES.md](doc/SOURCES.md) for upstream references and [TESTING.md](doc/TESTING.md) for verified behavior.

## Maintainers

[github@mujiu555](https://github.com/mujiu555)

## Contributing

You may inspect any part of the repository and open a pull request. When adding plugin groups, cite the upstream public names and include useful validation.

This repository follows [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/#specification) and the [Git Flow branch convention](doc/README.gitflow.md). The commit requirements are documented in [doc/README.commit.md](doc/README.commit.md).

## License

Apache License, Version 2.0. See [LICENSE](LICENSE).

### Contrast profiles

`ui.contrast = 'normal'` is the default visual baseline. The minimum WCAG
sRGB contrast ratios are:

| Mode | Readable text / syntax | Interactive UI | Comments |
| --- | ---: | ---: | ---: |
| low | Legacy normal palette | No enforced minimum | No enforced minimum |
| normal | Legacy high + enhanced syntax | No enforced minimum | No enforced minimum |
| reading | Body 10; vivid colored text 4.5 (otherwise 10) | 5 | 4 |
| high | Body 14; colored syntax 4.5 | 8 | 6 |

Foreground correction retains the independent light/dark palettes and blends
 toward neutral ink without increasing saturation. Surfaces may move toward
paper or charcoal to make the stronger targets possible. Readable UI text and
diagnostics use the text threshold. Custom `on_highlights` overrides run last
and can override these guarantees. Unknown transparent backgrounds and compositor
blending cannot be certified.

Run `nvim --headless -i NONE -u NONE -l tests/contrast.lua` to regenerate
`doc/contrast-report.csv`. Unknown inherited transparent backgrounds are reported
as `UNVERIFIABLE`, never as passing.

Low restores legacy normal exactly. Normal uses legacy high surfaces and prose,
with stronger syntax colors and distinct parameter/property colors. Tree-sitter
and LSP share semantic aliases. Numeric guarantees apply only to reading and high.



High prioritizes vivid semantic colors: blue functions, green strings, teal
 types/properties, purple keywords and gold numbers/parameters. It keeps 14:1 for
body text and 4.5:1 for colored text, with UI/comments at 8:1/6:1. High explicitly
opts into strong syntax color even with `vivid=false`; `vivid` selects a richer semantic palette. Light uses colored inks; dark uses luminous accents.
`tests/high_color.lua` verifies chromatic separation and body contrast.


### Full vivid semantic palette

Inspired by the official VS Code [Dark High Contrast](https://github.com/microsoft/vscode/blob/main/extensions/theme-defaults/themes/hc_black.json)
and [Light High Contrast](https://github.com/microsoft/vscode/blob/main/extensions/theme-defaults/themes/hc_light.json)
color families, adapted to Paper Platinum surfaces rather than copied exactly.
Vivid no longer preserves grayscale syntax: functions/methods use yellow/gold,
types/interfaces turquoise/green, variables/properties blue/cyan, parameters orange,
keywords magenta, strings coral, numbers green and namespaces violet. Light uses
independently tuned darker inks. All diagnostic virtual text retains severity colors.
Body/surfaces stay stable; reading/high retain their contrast correction.
`tests/vivid.lua` verifies 17 distinct resolved semantic colors across all eight
mode/style combinations, including matching Tree-sitter/LSP mappings. Generic LSP
variable tokens remain additive so they cannot erase finer Tree-sitter colors.


`reading + vivid` preserves the 10:1 body text and unchanged surfaces, while
colored text uses a 4.5:1 minimum to avoid clipping semantic colors toward black
or white. Comments/UI retain 4:1/5:1. All 17 tested semantic colors remain distinct;
Tree-sitter/LSP links share those colors. Low, normal, high and non-vivid reading
are unchanged by this adjustment.

<!-- contrast-matrix:start -->
## Contrast measurements / 对比度实测

Executed 6912 configurations; 30963072 known-background comparisons; 2875968 unknown-background observations (UNVERIFIABLE).

WCAG sRGB linearization. Matrix: 4 modes × 2 styles × 3 reliefs × 2 float styles × vivid on/off × borders on/off × terminal colors on/off × 18 transparency settings (false, true, all 16 surface masks). Default integrations enabled; callbacks and custom styles excluded. winblend/pumblend = 0.

Foreground links are resolved by Neovim. Inherited foregrounds are conservatively compared against editor, float, menu, cursorline, visual, diff, search and status surfaces; these ranges are a stress audit, not proof of every plugin rendering combination. Transparent unknown surfaces are never certified. Disabled borders and decorative whitespace are excluded from UI minima. Low/normal are measured, not threshold-certified.

| Mode | Style | Text range | Comments range | UI range |
| --- | --- | ---: | ---: | ---: |
| low | light | 1.63–12.59 | 1.63–5.09 | 1.08–3.72 |
| low | dark | 1.26–12.46 | 1.26–7.29 | 1.16–4.22 |
| normal | light | 2.04–14.09 | 2.83–6.29 | 1.08–3.72 |
| normal | dark | 1.45–12.46 | 2.24–7.87 | 1.16–4.95 |
| reading | light | 4.50–13.26 | 4.00–5.33 | 5.00–6.66 |
| reading | dark | 4.50–12.46 | 4.00–7.29 | 5.00–5.88 |
| high | light | 4.50–14.76 | 6.02–6.34 | 8.01–8.47 |
| high | dark | 4.54–15.07 | 6.05–8.81 | 8.01–8.13 |

### Semantic objects: low → normal / 语义对象对照

Default opaque editor background. Each cell: foreground / contrast ratio. LSP generic variable/string/comment tokens stay additive and inherit Tree-sitter; they must not overwrite finer captures.

| Highlight | Light low | Light normal | Dark low | Dark normal |
| --- | --- | --- | --- | --- |
| Normal | #292a25 / 12.59 | #20211d / 14.09 | #dedbcf / 10.53 | #eeecdf / 12.31 |
| @variable | #292a25 / 12.59 | #20211d / 14.09 | #dedbcf / 10.53 | #eeecdf / 12.31 |
| @variable.parameter | #42443d / 8.60 | #79582f / 5.62 | #c0c1b4 / 8.02 | #d0ba91 / 7.73 |
| @variable.member | #42443d / 8.60 | #32616d / 5.96 | #c0c1b4 / 8.02 | #91c7cf / 7.84 |
| @type | #366762 / 5.58 | #17685f / 5.74 | #9ebfb3 / 7.34 | #86cebb / 8.04 |
| @function | #315d78 / 6.16 | #235c86 / 6.20 | #a4bdcc / 7.46 | #98c6e5 / 8.03 |
| @keyword | #70566f / 5.62 | #794b80 / 5.84 | #c2aac1 / 6.82 | #d0a4d5 / 6.92 |
| @string | #4b6547 / 5.62 | #38652e / 5.95 | #b1c19a / 7.62 | #b0cd8c / 8.31 |
| @comment | #696c63 / 4.66 | #53594e / 6.29 | #a2a797 / 5.92 | #bac1ac / 7.87 |
| @lsp.type.class | #366762 / 5.58 | #17685f / 5.74 | #9ebfb3 / 7.34 | #86cebb / 8.04 |
| @lsp.type.property | #42443d / 8.60 | #32616d / 5.96 | #c0c1b4 / 8.02 | #91c7cf / 7.84 |
| @lsp.type.parameter | #42443d / 8.60 | #79582f / 5.62 | #c0c1b4 / 8.02 | #d0ba91 / 7.73 |
| @lsp.type.function | #315d78 / 6.16 | #235c86 / 6.20 | #a4bdcc / 7.46 | #98c6e5 / 8.03 |

Full per-configuration category ranges: [contrast-matrix.csv](doc/contrast-matrix.csv). Reproduce: `nvim --headless -i NONE -u NONE -l tests/contrast_matrix.lua`.
<!-- contrast-matrix:end -->

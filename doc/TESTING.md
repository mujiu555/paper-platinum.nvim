# Verification record

Date: 2026-10-28. Environment: Linux/Nix, Neovim 0.12.4 with LuaJIT, Kitty 0.49.1.

## Completed checks

| Check | Result and scope |
| --- | --- |
| `tests/run.lua` | **2,150 assertions PASS** in real headless Neovim, not just Lua syntax validation |
| Light/Dark, transparent/opaque, flat/subtle/classic | 12 combinations load and reload with expected surfaces and semantics |
| Native, Tree-sitter, LSP, diagnostic groups | Core coverage, resolved links, foregrounds/backgrounds, line styles, virtual text, inlay hint definitions |
| `:colorscheme` and theme switching | Correct colors_name/background, switching back from default, stale attributes/custom groups cleared |
| Custom callbacks | Palette before mappings, highlight overrides last, independent palette copies, callback failures preserve the active theme |
| Options | Invalid options rejected; plain floats, high contrast, border opt-out, blend preservation, ANSI opt-out |
| No third-party plugins loaded | No third-party requires; all integrations can be enabled or disabled and reloaded |
| Lua Tree-sitter | Real parser/query, captures resolved, highlighter started |
| Diagnostic API and float | `vim.diagnostic.set()`, signs, virtual text, underlines, and `open_float()` with directional borders |
| `tests/lsp.lua` | **Light + Dark PASS**: real Neovim LSP transport to a local Node fixture, applied readonly semantic tokens, inlay hints, and published diagnostics |
| `tests/languages.lua` | **20 passed, 0 skipped**: ten languages/formats in both styles with real parsers, queries, capture inheritance, and highlighter startup |
| True-color terminal | Four actual Kitty TUI captures, with `termguicolors`; not palette mockups |
| Performance | About **0.66 ms** per warm load across 50 loads with all integrations; environment-specific, not a performance guarantee |
| Documentation and scripts | `helptags doc`, Node syntax check, Bash syntax check, and `git diff --check` passed |

The default build defines **689 highlight groups**. This count identifies the current build, not its completeness. There are no persistent theme autocommands, timers, or rendering jobs.

The LSP fixture validates transport and Neovim behavior, not full rust-analyzer, clangd, or pyright compatibility. The initial sandboxed run could not receive subprocess pipe output; the same local fixture passed outside the sandbox with approval. It did not modify user LSP configuration or access external services.

Language tests used existing local parsers and nvim-treesitter/runtime queries for Rust, C, C++, Lua, Python, Bash, Markdown, JSON, YAML, and Diff. Tests do not download dependencies and explicitly report SKIP if a parser or query is missing. Markdown checks and captures cover headings, lists, and links, not every nested injection, inline node, or language extension.

## Contrast measurements

Contrast uses linearized sRGB relative luminance: `(Lmax + 0.05) / (Lmin + 0.05)`. These values compare solid theme backgrounds.

| Role | Light | Dark |
| --- | --- | --- |
| Body text | 10.61:1 | 10.53:1 |
| Comments | 4.66:1 | 5.92:1 |
| Strings | 5.62:1 | 7.62:1 |

Default body text, comments, keywords, functions, types, strings, constants, parameters, properties, and error/warning/info/hint colors meet 4.5:1 against the editor background. Float body text exceeds 7:1, and selected menu text exceeds 4.5:1. Borders, disabled text, and whitespace marks are not required to meet body-text thresholds. The ANSI palette does not promise that every color pair meets those thresholds.

## Visual inspection

- [Light editor and float](images/light.png)
- [Dark editor and float](images/dark.png)
- [Light language gallery](images/light-gallery.png)
- [Dark language gallery](images/dark-gallery.png)

Captures use a private Xvfb server and Kitty with `--config NONE` and opacity 1. They neither load user Kitty configuration nor capture the user's desktop. The main scene contains Lua/Rust, native completion, diagnostic API output, search, a Visual region, statusline, and a documentation float. Fixture text supplies documentation and completion items. The displayed inlay hint is an extmark; real LSP inlay hints are covered separately by the LSP test.

Inspection found readable comments, restrained strings, distinguishable blue functions and green types, grey virtual text with E/W/H prefixes, a cursorline weaker than selection/search, and float edges consistent with the statusline greys. The gallery checks the remaining formats against the same semantics. These are excerpts, not a manual audit of every project file, and they do not prove long-term comfort.

Reproduce the language gallery:

```sh
PAPER_SCENE=gallery PAPER_QUERIES=/path/to/nvim-treesitter/runtime bash tests/capture.sh light
PAPER_SCENE=gallery PAPER_QUERIES=/path/to/nvim-treesitter/runtime bash tests/capture.sh dark
```

## Unverified behavior and limits

1. **Neovim 0.11 runtime:** official 0.11.5 documentation was checked and version guards implemented, but only 0.12.4 was available for execution. Versions below 0.11 are unsupported.
2. **Full plugin interaction:** public names and dynamic naming rules were checked and links resolve. Not every plugin, layout, and version was started interactively. Forced redefinitions and private namespaces may override the theme.
3. **Kitty opacity 0.6 with user wallpaper:** real composition remains untested. Headless tests verify cleared backgrounds and stable foregrounds; screenshots use opaque surfaces. Solid-color contrast does not predict arbitrary wallpaper contrast.
4. **Terminal typography:** screenshot fonts support italics and line styles. Other fonts, terminals, or tmux forwarding may reduce these effects.
5. **Physical shadows and controls:** no behavior beyond TUI APIs is implemented. Directional edges require the window creator to use `border()`. There is no true per-line alpha.
6. **External fzf and UI Select/Input:** appearance depends on plugin settings and inherited native groups. Layout and subprocess colors may require plugin APIs.

Passing tests do not resolve these limits. Future maintenance should prioritize 0.11 CI and real interaction checks for major plugins over accumulating unverified group names.

## Vivid-mode regression coverage

The core suite now contains 2,150 assertions, including eight combinations of Light/Dark, transparency, and normal/high contrast. Checks cover five diagnostic foreground families, underlines, plugin inheritance, muted Info/Hint, unchanged surfaces/syntax/ANSI colors, restoration when disabled, callback precedence, and boolean validation.

An additional 48 contrast assertions verify Error/Warn at 4.5:1 or better on editor, float, and cursorline surfaces. Light editor red/yellow measure 5.12:1 and 4.92:1; Dark measures 5.52:1 and 7.30:1. These passed on Neovim 0.12.4. Existing screenshots use `vivid = false`; vivid-mode screenshots have not been added.

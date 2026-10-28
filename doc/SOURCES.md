# Research sources and compatibility boundaries

Checked on 2026-10-28 against local Neovim 0.12.4 runtime documentation and official 0.11.5 documentation. Plugin links point to public source or documentation checked at that time. Upstream main/master branches can change; abbreviated SHA-256 hashes below identify the downloaded content, not pinned commits. Unverified names are not added to mappings.

## Neovim and reference themes

- [Native highlights](https://neovim.io/doc/user/syntax/): Normal/Float/Pmenu, terminal and window roles.
- [Tree-sitter captures](https://neovim.io/doc/user/treesitter/): current @variable.parameter, @function.method, @markup names; official @property retained.
- [LSP](https://neovim.io/doc/user/lsp/): type/mod/typemod priorities, empty groups preserving underlying syntax, inlay hints and references.
- [Diagnostics](https://neovim.io/doc/user/diagnostic/): Ok and VirtualLines groups; Ok is not a standard LSP severity.
- [PaperColor](https://raw.githubusercontent.com/NLKNguyen/papercolor-theme/master/colors/PaperColor.vim): paper surfaces, text, and syntax contrast; no palette or implementation copied.
- [Desert](https://raw.githubusercontent.com/vim/vim/master/runtime/colors/desert.vim): warm grey and sand accents, without large aggressive color blocks.
- [Tokyo Night loader](https://raw.githubusercontent.com/folke/tokyonight.nvim/main/lua/tokyonight/init.lua): modular organization and configuration layers. Default colors and implementation are independent; optional vivid accents are described below.

Neovim 0.11 already includes FloatFooter, PmenuMatch/PmenuMatchSel, ComplMatchIns, LspReferenceTarget, StatusLineTerm, and SnippetTabstop. Neovim 0.12 additions such as PmenuBorder/PmenuShadow, DiffTextAdd, message and completion hints are version-guarded. VertSplit remains a compatibility link. Neovim 0.10 and traditional Vim are not supported.

## Public plugin interfaces

| Component | Source checked | Download SHA-256 (first 16 characters) |
| --- | --- | --- |
| Neovim 0.11 native groups | [Official source/docs](https://raw.githubusercontent.com/neovim/neovim/v0.11.5/runtime/doc/syntax.txt) | 54860eb8cb132b12 |
| Neovim 0.11 LSP | [Official source/docs](https://raw.githubusercontent.com/neovim/neovim/v0.11.5/runtime/doc/lsp.txt) | ab6dcfdb4949b813 |
| nvim-cmp | [Official source/docs](https://raw.githubusercontent.com/hrsh7th/nvim-cmp/main/doc/cmp.txt) | 345b60e7b8ede619 |
| blink.cmp | [Official source/docs](https://raw.githubusercontent.com/Saghen/blink.cmp/main/doc/blink-cmp.txt) | 29b777f9498a9423 |
| nvim-tree | [Official source/docs](https://raw.githubusercontent.com/nvim-tree/nvim-tree.lua/master/doc/nvim-tree-lua.txt) | 2c13ee7a7bc1f5f0 |
| neo-tree | [Official source/docs](https://raw.githubusercontent.com/nvim-neo-tree/neo-tree.nvim/main/lua/neo-tree/ui/highlights.lua) | 801aa6dacad320c4 |
| Oil | [Official source/docs](https://raw.githubusercontent.com/stevearc/oil.nvim/master/doc/oil.txt) | 8ba612634a0d75f3 |
| gitsigns | [Official source/docs](https://raw.githubusercontent.com/lewis6991/gitsigns.nvim/main/lua/gitsigns/highlight.lua) | 5348ac7eef779bfe |
| diffview | [Official source/docs](https://raw.githubusercontent.com/sindrets/diffview.nvim/main/lua/diffview/hl.lua) | 43cec1959ab499cb |
| which-key | [Official source/docs](https://raw.githubusercontent.com/folke/which-key.nvim/main/lua/which-key/colors.lua) | 01e98bd94b615014 |
| lazy | [Official source/docs](https://raw.githubusercontent.com/folke/lazy.nvim/main/lua/lazy/view/colors.lua) | e33e85705d38faf9 |
| Mason | [Official source/docs](https://raw.githubusercontent.com/mason-org/mason.nvim/main/lua/mason/ui/colors.lua) | b4f60eccdcab0e67 |
| Trouble | [Official source/docs](https://raw.githubusercontent.com/folke/trouble.nvim/main/lua/trouble/config/highlights.lua) | ed83d6eeab9f1118 |
| Noice | [Official source/docs](https://raw.githubusercontent.com/folke/noice.nvim/main/lua/noice/config/highlights.lua) | 773459fbdf4ea12c |
| Notify | [Official source/docs](https://raw.githubusercontent.com/rcarriga/nvim-notify/master/lua/notify/config/highlights.lua) | dc55fb1c41fe6103 |
| ibl | [Official source/docs](https://raw.githubusercontent.com/lukas-reineke/indent-blankline.nvim/master/lua/ibl/config.lua) | 5b2f4b9cf12b0b34 |
| mini.pick | [Official source/docs](https://raw.githubusercontent.com/nvim-mini/mini.nvim/main/doc/mini-pick.txt) | 056d8964e7f4226c |
| mini.clue | [Official source/docs](https://raw.githubusercontent.com/nvim-mini/mini.nvim/main/doc/mini-clue.txt) | c273f37df422cede |
| mini.statusline | [Official source/docs](https://raw.githubusercontent.com/nvim-mini/mini.nvim/main/doc/mini-statusline.txt) | fccd4dd5fafc5a3f |
| mini.tabline | [Official source/docs](https://raw.githubusercontent.com/nvim-mini/mini.nvim/main/doc/mini-tabline.txt) | 252776b34a4ef553 |
| Snacks windows | [Official source/docs](https://raw.githubusercontent.com/folke/snacks.nvim/main/lua/snacks/win.lua) | e16bb9ea4d6d00ca |
| Snacks dashboard | [Official source/docs](https://raw.githubusercontent.com/folke/snacks.nvim/main/lua/snacks/dashboard.lua) | df72d2d5f058925a |
| Flash | [Official source/docs](https://raw.githubusercontent.com/folke/flash.nvim/main/lua/flash/highlight.lua) | d8d234b1c30624b9 |
| Leap (current upstream) | [Official source/docs](https://codeberg.org/andyg/leap.nvim/raw/branch/main/doc/leap.txt) | cc03873bac0043c1 |
| render-markdown | [Official source/docs](https://raw.githubusercontent.com/MeanderingProgrammer/render-markdown.nvim/main/doc/render-markdown.txt) | 4af6b39708d245be |
| bufferline | [Official source/docs](https://raw.githubusercontent.com/akinsho/bufferline.nvim/main/lua/bufferline/config.lua) | ca75fef6cdd49ce7 |
| lualine | [Official source/docs](https://raw.githubusercontent.com/nvim-lualine/lualine.nvim/master/doc/lualine.txt) | 7051f0f68517f53b |

Also checked: [Telescope default groups](https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/plugin/telescope.lua), [fzf-lua defaults](https://raw.githubusercontent.com/ibhagwan/fzf-lua/main/lua/fzf-lua/defaults.lua), and [Snacks picker groups](https://raw.githubusercontent.com/folke/snacks.nvim/main/lua/snacks/picker/config/highlights.lua).

Dynamic names require care: WhichKey, Lazy, Noice, Trouble, Diffview, and Snacks prefix short table keys; bufferline converts configuration keys to BufferLineCamelCase; cmp/blink generate kinds from LSP CompletionItemKind; gitsigns generates names from change types and display positions. A literal full-name search alone cannot establish whether a group exists.

Leap moved from GitHub to Codeberg. Current documentation exposes LeapLabel and LeapMatch; older LeapBackdrop/LeapLabelPrimary/LeapLabelSecondary names are not included. ibl uses its v3 groups, without claiming full legacy IndentBlankline support. Mini and Snacks cover only the submodules listed in the README.

Name and source checks are not full interactive plugin regressions. Borders, layout, fzf subprocess ANSI settings, and icon providers remain the plugin's responsibility.

## Optional vivid diagnostic accents

At the user's request, vivid Dark uses red #f7768e and yellow #e0af68 from the [Tokyo Night Storm palette](https://raw.githubusercontent.com/folke/tokyonight.nvim/main/lua/tokyonight/colors/storm.lua). The brighter red is intentional to maintain contrast on this theme's float and cursorline surfaces; Tokyo Night itself maps error to red1 #db4b4b. Light instead uses independently adjusted saturated red #c02636 and gold #8c5e00 rather than copying dark-background RGB values.

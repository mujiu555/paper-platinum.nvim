# Paper Platinum

[English](README.md) | [中文](README.cn.md)

一套以阅读为中心的 Neovim 真彩色主题：暖纸灰与暖炭灰、克制的语法颜色、Platinum 式浮窗层次。纯 Lua，无运行时依赖、后台任务或主题 autocmd。

目标 **Neovim 0.11+**；已在 **0.12.4** 实测。0.11 官方文档已核对，尚未在该版本运行测试。即使 Neovim 报告 `t_Co=256`，Kitty 仍可使用本主题：主题会启用 `termguicolors`，由 Kitty 渲染 RGB 颜色。仅支持 256 色调色板、不支持真彩色转义的终端没有专用 `cterm` 回退调色板。

| Light | Dark |
| --- | --- |
| ![Light](doc/images/light.png) | ![Dark](doc/images/dark.png) |

以上为真实 Kitty + Neovim TUI 截图，不是渲染模型。截图使用不透明 Kitty、默认 subtle 浮雕、真实补全菜单、Lua/Rust Tree-sitter；文档浮窗和诊断内容来自可复现夹具。

## 安装

本地安装，无需等待仓库发布：

```sh
# 在本仓库目录中执行；按自己的 Neovim 数据目录调整目标路径。
mkdir -p ~/.local/share/nvim/site/pack/themes/start
ln -s "$PWD" ~/.local/share/nvim/site/pack/themes/start/paper-platinum.nvim
```

lazy.nvim 本地开发配置：

```lua
{
  dir = '/absolute/path/to/paper-platinum.nvim',
  name = 'paper-platinum.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('paper-platinum').setup({ style = 'light' })
    vim.cmd.colorscheme('paper-platinum')
  end,
}
```

仓库发布后可将 `dir` 换成实际 Git 仓库地址。本项目不假定一个尚未核实的安装 URL。

最简配置：

```lua
require('paper-platinum').setup({ style = 'dark' })
vim.cmd.colorscheme('paper-platinum')
```

不调用 `setup()` 也可直接执行 `:colorscheme paper-platinum`，默认 Dark、不透明。加载时启用 `termguicolors`，设置 `background`；不会修改光标形状、诊断行为、窗口边框选项或 Kitty 配置。

## 配置与生命周期

```lua
require('paper-platinum').setup({
  style = 'dark',                 -- light | dark
  transparent = false,
  vivid = false,                  -- 鲜艳的错误／警告强调色
  terminal_colors = true,
  ui = {
    relief = 'subtle',            -- flat | subtle | classic
    contrast = 'normal',          -- normal | high
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

所有集成默认开启，但只注册高亮，不 `require()` 第三方插件。将某项设为 `false` 会停止主题对该模块的定义；Neovim 自身或插件的默认高亮仍可能存在。lualine 由其公开主题接口单独启用：

```lua
require('lualine').setup({ options = { theme = 'paper-platinum' } })
```

`setup(opts)` **只保存配置**，每次以默认值为基准重新合并，不累积上次调用的选项。`load(opts)` 保存并立即加载；省略参数使用已保存配置。两种模式安全切换：

```lua
local paper = require('paper-platinum')
paper.setup({ style = 'light', transparent = true })
vim.cmd.colorscheme('paper-platinum') -- 正常触发 ColorScheme 事件
-- 稍后：
paper.setup({ style = 'dark', transparent = true })
vim.cmd.colorscheme('paper-platinum')
```

推荐使用 `:colorscheme`，便于第三方插件响应 `ColorScheme`。直接 `load()` 不自行触发该事件。`style` 是明确的配置来源，不根据 `:set background` 自动选择模式。缓存颜色的第三方插件可能需要刷新；lualine 如未更新，可清除 `package.loaded['lualine.themes.paper-platinum']` 后重新调用其 `setup()`。

初始化顺序：默认配置 → 配色与语义别名 → `on_colors` → 核心与可选集成高亮 → `on_highlights` → 清理旧高亮 → 统一 `nvim_set_hl()` → 可选 ANSI 调色板。重复加载不会叠加旧的 bold、italic、背景或自定义组。主题切换会正常清除此前高亮，第三方的专属 namespace 不属于主题控制范围。

## 配色语义

Light 与 Dark 分别定义，没有颜色反转。完整数据见 [palette.lua](lua/paper-platinum/palette.lua)，设计说明见 [DESIGN.md](doc/DESIGN.md)。

| 角色 | Light | Dark | 用途 |
| --- | --- | --- | --- |
| `bg` / `fg` | `#f2efe7` / `#353630` | `#292925` / `#dedbcf` | 阅读面与正文 |
| `comment` | `#696c63` | `#a2a797` | 可读的次要说明，默认斜体 |
| `function`, `method` | `#315d78` | `#a4bdcc` | 蓝色，表示可执行操作 |
| `type`, `interface`, `namespace` | `#366762` | `#9ebfb3` | 灰青绿，表示结构 |
| `string` | `#4b6547` | `#b1c19a` | 植物灰绿，文本字面量 |
| `keyword`, `attribute` | `#70566f` | `#c2aac1` | 紫灰，控制流与注解 |
| `constant`, `number`, `boolean` | `#805d28` | `#d0b47e` | 赭色，固定值 |
| `error` / `warning` | 砖红 / 深赭 | 浅砖红 / 沙金 | 异常与注意事项 |

变量使用正文色，参数和属性使用次要正文色，避免彩虹式语法。主文本对比度均超过 10:1；默认注释分别为 4.66:1 和 5.92:1（仅针对实体主题背景）。`contrast = 'high'` 加深／提亮正文、注释和边界，不增加饱和度。

需要更鲜艳的错误与警告时，开启独立的 `vivid` 开关，可与透明和高对比正文组合：

```lua
-- LazyVim 插件配置中的 opts：
opts = {
  style = 'dark',
  transparent = true,
  vivid = true,
  ui = { contrast = 'high' },
}
```

`vivid = true` 按模式选择鲜艳诊断色：Dark 使用 Tokyo Night 的亮红 `#f7768e` 和黄 `#e0af68`；Light 使用独立调深的饱和红 `#c02636` 和金黄 `#8c5e00`。作用于 Error/Warning 文本、sign、下划线、浮窗、Virtual Text/Lines 及继承这些语义的插件组。Info/Hint 保持克制。默认 `false` 保留原设计；关闭并重载即可恢复。语法、背景和 ANSI 调色板不变，`on_colors` / `on_highlights` 仍最后覆盖。

Light 和 Dark 均支持鲜艳模式，无需手动覆盖颜色。两套 Error/Warn 色在各自的实体主背景、浮窗与当前行背景上均达到 4.5:1；Light 的黄色偏深金黄，以保证浅底可读性。`ui.contrast = 'high'` 仍独立控制正文与边界。透明壁纸的最终合成对比度不能由实体色测试保证。Light 模式的块状光标使用鲜艳群青 `#003fba` 和浅色前景，与实体编辑区背景的对比度为 7.55:1。标准对比度比率最高为 21:1，因此 30–40:1 无法实现。

## 透明背景与 Kitty

```lua
require('paper-platinum').setup({ style = 'light', transparent = true })
vim.cmd.colorscheme('paper-platinum')
```

四种机制独立：

1. **Kitty `background_opacity`**：终端／合成器负责。保留用户现有的 0.6 设置，主题不读取、不写入此设置。
2. **Neovim `Normal` 的 `bg = NONE`**：继承终端背景。`transparent = true` 会清除编辑区、浮窗、侧边栏和补全菜单的背景；也可以用表格分别设置 `editor`、`floats`、`sidebars`、`popups`。表格中省略或设为 `false` 的区域保持不透明。`editor` 包括普通边栏；`sidebars` 覆盖 NvimTree、Neo-tree 和 Trouble。选中的补全项保留焦点色。Light 和 Dark 使用相同的透明选项规则，各自保留主题配色。
3. **`winblend` / `pumblend`**：Neovim 的颜色混合机制，不等同于真实 alpha。主题不修改二者；需要实体浮窗时用户可设为 0。
4. **普通 RGB 背景**：浮窗、补全、选择区、当前行仍使用实体颜色。终端的背景处理策略还会影响最终合成结果。

前景语法颜色不随透明开关改变。0.6 opacity 下壁纸会改变实际对比度，尤其是 Light 模式；无法对任意壁纸保证可读性。请使用与主题背景明度相近的终端底色，必要时提高 opacity 或关闭主题透明。当前行不提供 alpha 通道，其 RGB 色块在复杂壁纸上可能明显。

## 浮窗与浮雕

| 选项 | 实际作用 |
| --- | --- |
| `relief = 'flat'` | 单一边框色，明确分区 |
| `relief = 'subtle'` | 默认；顶部／左侧柔和高光，底部／右侧弱阴影色 |
| `relief = 'classic'` | 更强的边框高光和阴影，状态栏加粗 |
| `borders = false` | 通用边框色与浮窗底色相同，`border()` 返回 `'none'` |
| `float_style = 'plain'` | 浮窗使用主背景 RGB，仍不继承透明 |
| `float_style = 'platinum'` | 浮窗使用独立的工作站面板底色 |

颜色主题不能给任意窗口添加边框。需要对应窗口 API 接受边框数组：

```lua
local paper = require('paper-platinum')
vim.lsp.buf.hover({ border = paper.border() })
vim.lsp.buf.signature_help({ border = paper.border() })
vim.diagnostic.config({ float = { border = paper.border() } })
```

`paper.border()` 返回八个字符及其高亮组，用字符网格近似浮雕。普通单色 `FloatBorder` 也会响应 relief；只有采用此数组的窗口才有方向性高光。没有双重边框、真实立体光照或自动投影。`FloatShadow*` / 0.12 `PmenuShadow*` 仅为支持阴影的原生窗口提供颜色，不强制启用阴影。Telescope、fzf、UI Select/Input 等仍由各自插件决定结构；`borders = false` 无法移除插件自行绘制的字符。

补全／Hover／诊断浮窗共用面板、边界、标题与选中项规则。完整窗口配置示例见 [examples/init.lua](examples/init.lua)。

## LSP、诊断与语法优先级

Tree-sitter 使用现代 `@variable.parameter`、`@function.method`、`@markup.*` 等捕获。保留 `@property`，它仍是当前官方捕获。无需旧 `TS*` 高亮组。

Neovim 的 semantic token 层默认高于 Tree-sitter，modifier 和 typemod 再高一级、两级；主题不修改这些全局优先级。function、type、parameter 等 token 使用与语法相同的基础映射。宽泛的 variable、string、comment、keyword、operator、number、regexp token 设置为空，保留 Tree-sitter 的更精细捕获。deprecated 仅加删除线，readonly 仅加下划线，async 方法／函数仅加斜体，不另换一套颜色。没有 Tree-sitter 时，保留的传统 Vim 语法仍可提供底层颜色；关闭 LSP 集成后由 Neovim 默认行为接管。

诊断分别定义普通文本、sign、virtual text/lines、下划线与浮窗组，含 `DiagnosticOk`。Error 使用波浪线，Info 使用直线，Hint 使用点线；终端不支持某种线型时可能退化。Virtual Text 默认使用可读的中性灰；vivid 模式的 Error/Warn 改用诊断色，不铺彩色背景。主题无法决定诊断图标与文本，请添加 E/W/I/H 前缀与符号以保留非颜色线索，示例已提供。不能把 `Ok` 当成 LSP 标准第五种诊断 severity，它是 Neovim 的成功提示高亮。

## 插件支持范围

| 配置键 | 支持内容 |
| --- | --- |
| `cmp`, `blink` | 菜单、匹配、弃用项、种类；blink 文档及签名窗 |
| `telescope`, `fzf` | 普通／预览窗口、边界、标题、匹配与选择 |
| `nvim_tree`, `neo_tree`, `oil` | 文件、目录、Git 状态、选择与面板 |
| `gitsigns`, `diffview` | Git 标记、增删改、diff 面板 |
| `which_key`, `lazy`, `mason`, `trouble` | 提示、管理面板与诊断列表 |
| `noice`, `notify` | 命令行、消息、通知及其严重程度 |
| `ibl` | IblIndent / IblWhitespace / IblScope；旧版 indent-blankline 请使用自己的组覆盖 |
| `mini` | mini.pick、mini.clue、mini.statusline、mini.tabline |
| `snacks` | 通用窗口、picker 常用元素、dashboard；其他组件继承原生组 |
| `flash`, `leap` | 跳转匹配和标签；Leap 使用当前公开的 Label / Match 组 |
| `render_markdown` | 标题、代码、引用、列表、表格和链接 |
| `bufferline` | 缓冲区、标签、关闭按钮、修改标记与边界 |
| lualine 主题接口 | normal/insert/visual/replace/command/terminal/inactive 模式 |

这些是有范围的高亮映射，不宣称覆盖每个插件的所有功能。未安装插件不会报错，插件自身 `winhighlight`、用户覆盖、后加载的强制重设仍可能改变效果。图标颜色、外部 fzf 颜色、窗口几何及通知背景混合可能需要插件公开 API。名称依据和调研链接见 [SOURCES.md](doc/SOURCES.md)。

## 自定义

```lua
require('paper-platinum').setup({
  style = 'light',
  styles = { comments = { italic = false }, functions = { bold = true } },
  on_colors = function(c)
    c.string = '#526d43'       -- 使用语义键覆盖所有字符串
    c.bg_float = '#e5e2d8'
  end,
  on_highlights = function(h, c)
    h.CursorLineNr = { fg = c.ochre, bold = true }
    h['@lsp.type.variable'] = {} -- 明确保留 Tree-sitter
    h.MyPluginTitle = { link = 'Title' }
  end,
})
vim.cmd.colorscheme('paper-platinum')
```

`styles` 是传给 `nvim_set_hl` 的属性表，可用 `italic = false` 去除默认值。语义别名在 `on_colors` 前建立，因此改 `c.blue` 不会自动改已经生成的 `c['function']`；应改目标语义键。ANSI 色板在 `c.terminal[1..16]` 独立定义，也可以在此回调修改。`on_highlights` 最后执行，可显式覆盖透明模式；将组设为 `{}` 清空，将组设为 `nil` 则不提交该组。

`paper.colors()` 返回当前配置的新配色副本；`paper.highlights()` 返回高亮表、配色和配置，不修改界面。回调应保持幂等，因为这两个查询函数也会构建配色。错误配置在清理高亮之前检测；无效的 `nvim_set_hl` 属性仍由 Neovim 报错，不作静默吞错。

## 验证与维护

```sh
NVIM_LOG_FILE=/tmp/paper-nvim.log nvim --headless -u NONE -i NONE -l tests/run.lua
NVIM_LOG_FILE=/tmp/paper-nvim.log XDG_STATE_HOME=/tmp/paper-state \
  nvim --headless -u NONE -i NONE -l tests/lsp.lua # 测试夹具需要 Node.js
PAPER_QUERIES=/path/to/nvim-treesitter/runtime \
  nvim --headless -u NONE -i NONE -l tests/languages.lua
# 可选：需要 Kitty、Xvfb、ImageMagick；使用独立 X server，不截图用户桌面
bash tests/capture.sh light
bash tests/capture.sh dark
```

主题本身不依赖 Node.js 或以上截图工具。语言套件在缺少 parser/query 时明确输出 SKIP；运行基础套件需 Neovim 自带 Lua parser。`PAPER_QUERIES` 只加入已有查询文件，不加载用户配置。交互预览：`nvim -u NONE -i NONE -c 'luafile tests/preview.lua'`，环境变量 `PAPER_STYLE=dark` / `PAPER_TRANSPARENT=1` 可切换场景。

详见 [测试记录与限制](doc/TESTING.md)。没有对所有插件版本做完整交互回归，也未实测 Kitty 0.6 opacity 与实际壁纸的合成效果；不要将静态名称核验当成这些测试通过。

项目结构：`palette.lua` 配色、`config.lua` 配置、`highlights/` 原生语义、`integrations/` 独立插件模块、`colors/` 加载入口、`lua/lualine/themes/` 公开主题接口、`tests/` 实测与夹具。贡献新集成时请引用插件自身的公开组或源码，添加有意义的验证，避免复制参考主题的 RGB 表。

## 许可证

沿用仓库的 [Apache-2.0](LICENSE)。本实现独立设计；默认配色独立设计，vivid 的 Dark 模式按用户要求采用 Tokyo Night 的亮红／黄色，Light 则独立调整；没有引入其主题实现。

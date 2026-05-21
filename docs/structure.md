# Project Structure / 工程结构

Last synchronized: 2026-05-14.
最后同步时间：2026-05-14。

This config keeps Neovim runtime entrypoints at the repository root, while implementation lives under `lua/`.
本配置保留 Neovim 约定的根目录入口，具体实现集中放在 `lua/` 下。

Lazy.nvim currently loads only the imports declared in `lua/config/lazy.lua`: `plugins.core`, `plugins.ai`, `plugins.coding`, `plugins.editor`, `plugins.lang`, `plugins.tools`, and `plugins.ui`.
Lazy.nvim 当前只加载 `lua/config/lazy.lua` 中声明的入口：`plugins.core`、`plugins.ai`、`plugins.coding`、`plugins.editor`、`plugins.lang`、`plugins.tools`、`plugins.ui`。

Top-level compatibility files under `lua/plugins/*.lua` still exist, but they are not active unless one of those files is explicitly imported by `lua/config/lazy.lua`.
`lua/plugins/*.lua` 下仍保留部分顶层兼容文件，但除非被 `lua/config/lazy.lua` 显式导入，否则不会生效。

```text
.
├── init.lua                  Main startup entry / 主启动入口
├── after/                    Runtime overrides loaded after plugins / 插件加载后的覆盖配置
│   └── ftplugin/             Filetype after-hooks / 文件类型后置入口
├── colors/                   Custom colorschemes / 自定义主题
├── docs/                     Documentation / 文档
├── ftplugin/                 Thin filetype entrypoints / 文件类型薄入口
├── lua/
│   ├── config/               Core editor config / 基础编辑器配置
│   ├── filetypes/            Per-filetype implementation, including Go/Rust / 文件类型具体实现，包含 Go/Rust
│   ├── modules/              Reusable feature modules / 可复用功能模块
│   │   ├── ai/               AI extension modules / AI 扩展模块
│   │   └── goimpl/           Go interface implementation workflow / Go interface 实现流程
│   ├── plugins/              Lazy.nvim plugin specs / 插件声明
│   │   ├── ai/               AI coding plugins / AI 编程插件
│   │   ├── coding/           Completion, format, treesitter / 补全、格式化、Treesitter
│   │   ├── editor/           Navigation, search, file tree / 导航、搜索、文件树
│   │   ├── lang/             Language integrations / 语言能力
│   │   ├── tools/            DAP, CMake, Git tools / DAP、CMake、Git 工具
│   │   ├── ui/               Theme, statusline, notifications / 主题、状态栏、通知
│   │   └── *.lua             Legacy compatibility specs, inactive by default / 旧兼容插件声明，默认不加载
│   ├── icons.lua             Shared icon table / 图标表
│   └── utils.lua             Shared utilities / 通用工具
├── plugin/                   Legacy root runtime directory, currently empty / 旧根运行时目录，当前为空
├── queries/                  Treesitter custom queries / Treesitter 自定义查询
├── snippets/                 LuaSnip snippets / 代码片段
├── wezterm/                  Terminal config helpers / 终端配置辅助文件
├── markdown.css              Markdown preview CSS / Markdown 预览样式
└── stylua.toml               Lua formatter config / Lua 格式化配置
```

## Directory Rules / 分层规则

| Directory | 中文规则 | English Rule |
| --- | --- | --- |
| `lua/config/` | 只放全局基础配置和启动逻辑 | Global editor config and startup only |
| `lua/plugins/{ai,coding,editor,lang,tools,ui}/` | 当前实际加载的插件分层；新增插件优先放这里 | Active plugin spec layers; add new plugins here first |
| `lua/plugins/*.lua` | 遗留兼容插件声明；默认不加载，除非加入 `lua/config/lazy.lua` | Legacy compatibility specs; inactive unless imported by `lua/config/lazy.lua` |
| `lua/filetypes/` | 只放某种文件类型打开时才需要的局部配置 | Buffer-local filetype behavior only |
| `lua/modules/` | 放可被多处复用的功能模块 | Reusable feature modules |
| `ftplugin/` | 只做 `require("filetypes.<name>").setup()` 入口 | Thin Neovim runtime entrypoints |
| `after/ftplugin/` | 只做文件类型后置入口 | Thin post-filetype entrypoints |
| `plugin/` | 不再放主要逻辑；如需根运行时入口，应保持很薄 | Keep major logic out; use only thin root runtime entrypoints if needed |
| `docs/` | 使用说明、快捷键、结构说明 | Usage, keymaps, and architecture docs |

## Active Lazy Imports / 实际 Lazy 加载入口

| Import | 中文职责 | English Responsibility |
| --- | --- | --- |
| `plugins.core` | 自动括号、surround、Trouble、颜色高亮、Diffview、WinShift 等基础插件 | Core editing plugins such as autopairs, surround, Trouble, color highlighting, Diffview, and WinShift |
| `plugins.ai` | Avante、CodeCompanion 及其 AI 集成 | Avante, CodeCompanion, and AI integration |
| `plugins.coding` | blink.cmp、Conform、诊断、LuaSnip、Treesitter、Treesitter context | blink.cmp, Conform, diagnostics, LuaSnip, Treesitter, and Treesitter context |
| `plugins.editor` | fzf-lua、Flash、Neo-tree、Oil、window-picker、tmux navigation、which-key、Aerial | fzf-lua, Flash, Neo-tree, Oil, window-picker, tmux navigation, which-key, and Aerial |
| `plugins.lang` | Python、Go、Rust、Markdown、LaTeX、LSP、lazydev 等语言能力 | Python, Go, Rust, Markdown, LaTeX, LSP, lazydev, and other language integrations |
| `plugins.tools` | DAP、CMake、Gitsigns | DAP, CMake, and Gitsigns |
| `plugins.ui` | 主题、lualine、Noice、Snacks、indent guides | Themes, lualine, Noice, Snacks, and indent guides |

## Split-Safe UI / 分屏独立 UI

The split scrolling fix is intentionally scoped to `nvim-treesitter-context` instead of global scroll behavior.
分屏滚动相关修复刻意限定在 `nvim-treesitter-context`，不再扩大修改全局滚动行为。

Current active config lives in `lua/plugins/coding/treesitter.lua`. The legacy mirror `lua/plugins/tree-sitter.lua` keeps the same settings only for compatibility.
当前生效配置位于 `lua/plugins/coding/treesitter.lua`。遗留镜像 `lua/plugins/tree-sitter.lua` 只用于兼容，保持同样设置。

```lua
multiwindow = true
mode = "topline"
max_lines = 3
min_window_height = 20
line_numbers = false
```

These options keep sticky context windows separate per split and prevent a tall context overlay from moving with another split.
这些选项让每个分屏拥有独立的顶部上下文，并避免过高的上下文浮层跟随另一个分屏移动。

## Why Keep `ftplugin/`? / 为什么保留 `ftplugin/`

`ftplugin/` is a Neovim runtime convention. Moving it into `lua/` would stop automatic filetype loading.
`ftplugin/` 是 Neovim 的运行时约定，直接移进 `lua/` 会导致文件类型配置无法自动加载。

So the root `ftplugin/` files are intentionally tiny bridge files, and the real code lives in `lua/filetypes/`.
所以根目录 `ftplugin/` 只保留很薄的桥接文件，真正逻辑放在 `lua/filetypes/`。

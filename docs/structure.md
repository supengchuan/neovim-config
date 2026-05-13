# Project Structure / 工程结构

This config keeps Neovim runtime entrypoints at the repository root, while implementation lives under `lua/`.
本配置保留 Neovim 约定的根目录入口，具体实现集中放在 `lua/` 下。

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
│   │   └── ui/               Theme, statusline, notifications / 主题、状态栏、通知
│   ├── icons.lua             Shared icon table / 图标表
│   └── utils.lua             Shared utilities / 通用工具
├── queries/                  Treesitter custom queries / Treesitter 自定义查询
├── snippets/                 LuaSnip snippets / 代码片段
├── markdown.css              Markdown preview CSS / Markdown 预览样式
└── stylua.toml               Lua formatter config / Lua 格式化配置
```

## Directory Rules / 分层规则

| Directory | 中文规则 | English Rule |
| --- | --- | --- |
| `lua/config/` | 只放全局基础配置和启动逻辑 | Global editor config and startup only |
| `lua/plugins/` | 只放插件声明与插件配置 | Plugin specs and plugin setup only |
| `lua/filetypes/` | 只放某种文件类型打开时才需要的局部配置 | Buffer-local filetype behavior only |
| `lua/modules/` | 放可被多处复用的功能模块 | Reusable feature modules |
| `ftplugin/` | 只做 `require("filetypes.<name>").setup()` 入口 | Thin Neovim runtime entrypoints |
| `after/ftplugin/` | 只做文件类型后置入口 | Thin post-filetype entrypoints |
| `docs/` | 使用说明、快捷键、结构说明 | Usage, keymaps, and architecture docs |

## Why Keep `ftplugin/`? / 为什么保留 `ftplugin/`

`ftplugin/` is a Neovim runtime convention. Moving it into `lua/` would stop automatic filetype loading.
`ftplugin/` 是 Neovim 的运行时约定，直接移进 `lua/` 会导致文件类型配置无法自动加载。

So the root `ftplugin/` files are intentionally tiny bridge files, and the real code lives in `lua/filetypes/`.
所以根目录 `ftplugin/` 只保留很薄的桥接文件，真正逻辑放在 `lua/filetypes/`。

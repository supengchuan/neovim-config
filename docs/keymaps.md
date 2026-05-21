# Neovim Keymaps / 快捷键说明

> Leader key: `<Space>` / Leader 键是空格。

Last synchronized: 2026-05-15.
最后同步时间：2026-05-15。

This document is based on the keymaps that are actually active in Neovim, including `init.lua`, `lua/config`, active lazy imports under `lua/plugins/{core,ai,coding,editor,lang,tools,ui}`, `lua/filetypes`, `ftplugin`, `after/ftplugin`, and `snippets`.
本文档依据 Neovim 实际生效的快捷键整理，范围包括 `init.lua`、`lua/config`、当前 lazy 加载的 `lua/plugins/{core,ai,coding,editor,lang,tools,ui}`、`lua/filetypes`、`ftplugin`、`after/ftplugin` 和 `snippets`。

Legacy top-level files such as `lua/plugins/fzf.lua` are not counted unless they are imported by `lua/config/lazy.lua`.
未被 `lua/config/lazy.lua` 导入的旧顶层文件，例如 `lua/plugins/fzf.lua`，不计入本文档。

## Behavior Notes / 行为说明

| Area | 中文说明 | English |
| --- | --- | --- |
| Split context | `nvim-treesitter-context` 已启用，但没有直接快捷键；当前使用 `multiwindow = true`、`mode = "topline"`、`max_lines = 3`、`min_window_height = 20`，使左右分屏的顶部上下文互相独立 | `nvim-treesitter-context` is enabled without a direct keymap; it uses `multiwindow = true`, `mode = "topline"`, `max_lines = 3`, and `min_window_height = 20` so split context headers stay independent |
| Scroll isolation | 滚轮、翻页、半页滚动键会先断开普通编辑窗口的 `scrollbind` / `cursorbind`，再执行 Neovim 原生滚动 | Mouse wheel, page, and half-page scroll keys clear `scrollbind` / `cursorbind` in normal editor windows before native scrolling |

## Prefixes / 前缀

| Prefix | 中文说明 | English |
| --- | --- | --- |
| `<leader>a` | Avante AI | Avante AI |
| `<leader>b` | 构建、运行、CMake | Build, run, CMake |
| `<leader>c` | 代码动作、格式化、LSP | Code actions, formatting, LSP |
| `<leader>d` | 调试 | Debugging |
| `<leader>e` | 文件树、文件管理器、项目根 | Explorer, file manager, project root |
| `<leader>f` | 查找、搜索、列表 | Find, search, lists |
| `<leader>g` | Git | Git |
| `<leader>G` | Go | Go |
| `<leader>m` | Markdown | Markdown |
| `<leader>p` | Python | Python |
| `<leader>r` | Rust / Cargo / crates.nvim | Rust / Cargo / crates.nvim |
| `<leader>t` | 终端 | Terminal |
| `<leader>u` | UI 和临时状态 | UI and temporary state |

## General / 通用

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>/` | Normal | 打开 which-key 快捷键总览 | Show which-key overview |
| `<leader>w` | Normal | 保存当前 buffer | Save current buffer |
| `<leader>q` | Normal | 关闭当前窗口 | Quit current window |
| `<leader>Q` | Normal | 强制退出所有窗口 | Force quit all windows |
| `;n` | Normal | 取消搜索高亮 | Clear search highlight |
| `<leader>-` | Normal | 当前窗口变窄 | Make current split narrower |
| `<leader>=` | Normal | 当前窗口变宽 | Make current split wider |
| `<leader>uc` | Normal | 清空系统剪贴板寄存器 | Clear system clipboard registers |
| `<leader>uw` | Normal | 切换当前窗口自动折行；分屏之间互不联动 | Toggle line wrap for current window; split windows stay independent |
| `<leader>c;` | Normal | 行尾补分号并新建下一行 | Add semicolon and open a new line |
| `[q` | Normal | 跳到上一条 quickfix 项；quickfix 未打开时提示 | Previous quickfix item; notify if quickfix is closed |
| `]q` | Normal | 跳到下一条 quickfix 项；quickfix 未打开时提示 | Next quickfix item; notify if quickfix is closed |
| `gx` | Normal | 用系统程序打开光标下路径或 URL | Open path or URL under cursor with the system handler |
| `gcc` | Normal | 注释/取消注释当前行 | Toggle comment for current line |
| `gc{motion}` | Normal / Operator | 注释/取消注释 motion 范围 | Toggle comment for a motion |
| `gc` | Visual | 注释/取消注释选区 | Toggle comment for selection |
| `<ScrollWheelUp/Down/Left/Right>` | Normal / Visual | 滚动前断开窗口联动，再执行原生滚动 | Disable window binding before native mouse-wheel scrolling |
| `<S-ScrollWheelUp/Down>` | Normal / Visual | 横向滚动前断开窗口联动，再执行原生滚动 | Disable window binding before native shifted mouse-wheel scrolling |
| `<C-y>/<C-e>/<C-u>/<C-d>/<C-b>/<C-f>` | Normal / Visual | 滚动前断开窗口联动，再执行原生滚动 | Disable window binding before native keyboard scrolling |
| `<PageUp>/<PageDown>` | Normal / Visual | 翻页前断开窗口联动，再执行原生翻页 | Disable window binding before native page scrolling |

Source / 来源: `lua/config/keymaps.lua`, `lua/plugins/editor/which-key.lua`, Neovim defaults.

## Find And Navigation / 查找与导航

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>ff` | Normal | 查找文件 | Find files |
| `<leader>fb` | Normal | 切换 buffer | Switch buffers |
| `<leader>fg` | Normal | 全项目 live grep 搜索 | Search project with live grep |
| `<leader>fg` | Visual | 搜索选中文本 | Search selected text |
| `<leader>fd` | Normal | 列出 workspace 诊断 | List workspace diagnostics |
| `<C-]>` | Normal | 直接 LSP definition 跳转，并把目标位置靠近窗口顶部；无 LSP 时回退 tag 跳转 | Direct LSP definition jump and place the target near the top; fallback to tag jump without LSP |
| `gr` | Normal | 用 fzf-lua 查找引用 | Find references with fzf-lua |
| `gi` | Normal | 用 fzf-lua 查找实现 | Find implementations with fzf-lua |
| `s` | Normal / Visual / Operator | Flash 快速跳转 | Jump with Flash |

Source / 来源: `lua/plugins/editor/fzf.lua`, `lua/plugins/editor/flash.lua`.

### fzf-lua

| Key | 中文说明 | English |
| --- | --- | --- |
| `<C-q>` | 全选结果并发送到 quickfix | Select all results and send to quickfix |
| `<C-u>` | 向上半页 | Half-page up |
| `<C-d>` | 向下半页 | Half-page down |
| `<C-x>` | 跳转到当前项 | Jump to current item |
| `<C-f>` | 预览窗口向下翻页 | Scroll preview down |
| `<C-b>` | 预览窗口向上翻页 | Scroll preview up |
| `<F12>` | 切换预览窗口 | Toggle preview |

## Native LSP Defaults / Neovim LSP 默认键

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `gra` | Normal / Visual | LSP code action | LSP code action |
| `grn` | Normal | LSP rename | LSP rename |
| `grr` | Normal | LSP references | LSP references |
| `gri` | Normal | LSP implementation | LSP implementation |
| `grt` | Normal | LSP type definition | LSP type definition |
| `grx` | Normal | 运行 codelens | Run codelens |
| `gO` | Normal | 当前 buffer 符号大纲 | Document symbols |
| `[d` | Normal | 上一个诊断 | Previous diagnostic |
| `]d` | Normal | 下一个诊断 | Next diagnostic |
| `[D` | Normal | 当前 buffer 第一个诊断 | First diagnostic in current buffer |
| `]D` | Normal | 当前 buffer 最后一个诊断 | Last diagnostic in current buffer |
| `<C-w>d` | Normal | 显示光标处诊断 | Show diagnostics under cursor |
| `<C-s>` | Insert / Select | LSP signature help | LSP signature help |

Source / 来源: Neovim LSP defaults.

## Code / 代码动作

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>cf` | Normal | 格式化当前文件 | Format current file |
| `<leader>cf` | Visual | 格式化选区并退出 visual mode | Format selected range and leave visual mode |
| `<leader>cd` | Normal | 打开当前行诊断浮窗 | Open diagnostic float for current line |
| `<leader>ch` | Normal | 显示 LSP hover 信息 | Show LSP hover documentation |
| `<leader>ci` | Normal | 切换 LSP inlay hints | Toggle LSP inlay hints |
| `<leader>cr` | Normal | LSP rename | LSP rename |
| `<leader>co` | Normal | 打开/关闭当前 buffer 符号大纲 | Toggle buffer outline |
| `<leader>cg` | Normal, Go buffer | 选择 Go interface 并生成实现 | Pick a Go interface and generate implementation |
| `<leader>cH` | Normal, C/C++ buffer | 在源文件和头文件之间切换 | Switch between source and header |
| `<leader>cS` | Normal, C/C++ buffer | 显示 clangd 符号信息 | Show clangd symbol info |
| `;;` | Normal / Insert, C/C++/Rust buffer | 行尾补分号并新建下一行 | Add semicolon and open a new line |

Source / 来源: `lua/plugins/coding/conform.lua`, `lua/plugins/editor/aerial.lua`, `lua/plugins/editor/which-key.lua`, `lua/plugins/lang/go-impl.lua`, `lua/filetypes/c_family.lua`, `lua/config/autocmds.lua`.

## AI / Avante

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>aa` | Normal / Visual / Select | Avante ask | Avante ask |
| `<leader>an` | Normal / Visual / Select | 新建 Avante ask | Create new Avante ask |
| `<leader>ae` | Visual / Select | 编辑选区 | Edit selected range |
| `<leader>az` | Normal / Visual / Select | 切换 Avante Zen Mode | Toggle Avante Zen Mode |
| `<leader>at` | Normal | 打开/关闭 Avante 面板 | Toggle Avante panel |
| `<leader>ar` | Normal | 刷新 Avante | Refresh Avante |
| `<leader>af` | Normal | 聚焦 Avante | Focus Avante |
| `<leader>aS` | Normal | 停止当前 Avante 请求 | Stop current Avante request |
| `<leader>ad` | Normal | 切换 Avante debug | Toggle Avante debug |
| `<leader>aC` | Normal | 切换 selection | Toggle selection |
| `<leader>as` | Normal | 切换 suggestion | Toggle suggestion |
| `<leader>aR` | Normal | 显示 repo map | Display repo map |
| `<leader>a?` | Normal | 选择模型 | Select model |
| `<leader>ah` | Normal | 选择历史 | Select history |
| `<leader>aM` | Normal | 选择 ACP model | Select ACP model |
| `<leader>am` | Normal | 选择 ACP mode | Select ACP mode |
| `<leader>aB` | Normal | 添加所有已打开 buffer | Add all open buffers |

Source / 来源: `lua/plugins/ai/avante.lua`, `avante.nvim` defaults.

## Build And CMake / 构建与 CMake

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>bg` | Normal | CMake generate / configure | CMake generate / configure |
| `<leader>bb` | Normal | 构建选中的 CMake target | Build selected CMake target |
| `<leader>bf` | Normal | 构建当前文件关联 target | Build target related to current file |
| `<leader>br` | Normal | 运行选中的可执行 target | Run selected executable target |
| `<leader>bR` | Normal | 运行当前文件关联 target | Run target related to current file |
| `<leader>bd` | Normal | 调试选中的可执行 target | Debug selected executable target |
| `<leader>bD` | Normal | 调试当前文件关联 target | Debug target related to current file |
| `<leader>bt` | Normal | 运行 CTest 测试 | Run CTest tests |
| `<leader>bc` | Normal | 清理 CMake 构建产物 | Clean CMake build artifacts |
| `<leader>bB` | Normal | 选择构建类型 | Select build type |
| `<leader>bT` | Normal | 选择 build target | Select build target |
| `<leader>bL` | Normal | 选择 launch target | Select launch target |
| `<leader>bp` | Normal | 选择 configure preset | Select configure preset |
| `<leader>bP` | Normal | 选择 build preset | Select build preset |
| `<leader>bk` | Normal | 选择 CMake kit | Select CMake kit |
| `<leader>bs` | Normal | 打开 CMake settings | Open CMake settings |
| `<leader>bo` | Normal | 打开 CMake executor 窗口 | Open CMake executor window |
| `<leader>bO` | Normal | 打开 CMake runner 窗口 | Open CMake runner window |
| `<leader>bx` | Normal | 停止 CMake 任务 | Stop CMake jobs |

Source / 来源: `lua/plugins/tools/cmake.lua`.

## Windows, Explorer, Terminal / 窗口、文件、终端

| Key | Mode / Context | 中文说明 | English |
| --- | --- | --- | --- |
| `<C-h>` | Normal | 跳到左侧 nvim/tmux pane | Move to left nvim/tmux pane |
| `<C-j>` | Normal | 跳到下方 nvim/tmux pane | Move to lower nvim/tmux pane |
| `<C-k>` | Normal | 跳到上方 nvim/tmux pane | Move to upper nvim/tmux pane |
| `<C-l>` | Normal | 跳到右侧 nvim/tmux pane | Move to right nvim/tmux pane |
| `<C-\>` | Normal, tmux-navigation | 跳回上一个活跃 pane | Move to last active pane |
| `<C-Space>` | Normal, tmux-navigation | 跳到下一个 pane | Move to next pane |
| `<leader><Tab>` | Normal | 用 window-picker 选择窗口 | Pick a window |
| `<leader>M` | Normal | 启动 WinShift 移动窗口 | Move windows with WinShift |
| `<C-n>` | Normal | 打开/关闭 Neo-tree | Toggle Neo-tree |
| `<leader>ee` | Normal | 打开/关闭 Neo-tree | Toggle Neo-tree |
| `<leader>eo` | Normal | 打开/关闭 Oil 浮动文件管理器 | Toggle Oil floating file manager |
| `<leader>eg` | Normal, Go/gomod/gowork buffer | 将 Neo-tree 根目录切到 Go 项目根 | Set Neo-tree root to Go project root |
| `<leader>tt` | Normal | 打开/关闭 Snacks terminal | Toggle Snacks terminal |
| `<leader>th` | Normal | 在底部水平分屏打开/关闭 Snacks terminal | Toggle Snacks terminal in a bottom horizontal split |
| `<Esc>` | Snacks terminal | 隐藏 terminal | Hide terminal |

Source / 来源: `lua/plugins/editor/tmux-navigation.lua`, `lua/plugins/editor/window-picker.lua`, `lua/plugins/core.lua`, `lua/plugins/editor/neo-tree.lua`, `lua/plugins/editor/oil.lua`, `lua/filetypes/go.lua`, `lua/plugins/ui/snacks.lua`.

### Neo-tree

| Key | 中文说明 | English |
| --- | --- | --- |
| `<CR>` | 打开文件或目录 | Open file or directory |
| `h` | 关闭目录节点 | Close directory node |
| `Y` | 复制文件路径到系统剪贴板 | Copy file path to system clipboard |
| `O` | 用系统应用打开 | Open with system app |
| `P` | 切换预览 | Toggle preview |
| `<C-v>` | 用窗口选择器垂直分屏打开，并保持两侧滚动独立 | Open in vertical split with window picker, keeping both sides independently scrollable |
| `<Space>` | 禁用 | Disabled |

Source / 来源: `lua/plugins/editor/neo-tree.lua`.

### Oil

| Key | 中文说明 | English |
| --- | --- | --- |
| `<2-LeftMouse>` | 选择/打开条目 | Select/open entry |
| `J` | 预览窗口向下滚动 | Scroll preview down |
| `K` | 预览窗口向上滚动 | Scroll preview up |
| `q` | 关闭 Oil | Close Oil |
| `yp` | 复制路径到系统剪贴板 | Copy path to system clipboard |

Source / 来源: `lua/plugins/editor/oil.lua`.

## Git / Git

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>gg` | Normal | 打开/关闭 lazygit | Toggle lazygit |
| `<leader>gb` | Normal | 查看当前行 blame | Show blame for current line |
| `<leader>gr` | Normal | reset 当前 hunk | Reset current hunk |
| `<leader>gs` | Normal | stage 当前 hunk | Stage current hunk |
| `[g` | Normal | 上一个 Git hunk | Previous Git hunk |
| `]g` | Normal | 下一个 Git hunk | Next Git hunk |

Source / 来源: `lua/plugins/ui/snacks.lua`, `lua/plugins/tools/gitsigns.lua`.

## Debug / 调试

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<F5>` | Normal | 继续运行/运行到下一个断点 | Continue / run to next breakpoint |
| `<F10>` | Normal | 单步跳过 | Step over |
| `<F11>` | Normal | 单步进入 | Step into |
| `<F12>` | Normal | 单步跳出 | Step out |
| `<leader>db` | Normal | 切换断点 | Toggle breakpoint |
| `<leader>dc` | Normal | 继续运行 | Continue debugging |
| `<leader>di` | Normal | 单步进入 | Step into |
| `<leader>do` | Normal | 单步跳过 | Step over |
| `<leader>dO` | Normal | 单步跳出 | Step out |

Source / 来源: `lua/plugins/tools/dap.lua`.

## Go / Go

| Key / Command | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>Gr` | Normal, Go buffer | 运行当前 Go package | Run current Go package |
| `<leader>Gb` | Normal, Go buffer | 构建当前 Go package | Build current Go package |
| `<leader>Gt` | Normal, Go buffer | 运行 workspace 测试 | Run workspace tests |
| `<leader>Gf` | Normal, Go buffer | 运行当前文件测试 | Run tests for current file |
| `<leader>Gn` | Normal, Go buffer | 运行光标附近测试函数 | Run nearest test function |
| `<leader>Gp` | Normal, Go buffer | 运行当前 package 测试 | Run current package tests |
| `<leader>Gc` | Normal, Go buffer | 当前 package 覆盖率 | Package test coverage |
| `<leader>Gd` | Normal, Go buffer | 启动 Go 调试 | Start Go debugger |
| `<leader>GD` | Normal, Go buffer | 调试光标附近测试 | Debug nearest Go test |
| `<leader>Ga` | Normal, Go buffer | 在实现文件和测试文件间切换 | Switch implementation/test file |
| `<leader>Gv` | Normal, Go buffer | 垂直分屏打开对应实现/测试文件 | Open alternate file in vertical split |
| `<leader>Gh` | Normal, Go buffer | 查看 Go 文档 | Show Go documentation |
| `<leader>Gm` | Normal, Go/gomod buffer | 执行 go mod tidy | Run go mod tidy |
| `<leader>Gw` | Normal, gowork buffer | 执行 go work sync | Run go work sync |
| `<leader>Gi` | Normal, Go buffer | 自定义 interface 实现选择器 | Custom interface implementation picker |
| `<leader>GI` | Normal, Go buffer | go.nvim GoImpl | go.nvim GoImpl |
| `<leader>Ge` | Normal, Go buffer | 插入 if err | Insert if err block |
| `<leader>Gs` | Normal, Go buffer | 填充 struct 字段 | Fill struct fields |
| `<leader>Gj` | Normal, Go buffer | 添加 json struct tag | Add json struct tags |
| `<leader>GJ` | Normal, Go buffer | 删除 json struct tag | Remove json struct tags |
| `<leader>Gl` | Normal, Go buffer | 运行 golangci-lint | Run golangci-lint |
| `<leader>Gg` | Normal, Go buffer | 执行 go generate | Run go generate |
| `:GoMethodList` | Command, Go buffer | 列出当前 struct 方法 | List methods for current struct |
| `:Impl` | Command, Go buffer | 自定义 Go interface 实现流程 | Custom Go interface implementation flow |

Source / 来源: `lua/filetypes/go.lua`, `lua/plugins/lang/go.lua`, `lua/plugins/lang/go-impl.lua`.

## Python / Python

| Key / Command | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>pr` | Normal, Python buffer | 运行当前 Python 文件 | Run current Python file |
| `<leader>pf` | Normal, Python buffer | 对当前文件运行 pytest | Run pytest for current file |
| `<leader>pt` | Normal, Python buffer | 调试最近的 Python 测试方法 | Debug nearest Python test method |
| `<leader>pT` | Normal, Python buffer | 调试当前 Python 测试类 | Debug current Python test class |
| `<leader>pv` | Normal, Python buffer | 选择 Python virtualenv | Select Python virtualenv |
| `<leader>pc` | Normal, Python buffer | 使用缓存的 Python virtualenv | Reuse cached Python virtualenv |
| `:PyRunFile` | Command, Python buffer | 运行当前 Python 文件 | Run current Python file |
| `:PyTestFile` | Command, Python buffer | 对当前文件运行 pytest | Run pytest for current Python file |

Source / 来源: `lua/filetypes/python.lua`, `lua/plugins/lang/python.lua`.

## Rust And Cargo / Rust 与 Cargo

| Key / Command | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>rb` | Normal, Rust buffer | cargo build | cargo build |
| `<leader>rc` | Normal, Rust buffer | cargo check | cargo check |
| `<leader>rC` | Normal, Rust buffer | cargo clippy --all-targets --all-features | cargo clippy --all-targets --all-features |
| `<leader>rr` | Normal, Rust buffer | cargo run | cargo run |
| `<leader>rt` | Normal, Rust buffer | cargo test | cargo test |
| `<leader>rR` | Normal, Rust buffer | rust-analyzer runnables | rust-analyzer runnables |
| `<leader>rT` | Normal, Rust buffer | rust-analyzer testables | rust-analyzer testables |
| `<leader>rd` | Normal, Rust buffer | 调试光标所在目标 | Debug target at cursor |
| `<leader>rD` | Normal, Rust buffer | 选择可调试目标 | Select debuggable target |
| `<leader>ra` | Normal, Rust buffer | Rust code action | Rust code action |
| `<leader>rh` | Normal, Rust buffer | Rust hover actions | Rust hover actions |
| `<leader>re` | Normal, Rust buffer | 解释当前 Rust 错误 | Explain current Rust error |
| `<leader>rE` | Normal, Rust buffer | 渲染当前 Rust 诊断 | Render current Rust diagnostic |
| `<leader>rm` | Normal, Rust buffer | 展开宏 | Expand macro |
| `<leader>rM` | Normal, Rust buffer | 重建 proc macros | Rebuild proc macros |
| `<leader>ro` | Normal, Rust buffer | 打开 docs.rs 文档 | Open docs.rs documentation |
| `<leader>rp` | Normal, Rust buffer | 打开父模块 | Open parent module |
| `<leader>rj` | Normal, Rust buffer | Rust join lines | Rust join lines |
| `<leader>rl` | Normal, Rust buffer | 重载 rust-analyzer workspace | Reload rust-analyzer workspace |
| `<leader>rs` | Normal, Rust buffer | 搜索 Rust workspace symbols | Search Rust workspace symbols |
| `<leader>rS` | Normal, Rust buffer | 查看 Rust syntax tree | Show Rust syntax tree |
| `<leader>rv` | Normal, Cargo.toml | 查看 crate 版本 | Show crate versions |
| `<leader>rf` | Normal, Cargo.toml | 查看 crate features | Show crate features |
| `<leader>rP` | Normal, Cargo.toml | 查看 crate 依赖 | Show crate dependencies |
| `<leader>ru` | Normal, Cargo.toml | 更新当前 crate | Update current crate |
| `<leader>rU` | Normal, Cargo.toml | 升级当前 crate | Upgrade current crate |
| `<leader>ra` | Normal, Cargo.toml | 更新所有 crates | Update all crates |
| `<leader>rA` | Normal, Cargo.toml | 升级所有 crates | Upgrade all crates |
| `<leader>rH` | Normal, Cargo.toml | 打开 crate homepage | Open crate homepage |
| `<leader>rO` | Normal, Cargo.toml | 打开 crate repository | Open crate repository |
| `<leader>rW` | Normal, Cargo.toml | 打开 crates.io 页面 | Open crates.io page |
| `:RustCargoBuild` | Command, Rust buffer | cargo build，可追加参数 | cargo build with optional args |
| `:RustCargoCheck` | Command, Rust buffer | cargo check，可追加参数 | cargo check with optional args |
| `:RustCargoClippy` | Command, Rust buffer | cargo clippy，可追加参数 | cargo clippy with optional args |
| `:RustCargoRun` | Command, Rust buffer | cargo run，可追加参数 | cargo run with optional args |
| `:RustCargoTest` | Command, Rust buffer | cargo test，可追加参数 | cargo test with optional args |

Note / 说明: `<leader>ra` depends on context. In Rust source files it is rust-analyzer code action; in `Cargo.toml` it updates all crates.
`<leader>ra` 依赖上下文。在 Rust 源码文件中是 rust-analyzer code action；在 `Cargo.toml` 中是更新所有 crates。

Source / 来源: `lua/filetypes/rust.lua`, `lua/filetypes/toml.lua`, `lua/plugins/lang/rust.lua`.

## Markdown And Text / Markdown 与文本

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `j` | Normal, Markdown/TeX/CodeCompanion buffer | 当前窗口开启 wrap 时按视觉行向下移动，否则保持普通 `j` | Move down by visual line only when the current window has wrap enabled; otherwise normal `j` |
| `k` | Normal, Markdown/TeX/CodeCompanion buffer | 当前窗口开启 wrap 时按视觉行向上移动，否则保持普通 `k` | Move up by visual line only when the current window has wrap enabled; otherwise normal `k` |
| `<leader>mr` | Normal, Markdown buffer | 切换 Markdown 内联渲染 | Toggle inline Markdown rendering |
| `<leader>mp` | Normal, Markdown buffer | render-markdown 预览 | render-markdown preview |
| `<leader>mP` | Normal, Markdown buffer | 切换浏览器 Markdown 预览 | Toggle browser Markdown preview |
| `[[` | Normal, Markdown buffer | 上一个 section | Previous section |
| `]]` | Normal, Markdown buffer | 下一个 section | Next section |
| `gO` | Normal, Markdown buffer | 当前 buffer outline | Current buffer outline |

Source / 来源: `lua/config/autocmds.lua`, `lua/plugins/lang/markdown.lua`, Neovim markdown defaults.

## Completion And Snippets / 补全与代码片段

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<CR>` | Insert / Completion | 接受当前补全项，来自 blink.cmp `enter` preset | Accept selected completion item from blink.cmp `enter` preset |
| `<Tab>` | Insert / Completion | 接受当前补全项；snippet 激活时接受 snippet | Accept completion item; accept active snippet |
| `<Tab>` | Cmdline completion | 选择并接受命令行补全 | Select and accept command-line completion |
| `<C-k>` | Insert / Select | LuaSnip 展开或跳到下一个占位符 | LuaSnip expand or jump to next placeholder |
| `<C-j>` | Insert / Select | LuaSnip 跳到上一个占位符 | LuaSnip jump to previous placeholder |
| `<C-l>` | Insert / Select | LuaSnip 切换 choice node | LuaSnip cycle choice node |

Source / 来源: `lua/plugins/coding/blinkcmp.lua`, `lua/plugins/coding/luasnip.lua`.

## Textobjects And Surround / 文本对象与包围符

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `an` | Visual / Operator | 选择父级 Treesitter node | Select parent Treesitter node |
| `in` | Visual / Operator | 选择子级 Treesitter node | Select child Treesitter node |
| `[n` | Visual | 选择上一个 Treesitter node | Select previous Treesitter node |
| `]n` | Visual | 选择下一个 Treesitter node | Select next Treesitter node |
| `ys{motion}{char}` | Normal | 给 motion 范围添加包围符 | Add surrounding pair to a motion |
| `yss{char}` | Normal | 给整行添加包围符 | Add surrounding pair to the whole line |
| `S{char}` | Visual | 给选区添加包围符 | Surround visual selection |
| `ds{char}` | Normal | 删除包围符 | Delete surrounding pair |
| `cs{old}{new}` | Normal | 修改包围符 | Change surrounding pair |

Source / 来源: Neovim defaults, `kylechui/nvim-surround`.

## Useful Commands / 常用命令

| Command | 中文说明 | English |
| --- | --- | --- |
| `:Theme {name}` | 切换主题，例如 `:Theme catppuccin` | Switch colorscheme, e.g. `:Theme catppuccin` |
| `:Format` | 使用 Conform 格式化当前文件或选区 | Format current file or selected range |
| `:ClearX` | 清空系统剪贴板寄存器 | Clear system clipboard registers |
| `:CWD` | 将 cwd 切到当前文件目录 | Set cwd to current file directory |
| `:FoldEnable` | 启用 Treesitter fold | Enable Treesitter folding |
| `:TSContext enable / disable / toggle` | 开启、关闭或切换 Treesitter 顶部上下文 | Enable, disable, or toggle Treesitter sticky context |
| `:DefSplit` | 在垂直分屏中打开定义 | Open definition in vertical split |
| `:RunLab` | 打开当前实验性 Go interface 实现流程 | Open the current experimental Go interface implementation flow |
| `:WinNoBind` | 断开当前 tab 中普通窗口的滚动/光标联动 | Disable scroll/cursor binding for normal windows in the current tab |
| `:WinBindStatus` | 查看当前 tab 各窗口的滚动/光标联动状态 | Show scroll/cursor binding status for windows in the current tab |
| `:PythonLspInfo` | 查看当前 Python buffer 的 Pyright/Ruff 根目录、venv、extraPaths 和诊断模式 | Show Pyright/Ruff root, venv, extraPaths, and diagnostic mode for the current Python buffer |
| `:UnescapeJSON` | 反转义当前行 JSON 字符串 | Unescape JSON string on current line |
| `:QuoteJSON` | 将当前行转成 JSON 字符串 | Quote current line as JSON string |
| `:MarkdownPreview` | 打开 Markdown 预览 | Open Markdown preview |
| `:MarkdownPreviewToggle` | 切换 Markdown 预览 | Toggle Markdown preview |
| `:MarkdownPreviewStop` | 停止 Markdown 预览 | Stop Markdown preview |
| `:DiffviewOpen` | 打开 Diffview | Open Diffview |
| `:DiffviewClose` | 关闭 Diffview | Close Diffview |
| `:CMakeOpenCache` | 打开 CMakeCache.txt | Open CMakeCache.txt |
| `:CMakeTargetSettings` | 打开当前 target 的 CMake 设置 | Open CMake settings for a target |
| `:CodeCompanionActions` | 打开 CodeCompanion action palette | Open CodeCompanion action palette |
| `:CodeCompanionChat` | 打开 CodeCompanion chat | Open CodeCompanion chat |
| `:CodeCompanion` | 执行 CodeCompanion inline/chat 操作 | Run a CodeCompanion inline/chat action |
| `:CodeCompanionCmd` | 执行 CodeCompanion 命令策略 | Run CodeCompanion command strategy |

Source / 来源: `lua/config/commands.lua`, `lua/config/theme.lua`, `lua/plugins/coding/treesitter.lua`, `lua/plugins/lang/markdown.lua`, `lua/plugins/core.lua`, `lua/plugins/tools/cmake.lua`, `lua/plugins/ai/codecompanion.lua`.

## Markdown Snippets / Markdown 代码片段

| Trigger | 中文说明 | English |
| --- | --- | --- |
| `d` | 插入 DANGER callout | Insert DANGER callout |
| `s` | 插入 SUMMARY / SUCCESS callout；当前配置有重复 trigger | Insert SUMMARY / SUCCESS callout; duplicate trigger exists |
| `tl` | 插入 TLDR callout | Insert TLDR callout |
| `e` | 插入 ERROR callout | Insert ERROR callout |
| `q` | 插入 QUESTION callout | Insert QUESTION callout |
| `ib` | 插入粗斜体模板 | Insert bold-italic template |

Source / 来源: `snippets/markdown.lua`.

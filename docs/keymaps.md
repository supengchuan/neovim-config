# Neovim Keymaps / 快捷键说明

> Leader key: `<Space>` / Leader 键是空格。

Last synchronized: 2026-05-13.
最后同步时间：2026-05-13。

This document follows the current config under `lua/config`, `lua/plugins`, `lua/filetypes`, `ftplugin`, and `snippets`.
本文档依据当前 `lua/config`、`lua/plugins`、`lua/filetypes`、`ftplugin` 和 `snippets` 中的配置整理。

## Design / 设计规则

| Prefix | 中文说明 | English |
| --- | --- | --- |
| `<leader>b` | 构建、运行、CMake 工程工作流 | Build, run, and CMake project workflow |
| `<leader>G` | Go 语言工作流 | Go language workflow |
| `<leader>f` | 查找、搜索、列表 | Find, search, and lists |
| `<leader>c` | 代码动作、LSP、格式化 | Code actions, LSP, and formatting |
| `<leader>d` | 调试 | Debugging |
| `<leader>e` | 文件树、文件管理器、项目根目录 | Explorer, file manager, and project roots |
| `<leader>g` | Git | Git |
| `<leader>m` | Markdown | Markdown |
| `<leader>p` | Python | Python |
| `<leader>r` | Rust 和 Cargo | Rust and Cargo |
| `<leader>t` | 终端 | Terminal |
| `<leader>u` | UI 开关和临时状态 | UI toggles and temporary state |

Removed old mixed top-level mappings such as single-action `<leader>f`, `<leader>s`, `ff`, breakpoint `<leader>b`, `<leader>rn`, `<C-O>`, `[[`, and `]]`. Current language workflows use grouped prefixes such as `<leader>p*`, `<leader>m*`, `<leader>r*`, and `<leader>G*`.
已经移除旧的混杂顶层快捷键，例如单动作 `<leader>f`、`<leader>s`、`ff`、断点 `<leader>b`、`<leader>rn`、`<C-O>`、`[[`、`]]`。当前语言工作流使用分组前缀，例如 `<leader>p*`、`<leader>m*`、`<leader>r*`、`<leader>G*`。

## General / 通用

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>/` | Normal | 打开 which-key 快捷键总览 | Show which-key keymap overview |
| `<leader>w` | Normal | 保存当前 buffer | Save current buffer |
| `<leader>q` | Normal | 关闭当前窗口 | Quit current window |
| `<leader>Q` | Normal | 强制退出所有窗口 | Force quit all windows |
| `;n` | Normal | 取消搜索高亮 | Clear search highlight |
| `<leader>-` | Normal | 当前窗口变窄 | Make current split narrower |
| `<leader>=` | Normal | 当前窗口变宽 | Make current split wider |
| `<leader>uc` | Normal | 清空系统剪贴板寄存器 | Clear system clipboard registers |
| `<leader>uw` | Normal | 切换当前窗口自动折行 | Toggle line wrap for current window |
| `[q` | Normal | 跳到上一条 quickfix 项 | Previous quickfix item |
| `]q` | Normal | 跳到下一条 quickfix 项 | Next quickfix item |

Source / 来源: `lua/config/keymaps.lua`, `lua/plugins/editor/which-key.lua`.

## Find / 查找与导航

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>ff` | Normal | 查找文件 | Find files |
| `<leader>fb` | Normal | 切换 buffer | Switch buffers |
| `<leader>fg` | Normal | 全项目 live grep 搜索 | Search project with live grep |
| `<leader>fg` | Visual | 搜索选中的文本 | Search selected text |
| `<leader>fd` | Normal | 列出 workspace 诊断 | List workspace diagnostics |
| `<C-]>` | Normal | 跳转到定义 | Go to definition |
| `gr` | Normal | 查找引用 | Go to references |
| `gi` | Normal | 查找实现 | Go to implementations |
| `s` | Normal / Visual / Operator | Flash 快速跳转 | Jump with Flash |

Source / 来源: `lua/plugins/editor/fzf.lua`, `lua/plugins/editor/flash.lua`.

### Inside fzf-lua / fzf-lua 窗口内

| Key | 中文说明 | English |
| --- | --- | --- |
| `<C-q>` | 全选结果并发送到 quickfix | Select all results and send to quickfix |
| `<C-u>` | 向上半页 | Half-page up |
| `<C-d>` | 向下半页 | Half-page down |
| `<C-x>` | 跳转到当前项 | Jump to current item |
| `<C-f>` | 预览窗口向下翻页 | Scroll preview down |
| `<C-b>` | 预览窗口向上翻页 | Scroll preview up |
| `<F12>` | 切换预览窗口 | Toggle preview |

Source / 来源: `lua/plugins/editor/fzf.lua`.

## Code / 代码动作

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>cf` | Normal | 格式化当前文件 | Format current file |
| `<leader>cf` | Visual | 格式化选区并退出 visual mode | Format selected range and leave visual mode |
| `<leader>cd` | Normal | 打开当前行诊断浮窗 | Open diagnostic float for current line |
| `<leader>ch` | Normal | 显示 LSP hover 信息 | Show LSP hover documentation |
| `<leader>ci` | Normal | 切换 LSP inlay hints | Toggle LSP inlay hints |
| `<leader>cr` | Normal | LSP 重命名符号 | Rename symbol |
| `<leader>co` | Normal | 打开/关闭当前 buffer 符号大纲 | Toggle buffer outline |
| `<leader>c;` | Normal | 行尾补分号并新建下一行 | Add semicolon if needed and open a new line |
| `;;` | Normal / Insert, C/C++/Rust buffer | 行尾补分号并新建下一行 | Add semicolon if needed and open a new line |
| `<leader>cg` | Normal, Go buffer | 选择 Go interface 并生成实现 | Pick a Go interface and generate implementation |
| `<leader>cH` | Normal, C/C++ buffer | 在源文件和头文件之间切换 | Switch between source and header |
| `<leader>cS` | Normal, C/C++ buffer | 显示 clangd 符号信息 | Show clangd symbol info |

Source / 来源: `lua/config/keymaps.lua`, `lua/config/autocmds.lua`, `lua/plugins/coding/conform.lua`, `lua/plugins/editor/aerial.lua`, `lua/plugins/editor/which-key.lua`, `lua/plugins/lang/go-impl.lua`, `lua/filetypes/c_family.lua`.

## Build and CMake / 构建与 CMake

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>bg` | Normal | CMake generate / configure | CMake generate / configure |
| `<leader>bb` | Normal | 构建选中的 CMake target | Build selected CMake target |
| `<leader>bf` | Normal | 构建当前文件关联的 target | Build target related to current file |
| `<leader>br` | Normal | 运行选中的可执行 target | Run selected executable target |
| `<leader>bR` | Normal | 运行当前文件关联的 target | Run target related to current file |
| `<leader>bd` | Normal | 调试选中的可执行 target | Debug selected executable target |
| `<leader>bD` | Normal | 调试当前文件关联的 target | Debug target related to current file |
| `<leader>bt` | Normal | 运行 CTest 测试 | Run CTest tests |
| `<leader>bc` | Normal | 清理 CMake 构建产物 | Clean CMake build artifacts |
| `<leader>bB` | Normal | 选择构建类型，如 Debug/Release | Select build type, such as Debug/Release |
| `<leader>bT` | Normal | 选择 build target | Select build target |
| `<leader>bL` | Normal | 选择 launch target | Select launch target |
| `<leader>bp` | Normal | 选择 configure preset | Select configure preset |
| `<leader>bP` | Normal | 选择 build preset | Select build preset |
| `<leader>bk` | Normal | 选择 CMake kit | Select CMake kit |
| `<leader>bs` | Normal | 打开 CMake settings | Open CMake settings |
| `<leader>bo` | Normal | 打开 CMake executor 窗口 | Open CMake executor window |
| `<leader>bO` | Normal | 打开 CMake runner 窗口 | Open CMake runner window |
| `<leader>bx` | Normal | 停止正在运行的 CMake 任务 | Stop running CMake jobs |

Source / 来源: `lua/plugins/tools/cmake.lua`.

## Windows, Explorer, and Terminal / 窗口、文件与终端

| Key | Mode / Context | 中文说明 | English |
| --- | --- | --- | --- |
| `<C-h>` | Normal | 跳到左侧 nvim/tmux pane | Move to left nvim/tmux pane |
| `<C-j>` | Normal | 跳到下方 nvim/tmux pane | Move to lower nvim/tmux pane |
| `<C-k>` | Normal | 跳到上方 nvim/tmux pane | Move to upper nvim/tmux pane |
| `<C-l>` | Normal | 跳到右侧 nvim/tmux pane | Move to right nvim/tmux pane |
| `<C-\>` | Normal, after plugin setup | 跳回上一个活跃 nvim/tmux pane | Move to last active nvim/tmux pane |
| `<C-Space>` | Normal, after plugin setup | 跳到下一个 nvim/tmux pane | Move to next nvim/tmux pane |
| `<leader><Tab>` | Normal | 用 window-picker 选择窗口 | Pick a window |
| `<leader>M` | Normal | 启动 WinShift 移动窗口 | Move windows with WinShift |
| `<C-n>` | Normal | 打开/关闭 Neo-tree | Toggle Neo-tree |
| `<leader>ee` | Normal | 打开/关闭 Neo-tree 文件树 | Toggle Neo-tree file tree |
| `<leader>eo` | Normal | 打开/关闭 Oil 浮动文件管理器 | Toggle Oil floating file manager |
| `<leader>eg` | Normal, Go buffer | 将 Neo-tree 根目录切到 Go 项目根目录 | Set Neo-tree root to Go project root |
| `<leader>tt` | Normal | 打开/关闭 Snacks terminal | Toggle Snacks terminal |
| `<Esc>` | Snacks terminal | 隐藏 terminal | Hide terminal |

Source / 来源: `lua/plugins/editor/tmux-navigation.lua`, `lua/plugins/editor/window-picker.lua`, `lua/plugins/core.lua`, `lua/plugins/editor/neo-tree.lua`, `lua/plugins/editor/oil.lua`, `lua/filetypes/go.lua`, `lua/plugins/ui/snacks.lua`.

### Inside Neo-tree / Neo-tree 窗口内

| Key | 中文说明 | English |
| --- | --- | --- |
| `<CR>` | 打开文件或目录 | Open file or directory |
| `h` | 关闭目录节点 | Close directory node |
| `Y` | 复制文件路径到系统剪贴板 | Copy file path to system clipboard |
| `O` | 用系统应用打开 | Open with system app |
| `P` | 切换预览 | Toggle preview |
| `<C-v>` | 用窗口选择器垂直分屏打开 | Open in vertical split with window picker |
| `<Space>` | 禁用，避免误触 | Disabled to avoid accidental actions |

Source / 来源: `lua/plugins/editor/neo-tree.lua`.

### Inside Oil / Oil 窗口内

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
| `<leader>gr` | Normal | 重置当前 hunk | Reset current hunk |
| `<leader>gs` | Normal | stage 当前 hunk | Stage current hunk |
| `[g` | Normal | 跳到上一个 Git hunk | Jump to previous Git hunk |
| `]g` | Normal | 跳到下一个 Git hunk | Jump to next Git hunk |

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
| `<leader>Gc` | Normal, Go buffer | 运行当前 package 覆盖率 | Run package coverage |
| `<leader>Gd` | Normal, Go buffer | 启动 Go 调试 | Start Go debugger |
| `<leader>GD` | Normal, Go buffer | 调试光标附近测试 | Debug nearest Go test |
| `<leader>Ga` | Normal, Go buffer | 在实现文件和测试文件之间切换 | Switch implementation/test file |
| `<leader>Gv` | Normal, Go buffer | 垂直分屏打开对应实现/测试文件 | Open alternate file in vertical split |
| `<leader>Gh` | Normal, Go buffer | 查看 Go 文档浮窗 | Show Go documentation |
| `<leader>Gm` | Normal, Go/gomod buffer | 执行 go mod tidy | Run go mod tidy |
| `<leader>Gw` | Normal, gowork buffer | 执行 go work sync | Run go work sync |
| `<leader>Gi` | Normal, Go buffer | 使用自定义 interface 实现选择器 | Use custom interface implementation picker |
| `<leader>GI` | Normal, Go buffer | 调用 go.nvim 的 GoImpl | Run go.nvim GoImpl |
| `<leader>Ge` | Normal, Go buffer | 插入 if err 处理 | Insert if err block |
| `<leader>Gs` | Normal, Go buffer | 填充 struct 字段 | Fill struct fields |
| `<leader>Gj` | Normal, Go buffer | 添加 json struct tag | Add json struct tags |
| `<leader>GJ` | Normal, Go buffer | 删除 json struct tag | Remove json struct tags |
| `<leader>Gl` | Normal, Go buffer | 运行 golangci-lint | Run golangci-lint |
| `<leader>Gg` | Normal, Go buffer | 执行 go generate | Run go generate |
| `:GoMethodList` | Command, Go buffer | 列出当前 struct 的方法 | List methods for current struct |
| `:Impl` | Command, Go buffer | 使用自定义 GoImpl 流程生成 interface 实现 | Generate interface implementation with custom GoImpl flow |

Source / 来源: `lua/filetypes/go.lua`, `lua/plugins/lang/go.lua`, `lua/plugins/tools/dap.lua`, `lua/modules/goimpl`.

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
| `:PyTestFile` | Command, Python buffer | 对当前 Python 文件运行 pytest | Run pytest for current Python file |

Source / 来源: `lua/filetypes/python.lua`, `lua/plugins/lang/python.lua`.

## Rust and Cargo / Rust 与 Cargo

| Key / Command | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<leader>rb` | Normal, Rust buffer | 执行 cargo build | Run cargo build |
| `<leader>rc` | Normal, Rust buffer | 执行 cargo check | Run cargo check |
| `<leader>rC` | Normal, Rust buffer | 执行 cargo clippy --all-targets --all-features | Run cargo clippy --all-targets --all-features |
| `<leader>rr` | Normal, Rust buffer | 执行 cargo run | Run cargo run |
| `<leader>rt` | Normal, Rust buffer | 执行 cargo test | Run cargo test |
| `<leader>rR` | Normal, Rust buffer | 选择 rust-analyzer runnable | Select rust-analyzer runnable |
| `<leader>rT` | Normal, Rust buffer | 选择 rust-analyzer testable | Select rust-analyzer testable |
| `<leader>rd` | Normal, Rust buffer | 调试光标所在 runnable | Debug runnable at cursor |
| `<leader>rD` | Normal, Rust buffer | 选择可调试目标 | Select debuggable target |
| `<leader>ra` | Normal, Rust buffer | Rust 分组 code action | Rust grouped code action |
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
| `:RustCargoBuild` | Command, Rust buffer | 执行 cargo build，可追加参数 | Run cargo build with optional args |
| `:RustCargoCheck` | Command, Rust buffer | 执行 cargo check，可追加参数 | Run cargo check with optional args |
| `:RustCargoClippy` | Command, Rust buffer | 执行 cargo clippy，可追加参数 | Run cargo clippy with optional args |
| `:RustCargoRun` | Command, Rust buffer | 执行 cargo run，可追加参数 | Run cargo run with optional args |
| `:RustCargoTest` | Command, Rust buffer | 执行 cargo test，可追加参数 | Run cargo test with optional args |

Source / 来源: `lua/filetypes/rust.lua`, `lua/filetypes/toml.lua`, `lua/plugins/lang/rust.lua`, `lua/plugins/tools/dap.lua`.

Note / 说明: `<leader>ra` is context-specific. In Rust source files it opens rust-analyzer code actions; in `Cargo.toml` it updates all crates.
`<leader>ra` 是上下文相关快捷键。在 Rust 源码文件中是 rust-analyzer code action；在 `Cargo.toml` 中是更新所有 crates。

## Other Languages / 其他语言

| Key / Command | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `:LspClangdSwitchSourceHeader` | Command, C/C++ buffer | 在源文件和头文件之间切换 | Switch between source and header |
| `:LspClangdShowSymbolInfo` | Command, C/C++ buffer | 显示 clangd 符号信息 | Show clangd symbol info |

Source / 来源: `lua/config/autocmds.lua`, `lua/filetypes/c_family.lua`.

## Markdown / Markdown

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `j` | Normal, Markdown/TeX/CodeCompanion buffer | 在自动折行文本中按视觉行向下移动 | Move down by visual line when wrapped |
| `k` | Normal, Markdown/TeX/CodeCompanion buffer | 在自动折行文本中按视觉行向上移动 | Move up by visual line when wrapped |
| `<leader>mr` | Normal, Markdown buffer | 切换 Markdown 内联渲染 | Toggle inline Markdown rendering |
| `<leader>mp` | Normal, Markdown buffer | 打开 render-markdown 侧边预览 | Open render-markdown side preview |
| `<leader>mP` | Normal, Markdown buffer | 切换浏览器 Markdown 预览 | Toggle browser Markdown preview |

Source / 来源: `lua/config/autocmds.lua`, `lua/plugins/lang/markdown.lua`.

## Completion and Snippets / 补全与代码片段

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `<Tab>` | Insert / Completion | 接受当前补全项；snippet 激活时接受 snippet | Accept completion item; accept active snippet |
| `<CR>` | Insert / Completion | 接受当前补全项，来自 blink.cmp `enter` preset | Accept selected completion item from blink.cmp `enter` preset |
| `<Tab>` | Cmdline completion | 选择并接受命令行补全 | Select and accept command-line completion |
| `<C-k>` | Insert / Select | 展开 snippet 或跳到下一个占位符 | Expand snippet or jump to next placeholder |
| `<C-j>` | Insert / Select | 跳到上一个 snippet 占位符 | Jump to previous snippet placeholder |
| `<C-l>` | Insert / Select | 切换 snippet choice node | Cycle snippet choice node |

Source / 来源: `lua/plugins/coding/blinkcmp.lua`, `lua/plugins/coding/luasnip.lua`.

## Surround Defaults / nvim-surround 默认实用键

These are plugin defaults from `kylechui/nvim-surround` with `opts = {}`.
这些来自 `nvim-surround` 默认配置，当前工程未覆盖它们。

| Key | Mode | 中文说明 | English |
| --- | --- | --- | --- |
| `ys{motion}{char}` | Normal | 给 motion 范围添加包围符 | Add surrounding pair to a motion |
| `yss{char}` | Normal | 给整行添加包围符 | Add surrounding pair to the whole line |
| `S{char}` | Visual | 给选区添加包围符 | Surround visual selection |
| `ds{char}` | Normal | 删除包围符 | Delete surrounding pair |
| `cs{old}{new}` | Normal | 修改包围符 | Change surrounding pair |

Example / 示例: `ysiw"` wraps inner word with quotes; `cs"'` changes double quotes to single quotes.

## Useful Commands Without Direct Keys / 无直接快捷键但常用的命令

| Command | 中文说明 | English |
| --- | --- | --- |
| `:Theme {name}` | 切换主题，如 `:Theme catppuccin` | Switch colorscheme, e.g. `:Theme catppuccin` |
| `:Format` | 使用 Conform 格式化当前文件或选区 | Format current file or selected range |
| `:ClearX` | 清空系统剪贴板寄存器 | Clear system clipboard registers |
| `:CWD` | 将 cwd 切到当前文件目录 | Set cwd to current file directory |
| `:FoldEnable` | 启用 Treesitter fold | Enable Treesitter folding |
| `:DefSplit` | 在垂直分屏中打开定义 | Open definition in vertical split |
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

Source / 来源: `lua/config/commands.lua`, `lua/config/theme.lua`, `lua/plugins/lang/markdown.lua`, `lua/plugins/core.lua`, `lua/plugins/tools/cmake.lua`, `lua/plugins/ai/codecompanion.lua`.

## Markdown Snippets / Markdown 代码片段

| Trigger | 中文说明 | English |
| --- | --- | --- |
| `d` | 插入 DANGER callout | Insert DANGER callout |
| `s` | 插入 SUMMARY / SUCCESS callout；当前配置有重复 trigger，建议后续拆开 | Insert SUMMARY / SUCCESS callout; duplicate trigger exists |
| `tl` | 插入 TLDR callout | Insert TLDR callout |
| `e` | 插入 ERROR callout | Insert ERROR callout |
| `q` | 插入 QUESTION callout | Insert QUESTION callout |
| `ib` | 插入粗斜体模板 | Insert bold-italic template |

Source / 来源: `snippets/markdown.lua`.

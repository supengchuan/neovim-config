# Neovim Config

需要先安装 neovim, 建议安装最新的版本, 具体的安装方法可以参考: [neovim-github](https://github.com/neovim/neovim)

同时, 需要安装一些插件需要的程序, 如语言服务器: gopls, rust-analyzer 等等, 这些有些可以通过 Mason 插件进行安装.
有些需要自己手动安装.

在安装好 nvim 以及对应的工具之后; 只需要 git clone 当前项目到 ~/.config/nvim 即可

```bash
cd ~/.config/
## 需要确保 nvim 目录不存在
git clone https://github.com/supengchuan/neovim-config.git nvim

cd nvim

# first open waits for lazy.nvim and plugins
nvim init.lua
```

## structure

```text
init.lua                 主启动入口
lua/config/              基础选项、自动命令、快捷键、诊断、主题和 lazy.nvim 启动
lua/filetypes/           各文件类型的具体配置实现
ftplugin/                Neovim 文件类型自动加载入口，只做 require 转发
after/ftplugin/          文件类型后置入口，只做 require 转发
lua/modules/             可复用功能模块，如 Go interface 实现流程
lua/plugins/ai/          AI 编程插件
lua/plugins/coding/      补全、格式化、Treesitter、诊断显示
lua/plugins/editor/      文件树、搜索、窗口、Git TODO 等编辑工作流
lua/plugins/lang/        各语言专项能力
lua/plugins/tools/       DAP、CMake、Git 等工具集成
lua/plugins/ui/          主题、状态栏、通知、dashboard 等 UI
docs/                    项目文档
```

结构说明: [docs/structure.md](docs/structure.md)
快捷键文档: [docs/keymaps.md](docs/keymaps.md)

## theme

默认主题在 `lua/config/theme.lua` 里修改:

```lua
M.default = "onedark"
```

也可以用环境变量临时覆盖:

```bash
NVIM_COLOR=catppuccin nvim
```

进入 nvim 后可以用 `:Theme gruvbox` 快速切换.

## Mason / Ubuntu

Mason 工具默认不在启动时自动安装, 避免 Ubuntu 缺少系统依赖或网络不通时反复提示
`clang-format/debugpy/ruff failed to install`.

首次安装工具前, Ubuntu 建议先安装基础依赖:

```bash
sudo apt update
sudo apt install -y curl unzip tar gzip python3 python3-venv python3-pip npm build-essential
```

然后在 nvim 里运行:

```vim
:MasonToolsInstall
```

如果希望启动 nvim 时自动执行 Mason 安装, 使用:

```bash
NVIM_MASON_AUTO_INSTALL=1 nvim
```

也可以直接使用系统包绕过 Mason:

```bash
sudo apt install -y clang-format
python3 -m pip install --user ruff debugpy
```

## C / C++ / CMake

C/C++ 默认启用 `clangd` + `clang-format` + `codelldb`:

- `clangd` 负责跳转、补全、诊断、clang-tidy 和源文件/头文件切换.
- `clang-format` 负责格式化, 使用 `<leader>cf`.
- `codelldb` 负责 DAP 调试, 可用 `<leader>bd` 调试 CMake target, 或 `<F5>` 使用普通 DAP 配置.
- `cmake-tools.nvim` 负责 configure/build/run/debug/test, 统一使用 `<leader>b` 前缀.
- CMake generate 默认导出并软链接 `compile_commands.json`, 方便 `clangd` 正确识别 include path 和宏.

常用入口:

- `<leader>bg` 生成 CMake 构建系统.
- `<leader>bb` 构建当前选择的 target.
- `<leader>br` 运行当前选择的可执行 target.
- `<leader>bd` 调试当前选择的可执行 target.
- `<leader>bt` 运行 CTest.
- `<leader>bB` 选择 Debug / Release 等构建类型.
- `<leader>bT` 选择 build target, `<leader>bL` 选择 launch target.

## golang

Go 默认启用 `gopls` + `go.nvim` + `nvim-dap-go`:

- `gopls` 负责类型分析、跳转、补全、codelens、inlay hints 和 staticcheck.
- `go.nvim` 负责 Go run/build/test/coverage/tag/mod/doc 等工作流.
- `nvim-dap-go` + `delve` 负责 Go 调试.
- Mason 自动管理 `gopls`、`goimports`、`gofumpt`、`golangci-lint`、`delve`、`gomodifytags`、`gotests`、`gotestsum`、`impl`.

常用入口:

- `<leader>Gr` 运行当前 package.
- `<leader>Gb` 构建当前 package.
- `<leader>Gt` 运行测试, `<leader>Gf` 测当前文件, `<leader>Gn` 测最近测试函数.
- `<leader>Gd` 调试, `<leader>GD` 调试最近测试.
- `<leader>Gm` 执行 `go mod tidy`.
- `<leader>Gl` 运行 `golangci-lint`, `<leader>Gg` 执行 `go generate`.
- `<leader>Gi` 使用当前配置里的 interface 实现选择器.

## python

Python 默认启用 `pyright` + `ruff`:

- `pyright` 负责类型分析、跳转、补全.
- `ruff` 负责 lint、import organize 和 format.
- `debugpy` + `nvim-dap-python` 负责调试.
- `venv-selector.nvim` 用 `<leader>pv` 选择虚拟环境, `<leader>pc` 复用缓存虚拟环境.
- Python buffer 中 `<leader>pr` 运行当前文件, `<leader>pf` 对当前文件执行 pytest.

## rust

Rust 默认启用 `rustaceanvim` + `rust-analyzer` + `crates.nvim`:

- `rust-analyzer` 负责 LSP、inlay hints、proc macro、clippy check、runnables/debuggables.
- `rustaceanvim` 提供 `:RustLsp` 扩展能力, 包括 run/debug/test/code action/macro/docs.
- `crates.nvim` 在 `Cargo.toml` 中管理 crate 版本、features、升级和文档跳转.
- `codelldb` 负责 Rust DAP 调试.
- Mason 自动管理 `rust-analyzer`、`codelldb`、`taplo`.

常用入口:

- `<leader>rb` 执行 `cargo build`, `<leader>rc` 执行 `cargo check`.
- `<leader>rC` 执行 `cargo clippy --all-targets --all-features`.
- `<leader>rr` 执行 `cargo run`, `<leader>rt` 执行 `cargo test`.
- `<leader>rR` 选择 rust-analyzer runnable, `<leader>rT` 选择 testable.
- `<leader>rd` 调试光标处目标, `<leader>rD` 选择可调试目标.
- `<leader>ra` Rust code action, `<leader>rh` Rust hover actions.
- 在 `Cargo.toml` 中使用 `<leader>rv` 查看版本, `<leader>rf` 查看 features, `<leader>rU` 升级当前 crate.

## tree-sitter

如果 tree-sitter 没有找到, 需要使用 cargo 进行安装

```bash
cargo install tree-sitter-cli
```

if gcc or cc not found on windows, install LLVM by 'choco'

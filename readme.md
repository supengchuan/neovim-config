# Readme.md

需要现在 neovim, 建议安装最新的版本, 具体的安装方法可以参考: [neovim-github](https://github.com/neovim/neovim)

同时, 需要安装一些插件需要的程序, 如语言服务器: gopls, rust-analyzer 等等, 这些有些可以通过 Mason 插件进行安装.
有些需要自己手动安装. 特别是 rust-analyzer 可能需要自己进行编译

在安装好 nvim 以及对应的工具之后; 只需要 git clone 当前项目到 ~/.config/nvim 即可

```bash
cd ~/.config/
## 需要确保 nvim 目录不存在
git clone https://github.com/supengchuan/neovim-config.git nvim

cd nvim

# first open wait download packer plugin manager
nvim init.lua

# use command :PackerSync install all plugin
```

## golang

go 需要安装 gopls, 直接 go install 或者使用 Mason 安装

## rust

rust 需要安装 rust-analyzer

```bash
# on linux
mkdir -p ~/.local/bin
curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer

# add ~/.local/bin to path

# 如果 cargo run 报错
sudo apt install dpkg-config
sudo apt install libssl-dev

# if one windows
# get rust-analyzer code from github and build it
git clone https://github.com/rust-analyzer/rust-analyzer
cd rust-analyzer
cargo xtask install --server
```

## tree-sitter

如果 tree-sitter 没有找到, 需要使用 cargo 进行安装

```bash
cargo install tree-sitter-cli
```

if gcc or cc not found on windows, install LLVM by 'choco'

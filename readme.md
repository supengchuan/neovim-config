# Readme.md 

## golang

go 需要安装 gopls

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




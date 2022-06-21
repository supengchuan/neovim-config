# Readme.md 

## golang

go 需要安装 gopls

## rust

rust 需要安装 rust-analyzer
```bash
mkdir -p ~/.local/bin
curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer

# add ~/.local/bin to path

# 如果 cargo run 报错
sudo apt install dpkg-config
sudo apt install libssl-dev
```

如果 tree-sitter 没有找到, 需要使用 cargo 进行安装

```bash
cargo install tree-sitter-cli
```



au BufRead,BufNewFile *.rs set filetype=rust
au BufRead,BufNewFile Cargo.toml if &filetype == "" | set filetype=cfg | endif

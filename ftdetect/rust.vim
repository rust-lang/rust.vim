au BufRead,BufNewFile *.rs set filetype=rust
au BufRead,BufNewFile Cargo.toml if &filetype == "" | set filetype=cfg | endif

" vim: set et sw=4 sts=4 ts=8:

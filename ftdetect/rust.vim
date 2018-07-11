" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile *.rs set filetype=rust
autocmd BufRead,BufNewFile Cargo.toml if &filetype == "" | set filetype=cfg | endif

" vim: set et sw=4 sts=4 ts=8:

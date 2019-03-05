" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile *.rs setf rust
autocmd BufRead,BufNewFile Cargo.toml setf FALLBACK cfg

" vim: set et sw=4 sts=4 ts=8:

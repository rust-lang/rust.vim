augroup rustfmt
  " code formatting on save
  if get(g:, "rustfmt_autosave", 1)
    autocmd BufWritePre *.rs call rustfmt#Format()
  endif
augroup END

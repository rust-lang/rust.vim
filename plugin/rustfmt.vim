augroup rustfmt
  autocmd!

  " code formatting on save
  if get(g:, "rustfmt_autosave", 0)
    autocmd BufWritePre *.rs call rustfmt#Format()
  endif
augroup END

" Vim syntastic plugin
" Language:     Rust
" Maintainer:   Andrew Gallant <jamslam@gmail.com>
"
" See for details on how to add an external Syntastic checker:
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checker-Guide#external

if exists("g:loaded_syntastic_rust_rustc_checker")
    finish
endif
let g:loaded_syntastic_rust_rustc_checker = 1

if !exists('g:rustc_syntax_only')
    let g:rustc_syntax_only = 1 "Keep the fast behaviour by default
endif

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_rust_rustc_GetLocList() dict
    let compiler_params = g:rustc_syntax_only ? '-Zparse-only' : '-Zno-trans'
    let cwd = '.' " Don't change cwd as default
    let cargo_toml_path = findfile('Cargo.toml', '.;')
    if empty(cargo_toml_path) " Plain rs file, not a crate
        let makeprg = self.makeprgBuild({
            \ 'exe': 'rustc',
            \ 'args': compiler_params})
    else " We are inside a crate
        let makeprg = self.makeprgBuild({
            \ 'exe': 'cargo',
            \ 'args': 'rustc ' . compiler_params,
            \ 'fname': '' })
        " Change cwd to the root of the crate
        let cwd = fnamemodify( cargo_toml_path, ':p:h')
    endif

    let errorformat  =
        \ '%E%f:%l:%c: %\d%#:%\d%# %.%\{-}error:%.%\{-} %m,'   .
        \ '%W%f:%l:%c: %\d%#:%\d%# %.%\{-}warning:%.%\{-} %m,' .
        \ '%C%f:%l %m,' .
        \ '%-Z%.%#'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'cwd': cwd })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'rust',
    \ 'name': 'rustc' })

let &cpo = s:save_cpo
unlet s:save_cpo

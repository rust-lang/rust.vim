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

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_rust_rustc_GetLocList() dict
    let cwd = '.' " Don't change cwd as default
    let cargo_toml_path = findfile('Cargo.toml', '.;')
    if empty(cargo_toml_path) " Plain rs file, not a crate
        let makeprg = self.makeprgBuild({
            \ 'exe': 'rustc',
            \ 'args': '-Zno-trans' })
    else " We are inside a crate
        let makeprg = self.makeprgBuild({
            \ 'exe': 'cargo',
            \ 'args': 'rustc -Zno-trans',
            \ 'fname': '' })
        " Change cwd to the root of the crate
        let cwd = fnamemodify( cargo_toml_path, ':p:h') 
    endif

    " Old errorformat (before nightly 2016/08/10)
    let errorformat  =
        \ '%E%f:%l:%c: %\d%#:%\d%# %.%\{-}error:%.%\{-} %m,'   .
        \ '%W%f:%l:%c: %\d%#:%\d%# %.%\{-}warning:%.%\{-} %m,' .
        \ '%C%f:%l %m'
        
    " New errorformat (after nightly 2016/08/10)
    let errorformat  .=
        \ ',' .
        \ '%-G,' .
        \ '%-Gerror: aborting %.%#,' .
        \ '%-Gerror: Could not compile %.%#,' .
        \ '%Eerror: %m,' .
        \ '%Eerror[E%n]: %m,' .
        \ '%Wwarning: %m,' .
        \ '%Inote: %m,' .
        \ '%C %#--> %f:%l:%c'

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

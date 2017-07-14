" Vim syntastic plugin
" Language:     Rust
" Maintainer:   Innerand  <innerand@nxa.at>
"
" Adapted version of the rustc plugin by Andrew Gallant
"
" See for details on how to add an external Syntastic checker:
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checker-Guide#external
"

if exists("g:loaded_syntastic_rust_cargo_checker")
    finish
endif
let g:loaded_syntastic_rust_cargo_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_rust_cargo_GetLocList() dict
    let makeprg = self.makeprgBuild({
             \ 'args': 'check',
             \ 'fname': '' })

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
        \ '%-Gwarning: the option `Z` is unstable %.%#,' .
        \ '%Wwarning: %m,' .
        \ '%Inote: %m,' .
        \ '%C %#--> %f:%l:%c'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'rust',
    \ 'name': 'cargo'})

let &cpo = s:save_cpo
unlet s:save_cpo

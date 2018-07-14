" Vim indent file
" Language:         Rust
" Author:           Chris Morgan <me@chrismorgan.info>
" Last Change:      2018 Jan 10
" For bugs, patches and license go to https://github.com/rust-lang/rust.vim

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal cindent
setlocal cinoptions=L0,(0,Ws,J1,j1,m1
setlocal cinkeys=0{,0},!^F,o,O,0[,0]
" Don't think cinwords will actually do anything at all... never mind
setlocal cinwords=for,if,else,while,loop,impl,mod,unsafe,trait,struct,enum,fn,extern,macro

" Some preliminary settings
setlocal nolisp		" Make sure lisp indenting doesn't supersede us
setlocal autoindent	" indentexpr isn't much help otherwise
" Also do indentkeys, otherwise # gets shoved to column 0 :-/
setlocal indentkeys=0{,0},!^F,o,O,0[,0]

setlocal indentexpr=GetRustIndent(v:lnum)

" Only define the function once.
if exists("*GetRustIndent")
    finish
endif

" vint: -ProhibitAbbreviationOption
let s:save_cpo = &cpo
set cpo&vim
" vint: +ProhibitAbbreviationOption

function GetRustIndent(lnum)
    return rust#indent#Indent(a:lnum)
endfunction

" vint: -ProhibitAbbreviationOption
let &cpo = s:save_cpo
unlet s:save_cpo
" vint: +ProhibitAbbreviationOption

" vim: set et sw=4 sts=4 ts=8:

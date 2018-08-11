" vint: -ProhibitAbbreviationOption
let s:save_cpo = &cpo
set cpo&vim
" vint: +ProhibitAbbreviationOption

if exists('*shiftwidth')
    function! s:shiftwidth()
        return shiftwidth()
    endfunc
else
    function! s:shiftwidth()
        return &shiftwidth
    endfunc
endif

let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

if has("pythonx")
    function! PythonXRustIndent()
        pythonx << EOF
import sys, vim
from os.path import normpath, join

# Prepare import paths
plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, 'indent'))
sys.path.insert(0, python_root_dir)

import rust_indent
def rust_indent_func(start_line, lnum, shiftwidth):
    cb = vim.current.buffer
    return rust_indent.get_line_indent(cb, start_line, lnum, cb.number, shiftwidth)
EOF
    endfunction

    call PythonXRustIndent()
elseif has("python")
    function! PythonRustIndent()
        python << EOF
import sys, vim
from os.path import normpath, join

# Prepare import paths
plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, 'indent'))
sys.path.insert(0, python_root_dir)

import rust_indent
def rust_indent_func(start_line, lnum, shiftwidth):
    cb = vim.current.buffer
    return rust_indent.get_line_indent(cb, start_line, lnum, cb.number, shiftwidth)
EOF
    endfunction

    call PythonRustIndent()
endif

" Fallback indentation written in VimL, in case Python is not supported.

function! s:get_line_trimmed(lnum)
    " Get the line and remove a trailing comment.
    " Use syntax highlighting attributes when possible.
    " NOTE: this is not accurate; /* */ or a line continuation could trick it
    let line = getline(a:lnum)
    let line_len = strlen(line)
    if has('syntax_items')
        " If the last character in the line is a comment, do a binary search for
        " the start of the comment.  synID() is slow, a linear search would take
        " too long on a long line.
        if synIDattr(synID(a:lnum, line_len, 1), "name") =~? 'Comment\|Todo'
            let min = 1
            let max = line_len
            while min < max
                let col = (min + max) / 2
                if synIDattr(synID(a:lnum, col, 1), "name") =~? 'Comment\|Todo'
                    let max = col
                else
                    let min = col + 1
                endif
            endwhile
            let line = strpart(line, 0, min - 1)
        endif
        return substitute(line, "\s*$", "", "")
    else
        " Sorry, this is not complete, nor fully correct (e.g. string "//").
        " Such is life.
        return substitute(line, "\s*//.*$", "", "")
    endif
endfunction

function! s:is_string_comment(lnum, col)
    if has('syntax_items')
        for id in synstack(a:lnum, a:col)
            let synname = synIDattr(id, "name")
            if synname ==# "rustString" || synname =~# "^rustComment"
                return 1
            endif
        endfor
    else
        " without syntax, let's not even try
        return 0
    endif
endfunction

function! s:VimLRustIndent(lnum)
    " Starting assumption: cindent (called at the end) will do it right
    " normally. We just want to fix up a few cases.

    let line = getline(a:lnum)

    if has('syntax_items')
        let synname = synIDattr(synID(a:lnum, 1, 1), "name")
        if synname ==# "rustString"
            " If the start of the line is in a string, don't change the indent
            return -1
        elseif synname =~? '\(Comment\|Todo\)'
                    \ && line !~# '^\s*/\*'  " not /* opening line
            if synname =~? "CommentML" " multi-line
                if line !~# '^\s*\*' && getline(a:lnum - 1) =~# '^\s*/\*'
                    " This is (hopefully) the line after a /*, and it has no
                    " leader, so the correct indentation is that of the
                    " previous line.
                    return GetRustIndent(a:lnum - 1)
                endif
            endif
            " If it's in a comment, let cindent take care of it now. This is
            " for cases like "/*" where the next line should start " * ", not
            " "* " as the code below would otherwise cause for module scope
            " Fun fact: "  /*\n*\n*/" takes two calls to get right!
            return cindent(a:lnum)
        endif
    endif

    " cindent gets second and subsequent match patterns/struct members wrong,
    " as it treats the comma as indicating an unfinished statement::
    "
    " match a {
    "     b => c,
    "         d => e,
    "         f => g,
    " };

    " Search backwards for the previous non-empty line.
    let prevlinenum = prevnonblank(a:lnum - 1)
    let prevline = s:get_line_trimmed(prevlinenum)
    while prevlinenum > 1 && prevline !~# '[^[:blank:]]'
        let prevlinenum = prevnonblank(prevlinenum - 1)
        let prevline = s:get_line_trimmed(prevlinenum)
    endwhile

    " Handle where clauses nicely: subsequent values should line up nicely.
    if prevline[len(prevline) - 1] ==# ","
                \ && prevline =~# '^\s*where\s'
        return indent(prevlinenum) + 6
    endif

    if prevline[len(prevline) - 1] ==# ","
                \ && s:get_line_trimmed(a:lnum) !~# '^\s*[\[\]{}]'
                \ && prevline !~# '^\s*fn\s'
                \ && prevline !~# '([^()]\+,$'
                \ && s:get_line_trimmed(a:lnum) !~# '^\s*\S\+\s*=>'
        " Oh ho! The previous line ended in a comma! I bet cindent will try to
        " take this too far... For now, let's normally use the previous line's
        " indent.

        " One case where this doesn't work out is where *this* line contains
        " square or curly brackets; then we normally *do* want to be indenting
        " further.
        "
        " Another case where we don't want to is one like a function
        " definition with arguments spread over multiple lines:
        "
        " fn foo(baz: Baz,
        "        baz: Baz) // <-- cindent gets this right by itself
        "
        " Another case is similar to the previous, except calling a function
        " instead of defining it, or any conditional expression that leaves
        " an open paren:
        "
        " foo(baz,
        "     baz);
        "
        " if baz && (foo ||
        "            bar) {
        "
        " Another case is when the current line is a new match arm.
        "
        " There are probably other cases where we don't want to do this as
        " well. Add them as needed.
        return indent(prevlinenum)
    endif

    if !has("patch-7.4.355")
        " cindent before 7.4.355 doesn't do the module scope well at all; e.g.::
        "
        " static FOO : &'static [bool] = [
        " true,
        "	 false,
        "	 false,
        "	 true,
        "	 ];
        "
        "	 uh oh, next statement is indented further!

        " Note that this does *not* apply the line continuation pattern properly;
        " that's too hard to do correctly for my liking at present, so I'll just
        " start with these two main cases (square brackets and not returning to
        " column zero)

        call cursor(a:lnum, 1)
        if searchpair('{\|(', '', '}\|)', 'nbW',
                    \ 's:is_string_comment(line("."), col("."))') == 0
            if searchpair('\[', '', '\]', 'nbW',
                        \ 's:is_string_comment(line("."), col("."))') == 0
                " Global scope, should be zero
                return 0
            else
                " At the module scope, inside square brackets only
                "if getline(a:lnum)[0] == ']' || search('\[', '', '\]', 'nW') == a:lnum
                if line =~# "^\\s*]"
                    " It's the closing line, dedent it
                    return 0
                else
                    return &shiftwidth
                endif
            endif
        endif
    endif

    " Fall back on cindent, which does it mostly right
    return cindent(a:lnum)
endfunction

function s:calc_start_line()
    let l:num = search('\V\n}\n', "nbW")
    if l:num != 0
        " After the end of a top-level block.
        let l:num += 2
    else
        " Start of the buffer.
        let l:num = 1
    endif
    return string(l:num)
endfunction

function! rust#indent#Indent(lnum) abort
    if has("pythonx")
        let b:rust_indent_used = "pythonx"
        return pyxeval('rust_indent_func('.s:calc_start_line().', '.string(a:lnum).', '.string(s:shiftwidth()).')')
    elseif has("python")
        let b:rust_indent_used = "python"
        return pyeval('rust_indent_func('.s:calc_start_line().','.string(a:lnum).', '.string(s:shiftwidth()).')')
    else
        let b:rust_indent_used = "VimL"
        return s:VimLRustIndent(a:lnum)
    endif
endfunction

" vint: -ProhibitAbbreviationOption
let &cpo = s:save_cpo
unlet s:save_cpo
" vint: +ProhibitAbbreviationOption

" vim: set et sw=4 sts=4 ts=8:

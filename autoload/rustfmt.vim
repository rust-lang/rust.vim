" Author: Stephen Sugden <stephen@stephensugden.com>
"
" Adapted from https://github.com/fatih/vim-go
" For bugs, patches and license go to https://github.com/rust-lang/rust.vim

if !exists("g:rustfmt_autosave")
    let g:rustfmt_autosave = 0
endif

if !exists("g:rustfmt_command")
    let g:rustfmt_command = "rustfmt"
endif

if !exists("g:rustfmt_options")
    let g:rustfmt_options = ""
endif

if !exists("g:rustfmt_fail_silently")
    let g:rustfmt_fail_silently = 0
endif

if !exists("g:rustfmt_emitmode_legacy")
    let g:rustfmt_emitmode_legacy = 0
endif

if !exists("g:rustfmt_format_range")
    let g:rustfmt_format_range = 0
endif

if !exists("g:rustfmt_use_configfile")
    let g:rustfmt_use_configfile = 0
endif

let s:got_fmt_error = 0

function! rustfmt#Load()
    " Utility call to get this script loaded, for debugging
endfunction

function! s:RustfmtWriteMode()
    if g:rustfmt_emitmode_legacy == 0
        return "--emit=files"
    else
        return "--write-mode=overwrite"
    endif
endfunction

function! rustfmt#RustfmtConfigOptions()
    let l:default_config = '--edition 2018'
    if g:rustfmt_use_configfile == 0
        return l:default_config
    endif

    let l:rustfmt_conf_names = ['rustfmt.toml', '.rustfmt.toml']
    for l:rustfmt_conf_name in l:rustfmt_conf_names
        let l:rustfmt_toml = findfile(l:rustfmt_conf_name, expand('%:p:h') . ';')
        if l:rustfmt_toml !=# ''
            return '--config-path '.shellescape(fnamemodify(l:rustfmt_toml, ":p"))
        endif
    endfor

    " configuration file not found, fallback to default
    return l:default_config
endfunction

function! s:RustfmtCommandRange(filename, line1, line2)
    if g:rustfmt_format_range == 0
        return
    endif

    let l:arg = {"file": shellescape(a:filename), "range": [a:line1, a:line2]}
    let l:write_mode = s:RustfmtWriteMode()
    let l:rustfmt_config = rustfmt#RustfmtConfigOptions()

    " FIXME: When --file-lines gets to be stable, add version range checking
    " accordingly.
    let l:unstable_features = '--unstable-features'

    let l:cmd = printf("%s %s %s %s %s --file-lines '[%s]' %s", g:rustfmt_command,
                \ l:write_mode, g:rustfmt_options,
                \ l:unstable_features, l:rustfmt_config,
                \ json_encode(l:arg), shellescape(a:filename))
    return l:cmd
endfunction

function! s:RustfmtCommand()
    let write_mode = g:rustfmt_emitmode_legacy == 0 ? '--emit=stdout' : '--write-mode=display'
    let config = rustfmt#RustfmtConfigOptions()
    return join([g:rustfmt_command, write_mode, config, g:rustfmt_options])
endfunction

function! s:DeleteLines(start, end) abort
    silent! execute a:start . ',' . a:end . 'delete _'
endfunction

function! s:RunRustfmt(command, tmpname, from_writepre)
    let l:view = winsaveview()

    let l:stderr_tmpname = tempname()
    call writefile([], l:stderr_tmpname)

    let l:command = a:command . ' 2> ' . l:stderr_tmpname

    if a:tmpname ==# ''
        " Rustfmt in stdin/stdout mode

        " chdir to the directory of the file
        let l:has_lcd = haslocaldir()
        let l:prev_cd = getcwd()
        execute 'lchdir! '.expand('%:h')

        let l:buffer = getline(1, '$')
        if exists("*systemlist")
            silent let out = systemlist(l:command, l:buffer)
        else
            silent let out = split(system(l:command,
                        \ join(l:buffer, "\n")), '\r\?\n')
        endif
    else
        if exists("*systemlist")
            silent let out = systemlist(l:command)
        else
            silent let out = split(system(l:command), '\r\?\n')
        endif
    endif

    let l:stderr = readfile(l:stderr_tmpname)

    call delete(l:stderr_tmpname)

    let l:open_lwindow = 0
    if v:shell_error == 0
        if a:from_writepre
            " remove undo point caused via BufWritePre
            try | silent undojoin | catch | endtry
        endif

        if a:tmpname ==# ''
            let l:content = l:out
        else
            " take the tmpfile's content, this is better than rename
            " because it preserves file modes.
            let l:content = readfile(a:tmpname)
        endif

        call s:DeleteLines(len(l:content), line('$'))
        call setline(1, l:content)

        " only clear location list if it was previously filled to prevent
        " clobbering other additions
        if s:got_fmt_error
            let s:got_fmt_error = 0
            call setloclist(0, [])
            let l:open_lwindow = 1
        endif
    elseif g:rustfmt_fail_silently == 0 && !a:from_writepre
        " otherwise get the errors and put them in the location list
        let l:errors = []

        let l:prev_line = ""
        for l:line in l:stderr
            " error: expected one of `;` or `as`, found `extern`
            "  --> src/main.rs:2:1
            let tokens = matchlist(l:line, '^\s\+-->\s\(.\{-}\):\(\d\+\):\(\d\+\)$')
            if !empty(tokens)
                call add(l:errors, {"filename": @%,
                            \"lnum":	tokens[2],
                            \"col":	tokens[3],
                            \"text":	l:prev_line})
            endif
            let l:prev_line = l:line
        endfor

        if !empty(l:errors)
            call setloclist(0, l:errors, 'r')
            echohl Error | echomsg "rustfmt returned error" | echohl None
        else
            echo "rust.vim: was not able to parse rustfmt messages. Here is the raw output:"
            echo "\n"
            for l:line in l:stderr
                echo l:line
            endfor
        endif

        let s:got_fmt_error = 1
        let l:open_lwindow = 1
    endif

    " Restore the current directory if needed
    if a:tmpname ==# ''
        if l:has_lcd
            execute 'lchdir! '.l:prev_cd
        else
            execute 'chdir! '.l:prev_cd
        endif
    endif

    " Open lwindow after we have changed back to the previous directory
    if l:open_lwindow == 1
        lwindow
    endif

    call winrestview(l:view)
endfunction

function! rustfmt#FormatRange(line1, line2)
    let l:tmpname = tempname()
    call writefile(getline(1, '$'), l:tmpname)
    let command = s:RustfmtCommandRange(l:tmpname, a:line1, a:line2)
    call s:RunRustfmt(command, l:tmpname, v:false)
    call delete(l:tmpname)
endfunction

function! rustfmt#Format()
    call s:RunRustfmt(s:RustfmtCommand(), '', v:false)
endfunction

function! rustfmt#Cmd()
    " Mainly for debugging
    return s:RustfmtCommand()
endfunction

function! rustfmt#PreWrite()
    if !filereadable(expand("%@"))
        return
    endif
    if rust#GetConfigVar('rustfmt_autosave_if_config_present', 0)
        if findfile('rustfmt.toml', '.;') !=# '' || findfile('.rustfmt.toml', '.;') !=# ''
            let b:rustfmt_autosave = 1
            let b:_rustfmt_autosave_because_of_config = 1
        endif
    else
        if has_key(b:, '_rustfmt_autosave_because_of_config')
            unlet b:_rustfmt_autosave_because_of_config
            unlet b:rustfmt_autosave
        endif
    endif

    if !rust#GetConfigVar("rustfmt_autosave", 0)
        return
    endif

    call s:RunRustfmt(s:RustfmtCommand(), '', v:true)
endfunction


" vim: set et sw=4 sts=4 ts=8:

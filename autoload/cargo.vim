function! cargo#Load()
    " Utility call to get this script loaded, for debugging
endfunction

function! cargo#cmd(args) abort
    " Trim trailing spaces. This is necessary since :terminal command parses
    " trailing spaces as an empty argument.
    let args = substitute(a:args, '\s\+$', '', '')
    if exists('g:cargo_shell_command_runner')
        let cmd = g:cargo_shell_command_runner
    elseif has('terminal')
        let cmd = 'terminal'
    elseif has('nvim')
        let cmd = 'noautocmd new | terminal'
    else
        let cmd = '!'
    endif
    execute cmd 'cargo' args
endfunction

function! s:nearest_cargo(...) abort
    " If the second argument is not specified, the first argument determines
    " whether we will start from the current directory or the directory of the
    " current buffer, otherwise, we start with the provided path on the 
    " second argument.

    let l:is_getcwd = get(a:, 1, 0)
    if l:is_getcwd 
        let l:starting_path = get(a:, 2, getcwd())
    else
        let l:starting_path = get(a:, 2, expand('%:p:h'))
    endif

    return findfile('Cargo.toml', l:starting_path . ';')
endfunction

function! cargo#nearestCargo(is_getcwd) abort
    return s:nearest_cargo(a:is_getcwd)
endfunction

function! cargo#nearestWorkspaceCargo(is_getcwd) abort
    " Workspaces can be defined by two formats:
    " Inline tables:
    "
    " workspace = { resolver = "2", members = [ "subcrate1", "subcrate2" ] }
    "
    " Normal tables
    "
    " [workspace]
    " resolver = "2"
    " members = [ "subcrate1", "subcrate2" ]
    "
    " We must take care in parsing the inline tables. It is only a valid
    " workspace config if it's in the top level of the config. We don't want
    " to accidentally capture entries named 'workspace' inside tables, for
    " example:
    "
    " [dependencies]
    " workspace = "0.4.2"
    let l:nearest = s:nearest_cargo(a:is_getcwd)
    while l:nearest !=# ''
        let l:top_level_config = 1
        for l:line in readfile(l:nearest, '', 0x100)
            if l:line =~# '^\s*['
                " Found some table definition, we're no longer parsing the top
                " level config
                let l:top_level_config = 0
            endif
            if l:line =~# '\s*workspace\s*='
                if l:top_level_config
                    " workspace using inline table format
                    return l:nearest
                endif
            endif
            if l:line =~# '\V[workspace]'
                " workspace using normal table format
                return l:nearest
            endif
        endfor
        let l:next = fnamemodify(l:nearest, ':p:h:h')
        let l:nearest = s:nearest_cargo(0, l:next)
    endwhile
    return ''
endfunction

function! cargo#nearestRootCargo(is_getcwd) abort
    " Try to find a workspace Cargo.toml, and if not found, take the nearest
    " regular Cargo.toml
    let l:workspace_cargo = cargo#nearestWorkspaceCargo(a:is_getcwd)
    if l:workspace_cargo !=# ''
        return l:workspace_cargo
    endif
    return s:nearest_cargo(a:is_getcwd)
endfunction


function! cargo#build(args)
    call cargo#cmd("build " . a:args)
endfunction

function! cargo#check(args)
    call cargo#cmd("check " . a:args)
endfunction

function! cargo#clean(args)
    call cargo#cmd("clean " . a:args)
endfunction

function! cargo#doc(args)
    call cargo#cmd("doc " . a:args)
endfunction

function! cargo#new(args)
    call cargo#cmd("new " . a:args)
    cd `=a:args`
endfunction

function! cargo#init(args)
    call cargo#cmd("init " . a:args)
endfunction

function! cargo#run(args)
    call cargo#cmd("run " . a:args)
endfunction

function! cargo#test(args)
    call cargo#cmd("test " . a:args)
endfunction

function! cargo#bench(args)
    call cargo#cmd("bench " . a:args)
endfunction

function! cargo#update(args)
    call cargo#cmd("update " . a:args)
endfunction

function! cargo#search(args)
    call cargo#cmd("search " . a:args)
endfunction

function! cargo#publish(args)
    call cargo#cmd("publish " . a:args)
endfunction

function! cargo#install(args)
    call cargo#cmd("install " . a:args)
endfunction

function! cargo#runtarget(args)
    let l:filename = expand('%:p')
    let l:read_manifest = system('cargo read-manifest')
    let l:metadata = json_decode(l:read_manifest)
    let l:targets = get(l:metadata, 'targets', [])
    let l:did_run = 0
    for l:target in l:targets
        let l:src_path = get(l:target, 'src_path', '')
        let l:kinds = get(l:target, 'kind', [])
        let l:name = get(l:target, 'name', '')
        if l:src_path == l:filename
        if index(l:kinds, 'example') != -1
            let l:did_run = 1
            call cargo#run("--example " . shellescape(l:name) . " " . a:args)
            return
        elseif index(l:kinds, 'bin') != -1
            let l:did_run = 1
            call cargo#run("--bin " . shellescape(l:name) . " " . a:args)
            return
        endif
        endif
    endfor
    if l:did_run != 1
        call cargo#run(a:args)
        return
    endif
endfunction

" vim: set et sw=4 sts=4 ts=8:

function! cargo#cmd(args)
    execute "!" . "cargo ". a:args
endfunction

function! cargo#build(args)
    if !a:args
        execute "!" . "cargo build " . a:args
    else
        execute "!" . "cargo build"
    endif
    execute "!" . "cargo build"
endfunction

function! cargo#clean(args)
    if !a:args
        execute "!" . "cargo clean " . a:args
    else
        execute "!" . "cargo clean"
    endif
    execute "!" . "cargo clean"
endfunction

function! cargo#doc(args)
    if !a:args
        execute "!" . "cargo doc " . a:args
    else
        execute "!" . "cargo doc"
    endif
endfunction

function! cargo#new(args)
    execute "!cargo new " . a:args
    cd `=a:args`
endfunction

function! cargo#init(args)
    if !a:args
        execute "!" . "cargo init " . a:args
    else
        execute "!" . "cargo init"
    endif
endfunction

function! cargo#run(args)
    if !a:args
        execute "!" . "cargo run " . a:args
    else
        execute "!" . "cargo run"
    endif
endfunction

function! cargo#test(args)
    if !a:args
        execute "!" . "cargo test " . a:args
    else
        execute "!" . "cargo test"
    endif
endfunction

function! cargo#bench(args)
    if !a:args
        execute "!" . "cargo bench " . a:args
    else
        execute "!" . "cargo bench"
    endif
endfunction

function! cargo#cmd(args)
    execute "! cargo" a:args
endfunction

function! cargo#build(args)
    call cargo#cmd("build " . a:args)
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

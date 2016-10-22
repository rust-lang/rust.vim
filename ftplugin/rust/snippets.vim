if exists("g:rustg_loaded_rustsnippets")
  finish
endif
let g:rust_loaded_rustsnippets = 1

" by default UltiSnips
if !exists("g:rust_snippet_engine")
  let g:rust_snippet_engine = "ultisnips"
endif

function! s:RustUltiSnips()
  if globpath(&rtp, 'plugin/UltiSnips.vim') == ""
    return
  endif

  if !exists("g:UltiSnipsSnippetDirectories")
    let g:UltiSnipsSnippetDirectories = ["rustsnippets/UltiSnips"]
  else
    let g:UltiSnipsSnippetDirectories += ["rustsnippets/UltiSnips"]
  endif
endfunction

function! s:RustNeosnippet()
  if globpath(&rtp, 'plugin/neosnippet.vim') == ""
    return
  endif

  let g:neosnippet#enable_snipmate_compatibility = 1

  let rustsnippets_dir = globpath(&rtp, 'rustsnippets/snippets')
  if type(g:neosnippet#snippets_directory) == type([])
    let g:neosnippet#snippets_directory += [rustsnippets_dir]
  elseif type(g:neosnippet#snippets_directory) == type("")
    if strlen(g:neosnippet#snippets_directory) > 0
      let g:neosnippet#snippets_directory = g:neosnippet#snippets_directory . "," . rustsnippets_dir
    else
      let g:neosnippet#snippets_directory = rustsnippets_dir
    endif
  endif
endfunction

if g:rust_snippet_engine == "ultisnips"
  call s:RustUltiSnips()
elseif g:rust_snippet_engine == "neosnippet"
  call s:RustNeosnippet()
endif

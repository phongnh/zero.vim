let s:escape_characters = '\\\^$.*+?()[]{}|- '

function! s:Escape(text) abort
    return escape(a:text, s:escape_characters)
endfunction

function! zero#suggest#Escape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#suggest#Input(...) abort
    let l:prompt = get(a:, 1, 'VimSuggest: ')
    return s:Escape(input(l:prompt)) . ' '
endfunction

function! zero#suggest#CCword(...) abort
    return s:Escape(zero#CCword())
endfunction

function! zero#suggest#Cword() abort
    return zero#Cword()
endfunction

function! zero#suggest#Word() abort
    return s:Escape(zero#Word())
endfunction

function! zero#suggest#Vword() range abort
    return s:Escape(zero#Vword())
endfunction

function! zero#suggest#Pword() abort
    return s:Escape(zero#Pword())
endfunction

function! zero#suggest#LastSearch() abort
    let text = get(g:, 'vimsuggest_lastsearch', '')
    " Last search has been already escaped, just need to escape space.
    return escape(text, ' ')
endfunction

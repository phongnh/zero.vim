let s:escape_characters = '\^$.*+?()[]{}|- '

function! s:Escape(text) abort
    return escape(a:text, s:escape_characters)
endfunction

function! zero#ferret#Escape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#ferret#Input(...) abort
    let l:prompt = get(a:, 1, 'Ferret: ')
    return s:Escape(input(l:prompt)) . ' '
endfunction

function! zero#ferret#CCword(...) abort
    if get(a:, 1, 0)
        return '-w ' . zero#Cword()
    else
        return shellescape(zero#CCword())
    endif
endfunction

function! zero#ferret#Cword() abort
    return zero#Cword()
endfunction

function! zero#ferret#Word() abort
    return s:Escape(zero#Word())
endfunction

function! zero#ferret#Vword() range abort
    return s:Escape(zero#Vword())
endfunction

function! zero#ferret#Pword() abort
    return s:Escape(zero#Pword())
endfunction

function! zero#ferret#LastSearch() abort
    let text = get(g:, 'ferret_lastsearch', '')
    " Last search has been already escaped, just need to escape space.
    return escape(text, ' ')
endfunction

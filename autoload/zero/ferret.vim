let s:escape_characters = '\^$.*+?()[]{}|- '

function! s:Escape(text) abort
    return escape(a:text, s:escape_characters)
endfunction

function! zero#ferret#CCword(...) abort
    if get(a:, 1, 0)
        return '-w ' . zero#Cword()
    else
        return zero#CCword()
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

function! zero#ferret#Pword()abort
    return s:Escape(zero#Pword())
endfunction

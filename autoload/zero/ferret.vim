let s:ferret_escape_characters = '() '

function! s:FerretEscapeCharacters(text) abort
    return escape(a:text, s:ferret_escape_characters)
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
    return s:FerretEscapeCharacters(zero#Word())
endfunction

function! zero#ferret#Vword() abort
    return s:FerretEscapeCharacters(zero#Vword())
endfunction

function! zero#ferret#Pword()abort
    return s:FerretEscapeCharacters(zero#Pword())
endfunction

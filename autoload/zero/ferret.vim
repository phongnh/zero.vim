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
    return zero#Word()
endfunction

function! zero#ferret#Vword() abort
    return escape(zero#Vword(), ' ')
endfunction

function! zero#ferret#Pword() abort
    return escape(zero#Pword(), ' ')
endfunction

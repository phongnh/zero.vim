function! zero#ferret#CCword(...) abort
    return call('zero#CCword', a:000)
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

function! zero#ferret#Pword()abort
    return escape(zero#Pword(), ' ')
endfunction

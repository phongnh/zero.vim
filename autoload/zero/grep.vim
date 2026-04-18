function! s:Escape(text) abort
    return shellescape(l:text)
endfunction

function! zero#grep#Escape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#grep#CCword() abort
    return s:Escape(zero#CCword())
endfunction

function! zero#grep#Cword() abort
    return s:Escape(zero#Cword())
endfunction

function! zero#grep#Word() abort
    return s:Escape(zero#Word())
endfunction

function! zero#grep#Vword() range abort
    return s:Escape(zero#Vword())
endfunction

function! zero#grep#Visual() range abort
    return s:Escape(zero#Visual())
endfunction

function! zero#grep#Pword() abort
    return s:Escape(zero#Pword())
endfunction

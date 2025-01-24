let s:escape_characters = '\^$.*+?()[]{}|-'

function! s:Escape(text) abort
    return shellescape(escape(a:text, s:escape_characters))
endfunction

function! zero#grepper#Escape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#grepper#Input(...) abort
    let l:prompt = get(a:, 1, 'Grepper: ')
    return s:Escape(input(l:prompt)) . ' '
endfunction

function! zero#grepper#CCword(...) abort
    return shellescape(zero#CCword())
endfunction

function! zero#grepper#Cword() abort
    return shellescape(zero#Cword())
endfunction

function! zero#grepper#Word() abort
    return s:Escape(zero#Word())
endfunction

function! zero#grepper#Vword() range abort
    return s:Escape(zero#Vword())
endfunction

function! zero#grepper#Pword() abort
    return s:Escape(zero#Pword())
endfunction

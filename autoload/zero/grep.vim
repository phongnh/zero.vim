let s:escape_characters = '^$.*+?()[]{}|-'

function! s:Escape(text) abort
    " Escape alternative file
    let l:text = substitute(a:text, '#', '\\\\#', 'g')
    let l:text = escape(l:text, s:escape_characters)
    return shellescape(l:text)
endfunction

function! zero#grep#Escape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#grep#Input(...) abort
    let l:prompt = get(a:, 1, 'Grep: ')
    return s:Escape(input(l:prompt)) . ' '
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

function! zero#grep#Pword() abort
    return s:Escape(zero#Pword())
endfunction

function! zero#grep#Escape(text) abort
    return s:Escape(a:text)
endfunction

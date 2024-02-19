let s:escape_characters = '\^$.*+?()[]{}|-'

function! s:Escape(text) abort
    return shellescape(escape(a:text, s:escape_characters))
endfunction

function! zero#shell#Escape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#shell#Input(...) abort
    let l:prompt = get(a:, 1, 'Shell: ')
    return s:Escape(input(l:prompt)) . ' '
endfunction

function! zero#shell#CCword() abort
    return s:Escape(zero#CCword())
endfunction

function! zero#shell#Cword() abort
    return zero#Cword()
endfunction

function! zero#shell#Word() abort
    return s:Escape(zero#Word())
endfunction

function! zero#shell#Vword() range abort
    let text = zero#Strip(zero#Vword())
    return s:Escape(text)
endfunction

function! zero#shell#Pword() abort
    let text = zero#Strip(zero#Pword())
    return s:Escape(text)
endfunction

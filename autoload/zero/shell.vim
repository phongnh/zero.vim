let s:escape_characters = '\^$.*+?()[]{}|-'

function! s:Escape(text) abort
    return escape(a:text, s:escape_characters)
endfunction

function! s:ShellEscape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#shell#CCword() abort
    return zero#CCword()
endfunction

function! zero#shell#Cword() abort
    return zero#Cword()
endfunction

function! zero#shell#Word() abort
    return s:ShellEscape(zero#Word())
endfunction

function! zero#shell#Vword() range abort
    let text = zero#Strip(zero#Vword())
    return s:ShellEscape(text)
endfunction

function! zero#shell#Pword() abort
    let text = zero#Strip(zero#Pword())
    return s:ShellEscape(text)
endfunction

let s:escape_characters = '\^$.*+?()[]{}|-'

function! s:Shellescape(text) abort
    let l:shell = &shell
    try
        let &shell = 'sh'
        return shellescape(a:text)
    finally
        let &shell = l:shell
    endtry
endfunction

function! zero#grepper#Shellescape(text) abort
    return s:Shellescape(a:text)
endfunction

function! s:Escape(text) abort
    return s:Shellescape(escape(a:text, s:escape_characters))
endfunction

function! zero#grepper#Escape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#grepper#Input(...) abort
    let l:prompt = get(a:, 1, 'Shell: ')
    return s:Escape(input(l:prompt)) .. ' '
endfunction

function! zero#grepper#CCword() abort
    return shellescape(zero#CCword())
endfunction

function! zero#grepper#Cword() abort
    return shellescape(zero#Cword())
endfunction

function! zero#grepper#Word() abort
    return s:Escape(zero#Word())
endfunction

function! zero#grepper#Vword() range abort
    let l:text = zero#Trim(zero#Vword())
    return s:Escape(l:text)
endfunction

function! zero#grepper#Pword() abort
    let l:text = zero#Trim(zero#Pword())
    return s:Escape(l:text)
endfunction

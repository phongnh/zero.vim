let s:escape_characters = '\^$.*+?()[]{}|-"'

function! s:Escape(text) abort
    return shellescape(escape(a:text, s:escape_characters))
endfunction

function! zero#leaderf#Escape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#leaderf#Input(...) abort
    let l:prompt = get(a:, 1, 'LeaderF: ')
    return s:Escape(input(l:prompt)) . ' '
endfunction

function! zero#leaderf#CCword() abort
    return s:Escape(zero#CCword())
endfunction

function! zero#leaderf#Cword() abort
    return zero#Cword()
endfunction

function! zero#leaderf#Word() abort
    return s:Escape(zero#Word())
endfunction

function! zero#leaderf#Vword() range abort
    let text = zero#Strip(zero#Vword())
    return s:Escape(text)
endfunction

function! zero#leaderf#Pword() abort
    let text = zero#Strip(zero#Pword())
    return s:Escape(text)
endfunction

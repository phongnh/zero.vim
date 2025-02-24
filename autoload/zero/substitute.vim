" Escape regex characters
let s:escape_characters = '^$.*\/~[]'

function! s:Escape(text) abort
    let text = escape(a:text, s:escape_characters)
    " Escape the line endings
    return substitute(text, '\n', '\\n', 'g')
endfunction

function! zero#substitute#Escape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#substitute#Input(...) abort
    let l:prompt = get(a:, 1, 'Substitute: ')
    return s:Escape(input(l:prompt)) . ' '
endfunction

function! zero#substitute#CCword() abort
    return '\<' . zero#Cword() . '\>'
endfunction

function! zero#substitute#Cword() abort
    return zero#Cword()
endfunction

function! zero#substitute#Word() abort
    return s:Escape(zero#Word())
endfunction

function! zero#substitute#Vword(...) range abort
    if get(a:, 1, 0)
        return '\<' . s:Escape(zero#Vword()) . '\>'
    else
        return s:Escape(zero#Vword())
    endif
endfunction

function! zero#substitute#Pword() abort
    return s:Escape(zero#Pword())
endfunction

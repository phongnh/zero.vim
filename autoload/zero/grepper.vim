function! s:Escape(text) abort
    let l:shell = &shell
    try
        let &shell = 'sh'
        return shellescape(a:text)
    finally
        let &shell = l:shell
    endtry
endfunction

function! zero#grepper#Escape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#grepper#CCword() abort
    return s:Escape(zero#CCword())
endfunction

function! zero#grepper#Cword() abort
    return s:Escape(zero#Cword())
endfunction

function! zero#grepper#Word() abort
    return s:Escape(zero#Word())
endfunction

function! zero#grepper#Vword() range abort
    return s:Escape(zero#Vword())
endfunction

function! zero#grepper#Visual() range abort
    return s:Escape(zero#Visual())
endfunction

function! zero#grepper#Pword() abort
    return s:Escape(zero#Pword())
endfunction

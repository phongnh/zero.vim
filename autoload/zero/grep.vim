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

function! s:GrepperEscape(text) abort
    let l:shell = &shell
    try
        let &shell = 'sh'
        return shellescape(a:text)
    finally
        let &shell = l:shell
    endtry
endfunction

function! zero#grep#GrepperEscape(text) abort
    return s:GrepperEscape(a:text)
endfunction

function! zero#grep#GrepperCCword() abort
    return s:GrepperEscape(zero#CCword())
endfunction

function! zero#grep#GrepperCword() abort
    return s:GrepperEscape(zero#Cword())
endfunction

function! zero#grep#GrepperWord() abort
    return s:GrepperEscape(zero#Word())
endfunction

function! zero#grep#GrepperVword() range abort
    return s:GrepperEscape(zero#Vword())
endfunction

function! zero#grep#GrepperVisual() range abort
    return s:GrepperEscape(zero#Visual())
endfunction

function! zero#grep#GrepperPword() abort
    return s:GrepperEscape(zero#Pword())
endfunction

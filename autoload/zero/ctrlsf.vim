function! s:CtrlSFEscape(text) abort
    return shellescape(a:text)
endfunction

function! zero#ctrlsf#CCword(...) abort
    if get(a:, 1, 0)
        return '-W -- ' . zero#Cword()
    else
        return '-R -- ' . zero#CCword()
    endif
endfunction

function! zero#ctrlsf#Cword() abort
    return '-- ' . zero#Cword()
endfunction

function! zero#ctrlsf#Word() abort
    return '-- ' . s:CtrlSFEscape(zero#Word())
endfunction

function! zero#ctrlsf#Vword() range abort
    return '-- ' . s:CtrlSFEscape(zero#Vword())
endfunction

function! zero#ctrlsf#Pword() abort
    let l:pword = zero#Pword()
    return (stridx(l:pword, '\b') > -1 ? '-R ' : '') . '-- ' . s:CtrlSFEscape(l:pword)
endfunction

function! zero#ctrlsf#CCword() abort
    if get(g:, 'ctrlsf_backend', '') ==# 'rg'
        return '-R -- ' . shellescape(zero#CCword())
    else
        return shellescape(zero#Cword())
    endif
endfunction

function! zero#ctrlsf#Cword() abort
    return '-- ' . shellescape(zero#Cword())
endfunction

function! zero#ctrlsf#Word() abort
    return '-- ' . shellescape(zero#Word())
endfunction

function! zero#ctrlsf#Vword() abort
    return '-- ' . shellescape(zero#Vword())
endfunction

function! zero#ctrlsf#Pword() abort
    let l:pword = zero#Pword()
    return (stridx(l:pword, '\b') > -1 ? '-R ' : '') . '-- ' . shellescape(l:pword)
endfunction


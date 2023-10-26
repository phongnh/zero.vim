function! s:Escape(text) abort
    return shellescape(a:text)
endfunction

function! zero#ctrlsf#Escape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#ctrlsf#Input(...) abort
    let l:prompt = get(a:, 1, 'CtrlSF: ')
    return s:Escape(input(l:prompt)) . ' '
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
    return '-- ' . s:Escape(zero#Word())
endfunction

function! zero#ctrlsf#Vword() range abort
    return '-- ' . s:Escape(zero#Vword())
endfunction

function! zero#ctrlsf#Pword() abort
    let l:pword = zero#Pword()
    return (stridx(l:pword, '\b') > -1 ? '-R ' : '') . '-- ' . s:Escape(l:pword)
endfunction

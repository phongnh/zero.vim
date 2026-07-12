function! zero#Trim(str) abort
    if exists('*trim')
        return trim(a:str)
    endif
    return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

" Search Helpers
function! zero#CCword() abort
    return '\b' .. expand('<cword>') .. '\b'
endfunction

function! zero#Cword() abort
    return expand('<cword>')
endfunction

function! zero#Word() abort
    return expand('<cWORD>')
endfunction

function! zero#Vword() range abort
    let l:saved = @"
    silent execute 'normal! ""gvy'
    let l:selection = @"
    let @" = l:saved
    return l:selection ==# "\n" ? '' : substitute(l:selection, '\n\+$', '', 'g')
endfunction

function! zero#Visual() range abort
    if exists('*getregion')
        return zero#Trim(join(call('getregion', [getpos("'<"), getpos("'>")])->slice(0, 1), "\n"))
    endif
    let l:line = getline("'<")
    let [_b1, l:l1, l:c1, _o1] = getpos("'<")
    let [_b2, l:l2, l:c2, _o2] = getpos("'>")
    if l:l1 != l:l2
        return zero#Trim(strpart(l:line, l:c1 - 1))
    endif
    return zero#Trim(strpart(l:line, l:c1 - 1, l:c2 - l:c1 + 1))
endfunction

function! zero#Pword() abort
    let l:search = @/
    if empty(l:search) || l:search ==# "\n"
        return ''
    endif
    return substitute(l:search, '^\\<\(.\+\)\\>$', '\\b\1\\b', '')
endfunction

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
    let l:text = @/
    if empty(l:text) || l:text ==# "\n"
        return ''
    endif
    return substitute(l:text, '^\\<\(.\+\)\\>$', '\\b\1\\b', '')
endfunction

function! s:IsSubstituteCommand(cmd) abort
    return a:cmd =~# '^%\?\(s\|substitute\|S\|Subvert\)/' ||
                \ a:cmd =~# '^\(silent!\?\s\+\)\?\(c\|l\)\(fdo\|do\)\s\+\(s\|substitute\|S\|Subvert\)/'
endfunction

function! s:IsGrepperCommand(cmd) abort
    return a:cmd =~# '^\(Grepper\|LGrepper\|PGrepper\|BGrepper\)\s'
endfunction

function! s:IsGrepCommand(cmd) abort
    return a:cmd =~# '^\(Grep\|LGrep\|BGrep\|grep\|lgrep\)\s' ||
                \ a:cmd =~# '^\(Ggrep!\?\|Gcgrep!\?\|Glgrep!\?\)\s' ||
                \ a:cmd =~# '^\(Git!\?\s\+grep\)\s'
endfunction

function! s:IsInputCommand() abort
    return getcmdtype() == '@'
endfunction

function! zero#InsertCCword() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#substitute#CCword()
    elseif s:IsGrepperCommand(l:cmd)
        return zero#dumb_jump#RgCword()
    elseif s:IsGrepCommand(l:cmd)
        return zero#grep#CCword()
    else
        return zero#shell#CCword()
    endif
endfunction

function! zero#InsertCword() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#substitute#Cword()
    elseif s:IsGrepperCommand(l:cmd)
        return zero#dumb_jump#Cword()
    elseif s:IsGrepCommand(l:cmd)
        return zero#grep#CCword()
    elseif s:IsInputCommand()
        return zero#shell#Cword()
    else
        return zero#Cword()
    endif
endfunction

function! zero#InsertWord() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#substitute#Word()
    elseif s:IsGrepperCommand(l:cmd)
        return zero#dumb_jump#Cword()
    elseif s:IsGrepCommand(l:cmd)
        return zero#grep#Word()
    else
        return zero#shell#Word()
    endif
endfunction

function! zero#InsertVword() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#substitute#Vword()
    elseif s:IsGrepCommand(l:cmd)
        return zero#grep#Vword()
    elseif s:IsInputCommand()
        return zero#shell#Vword()
    else
        return zero#Vword()
    endif
endfunction

function! zero#InsertPword() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#substitute#Pword()
    elseif s:IsGrepCommand(l:cmd)
        return zero#grep#Pword()
    else
        return zero#shell#Pword()
    endif
endfunction

function! zero#InsertGrepPword() abort
    return zero#grep#Pword()
endfunction

function! zero#InsertInput() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#substitute#Input()
    elseif s:IsGrepCommand(l:cmd)
        return zero#grep#Input()
    else
        return zero#shell#Input()
    endif
endfunction

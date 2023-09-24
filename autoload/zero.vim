" zero.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:Print(msg) abort
    echohl WarningMsg | echomsg a:msg | echohl None
endfunction

function! zero#Error(msg) abort
    echohl ErrorMsg | echomsg a:msg | echohl None
endfunction

function! zero#LogCommand(cmd, ...) abort
    if g:zero_vim_debug
        let l:tag = get(a:, 1, '')
        if strlen(l:tag)
            let l:tag = '[' . l:tag . '] '
        endif
        call s:Print('Running: ' . l:tag . a:cmd)
    endif
endfunction

if exists('*trim')
    function! zero#Strip(str) abort
        return trim(a:str)
    endfunction
else
    function! zero#Strip(str) abort
        return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
    endfunction
endif

" Search Helpers
function! zero#CCword() abort
    return '\b' . expand('<cword>') . '\b'
endfunction

function! zero#Cword() abort
    return expand('<cword>')
endfunction

function! zero#Word() abort
    return expand('<cWORD>')
endfunction

function! zero#Vword() range abort
    " Save the current register and clipboard
    let reg_save     = getreg('"')
    let regtype_save = getregtype('"')
    let cb_save      = &clipboard
    set clipboard&

    " Put the current visual selection in the " register
    normal! ""gvy

    let selection = getreg('"')

    " Put the saved registers and clipboards back
    call setreg('"', reg_save, regtype_save)
    let &clipboard = cb_save

    if selection ==# "\n"
        return ''
    else
        return selection
    endif
endfunction

function! zero#Pword() abort
    let search = @/

    if search ==# "\n" || empty(search)
        return ''
    endif

    return substitute(search, '^\\<\(.\+\)\\>$', '\\b\1\\b', '')
endfunction

function! s:IsSubstituteCommand(cmd) abort
    return a:cmd =~# '^%\?\(s\|substitute\|S\|Subvert\)/' ||
                \ a:cmd =~# '^\(silent!\?\s\+\)\?\(c\|l\)\(fdo\|do\)\s\+\(s\|substitute\|S\|Subvert\)/'
endfunction

function! s:IsGrepCommand(cmd) abort
    return a:cmd =~# '^\(Grep\|LGrep\|BGrep\PGrep\|PLGrep\|grep\|lgrep\)\s' ||
                \ a:cmd =~# '^\(Ggrep!\?\|Gcgrep!\?\|Glgrep!\?\)\s' ||
                \ a:cmd =~# '^\(Git!\?\s\+grep\)\s'
endfunction

function! s:IsCtrlSFCommand(cmd) abort
    return a:cmd =~# '^\(CtrlSF\|PCtrlSF\)'
endfunction

function! s:IsFerretCommand(cmd) abort
    return a:cmd =~# '^\(Ack\|Lack\|Back\|Black\|PAck\|PLack\)'
endfunction

function! s:IsFerretSubstituteCommand(cmd) abort
    return a:cmd =~# '^\(Acks\|Lacks\)'
endfunction

function! zero#InsertWord() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#substitute#Word()
    elseif s:IsFerretSubstituteCommand(l:cmd)
        return zero#substitute#Word()
    elseif s:IsGrepCommand(l:cmd)
        return zero#grep#Word()
    elseif s:IsCtrlSFCommand(l:cmd)
        return zero#Word()
    elseif s:IsFerretCommand(l:cmd)
        return zero#ferret#Word()
    elseif getcmdtype() == '@'
        return zero#shell#Word()
    else
        return zero#shell#Word()
    endif
endfunction

function! zero#InsertCCword() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#substitute#CCword()
    elseif s:IsFerretSubstituteCommand(l:cmd)
        return zero#substitute#CCword()
    elseif s:IsGrepCommand(l:cmd)
        return zero#grep#CCword()
    elseif s:IsCtrlSFCommand(l:cmd)
        return zero#ctrlsf#CCword()
    elseif s:IsFerretCommand(l:cmd)
        return zero#ferret#CCword()
    elseif getcmdtype() == '@'
        return zero#shell#CCword()
    else
        return zero#shell#CCword()
    endif
endfunction

function! zero#InsertPword() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#substitute#Pword()
    elseif s:IsFerretSubstituteCommand(l:cmd)
        return zero#substitute#Pword()
    elseif s:IsGrepCommand(l:cmd)
        return zero#grep#Pword()
    elseif s:IsCtrlSFCommand(l:cmd)
        return zero#ctrlsf#Pword()
    elseif s:IsFerretCommand(l:cmd)
        return zero#ferret#Pword()
    elseif getcmdtype() == '@'
        return zero#shell#Pword()
    else
        return zero#shell#Pword()
    endif
endfunction

function! zero#InsertGrepPword() abort
    return zero#grep#Pword()
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

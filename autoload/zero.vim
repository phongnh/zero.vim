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
function! zero#TrimNewLines(text) abort
    let text = substitute(a:text, '^\n\+', '', 'g')
    let text = substitute(text, '\n\+$', '', 'g')
    return text
endfunction

let s:shell_escape_characters      = '\^$.*+?()[]{}|-'
let s:grep_escape_characters       = '^$.*+?()[]{}|-'
let s:substitute_escape_characters = '^$.*\/~[]'

function! zero#ShellEscape(text, ...) abort
    if empty(a:text)
        return ''
    endif

    " Escape some characters
    let escaped_text = escape(a:text, s:shell_escape_characters)

    return shellescape(escaped_text)
endfunction

function! zero#GrepShellEscape(text) abort
    if empty(a:text)
        return ''
    endif

    " Escape alternative file
    let escaped_text = substitute(a:text, '#', '\\\\#', 'g')

    " Escape some characters
    let escaped_text = escape(escaped_text, s:grep_escape_characters)

    return shellescape(escaped_text)
endfunction

function! zero#SubstituteEscape(text) abort
    " Escape regex characters
    let text = escape(a:text, s:substitute_escape_characters)

    " Escape the line endings
    let text = substitute(text, '\n', '\\n', 'g')

    return text
endfunction

function! zero#CCword(...) abort
    if get(a:, 1, 0)
        return '-w ' . expand('<cword>')
    else
        return '\b' . expand('<cword>') . '\b'
    endif
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

function! zero#CCwordForShell() abort
    return zero#shell#CCword()
endfunction

function! zero#CwordForShell() abort
    return zero#shell#Cword()
endfunction

function! zero#WordForShell() abort
    return zero#shell#Word()
endfunction

function! zero#VwordForShell() range abort
    return zero#shell#Vword()
endfunction

function! zero#PwordForShell() abort
    return zero#shell#Pword()
endfunction

function! zero#CCwordForCtrlSF() abort
    return zero#ctrlsf#CCword()
endfunction

function! zero#CwordForCtrlSF() abort
    return zero#ctrlsf#Cword()
endfunction

function! zero#WordForCtrlSF() abort
    return zero#ctrlsf#Word()
endfunction

function! zero#VwordForCtrlSF() abort
    return zero#ctrlsf#Vword()
endfunction

function! zero#PwordForCtrlSF() abort
    return zero#ctrlsf#Pword()
endfunction

function! zero#CCwordForFerret(...) abort
    return call('zero#ferret#CCword', a:000)
endfunction

function! zero#CwordForFerret() abort
    return zero#ferret#Cword()
endfunction

function! zero#WordForFerret() abort
    return zero#ferret#Word()
endfunction

function! zero#VwordForFerret() abort
    return zero#ferret#Vword()
endfunction

function! zero#PwordForFerret()abort
    return zero#ferret#Pword()
endfunction

function! zero#CCwordForGrep() abort
    return zero#grep#CCword()
endfunction

function! zero#CwordForGrep() abort
    return zero#grep#Cword()
endfunction

function! zero#WordForGrep() abort
    return zero#grep#Word()
endfunction

function! zero#VwordForGrep() range abort
    return zero#grep#Vword()
endfunction

function! zero#PwordForGrep() abort
    return zero#grep#Pword()
endfunction

function! zero#CCwordForSubstitute() abort
    return zero#substitute#CCword()
endfunction

function! zero#CwordForSubstitute() abort
    return zero#substitute#Cword()
endfunction

function! zero#WordForSubstitute() abort
    return zero#substitute#Word()
endfunction

function! zero#VwordForSubstitute() range abort
    return zero#substitute#Vword()
endfunction

function! zero#PwordForSubstitute() range abort
    return zero#substitute#Pword()
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

let &cpoptions = s:save_cpo
unlet s:save_cpo

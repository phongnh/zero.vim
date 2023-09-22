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
function! s:TrimNewLines(text) abort
    let text = substitute(a:text, '^\n\+', '', 'g')
    let text = substitute(text, '\n\+$', '', 'g')
    return text
endfunction

let s:shell_escape_characters      = '\^$.*+?()[]{}|-'
let s:grep_escape_characters       = '^$.*+?()[]{}|-'
let s:substitute_escape_characters = '^$.*\/~[]'

function! s:ShellEscape(text) abort
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
    let cword = s:TrimNewLines(zero#Cword())
    let cword = escape(cword, s:shell_escape_characters)
    return shellescape('\b' . cword . '\b')
endfunction

function! zero#CwordForShell() abort
    let cword = s:TrimNewLines(zero#Cword())
    return s:ShellEscape(cword)
endfunction

function! zero#WordForShell() abort
    let word = s:TrimNewLines(zero#Word())
    return s:ShellEscape(word)
endfunction

function! zero#VwordForShell() range abort
    let selection = s:TrimNewLines(zero#Vword())
    return s:ShellEscape(selection)
endfunction

function! zero#PwordForShell() abort
    let search = zero#Pword()
    return s:ShellEscape(search)
endfunction

function! zero#CCwordForCtrlSF() abort
    if get(g:, 'ctrlsf_backend', '') ==# 'rg'
        return '-R -- ' . shellescape(zero#CCword())
    else
        return shellescape(zero#Cword())
    endif
endfunction

function! zero#CwordForCtrlSF() abort
    return '-- ' . shellescape(zero#Cword())
endfunction

function! zero#WordForCtrlSF() abort
    return '-- ' . shellescape(zero#Word())
endfunction

function! zero#VwordForCtrlSF() abort
    return '-- ' . shellescape(zero#Vword())
endfunction

function! zero#PwordForCtrlSF() abort
    let l:pword = zero#Pword()
    return (stridx(l:pword, '\b') > -1 ? '-R ' : '') . '-- ' . shellescape(l:pword)
endfunction

function! zero#CCwordForFerret(...) abort
    return call('zero#CCword', a:000)
endfunction

function! zero#CwordForFerret() abort
    return zero#Cword()
endfunction

function! zero#WordForFerret() abort
    return zero#Word()
endfunction

function! zero#VwordForFerret() abort
    return escape(zero#Vword(), ' ')
endfunction

function! zero#PwordForFerret()abort
    return escape(zero#Pword(), ' ')
endfunction

function! zero#CCwordForGrep() abort
    let cword = zero#CCword()
    return zero#GrepShellEscape(cword)
endfunction

function! zero#CwordForGrep() abort
    let cword = zero#Cword()
    return zero#GrepShellEscape(cword)
endfunction

function! zero#WordForGrep() abort
    let word = zero#Word()
    return zero#GrepShellEscape(word)
endfunction

function! zero#VwordForGrep() range abort
    let selection = zero#Vword()
    return zero#GrepShellEscape(selection)
endfunction

function! zero#PwordForGrep() abort
    let search = zero#Pword()
    return zero#GrepShellEscape(search)
endfunction

function! zero#CCwordForSubstitute() abort
    return '\<' . zero#Cword() . '\>'
endfunction

function! zero#CwordForSubstitute() abort
    return zero#Cword()
endfunction

function! zero#WordForSubstitute() abort
    let word = zero#Word()

    " Escape regex characters
    let word = escape(word, s:substitute_escape_characters)

    return word
endfunction

function! zero#VwordForSubstitute() range abort
    let selection = zero#Vword()

    " Escape regex characters
    let selection = escape(selection, s:substitute_escape_characters)

    " Escape the line endings
    let selection = substitute(selection, '\n', '\\n', 'g')

    return selection
endfunction

function! zero#PwordForSubstitute() range abort
    let search = zero#Pword()

    " Escape regex characters
    let search = escape(search, '^$.*\/~[]')

    " Escape the line endings
    let search = substitute(search, '\n', '\\n', 'g')

    return search
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
        return zero#WordForSubstitute()
    elseif s:IsFerretSubstituteCommand(l:cmd)
        return zero#WordForSubstitute()
    elseif s:IsGrepCommand(l:cmd)
        return zero#WordForGrep()
    elseif s:IsCtrlSFCommand(l:cmd)
        return zero#Word()
    elseif s:IsFerretCommand(l:cmd)
        return zero#WordForFerret()
    elseif getcmdtype() == '@'
        return zero#WordForShell()
    else
        return zero#WordForShell()
    endif
endfunction

function! zero#InsertCCword() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#CCwordForSubstitute()
    elseif s:IsFerretSubstituteCommand(l:cmd)
        return zero#CCwordForSubstitute()
    elseif s:IsGrepCommand(l:cmd)
        return zero#CCwordForGrep()
    elseif s:IsCtrlSFCommand(l:cmd)
        return zero#CCwordForCtrlSF()
    elseif s:IsFerretCommand(l:cmd)
        return zero#CCwordForFerret()
    elseif getcmdtype() == '@'
        return zero#CCwordForShell()
    else
        return zero#CCwordForShell()
    endif
endfunction

function! zero#InsertPword() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#PwordForSubstitute()
    elseif s:IsFerretSubstituteCommand(l:cmd)
        return zero#PwordForSubstitute()
    elseif s:IsGrepCommand(l:cmd)
        return zero#PwordForGrep()
    elseif s:IsCtrlSFCommand(l:cmd)
        return zero#PwordForCtrlSF()
    elseif s:IsFerretCommand(l:cmd)
        return zero#PwordForFerret()
    elseif getcmdtype() == '@'
        return zero#PwordForShell()
    else
        return zero#PwordForShell()
    endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

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
        call s:Print('Running: ' . l:tag . string(a:cmd))
    endif
endfunction

function! zero#Trim(str) abort
    return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

if exists('*trim')
    function! zero#Trim(str) abort
        return trim(a:str)
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

function! s:IsGrepperGitCommand(cmd) abort
    return a:cmd =~# '^\(GrepperGit\)\s'
endfunction

function! s:IsGrepperCommand(cmd) abort
    return a:cmd =~# '^\(Grepper\|SGrepper\|LGrepper\|PGrepper\|TGrepper\|GrepperRg\)\s'
endfunction

function! s:IsGrepCommand(cmd) abort
    return a:cmd =~# '^\(Grep\|LGrep\|BGrep\|grep\|lgrep\)\s' ||
                \ a:cmd =~# '^\(Ggrep!\?\|Gcgrep!\?\|Glgrep!\?\)\s' ||
                \ a:cmd =~# '^\(Git!\?\s\+grep\)\s'
endfunction

function! s:IsCtrlSFCommand(cmd) abort
    return a:cmd =~# '^\(CtrlSF\|PCtrlSF\)'
endfunction

function! s:IsInputCommand() abort
    return getcmdtype() == '@'
endfunction

function! zero#InsertCCword() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#substitute#CCword()
    elseif s:IsGrepperGitCommand(l:cmd)
        return zero#dumb_jump#GitCword()
    elseif s:IsGrepperCommand(l:cmd)
        return zero#dumb_jump#RgCword()
    elseif s:IsGrepCommand(l:cmd)
        return zero#grep#CCword()
    elseif s:IsCtrlSFCommand(l:cmd)
        return zero#ctrlsf#CCword()
    elseif s:IsInputCommand()
        return zero#shell#CCword()
    else
        return zero#shell#CCword()
    endif
endfunction

function! zero#InsertCword() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return zero#substitute#Cword()
    elseif s:IsGrepperGitCommand(l:cmd)
        return zero#dumb_jump#Cword()
    elseif s:IsGrepperCommand(l:cmd)
        return zero#dumb_jump#Cword()
    elseif s:IsGrepCommand(l:cmd)
        return zero#grep#CCword()
    elseif s:IsCtrlSFCommand(l:cmd)
        return zero#ctrlsf#Cword()
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
    elseif s:IsGrepperGitCommand(l:cmd)
        return zero#dumb_jump#Cword()
    elseif s:IsGrepperCommand(l:cmd)
        return zero#dumb_jump#Cword()
    elseif s:IsGrepCommand(l:cmd)
        return zero#grep#Word()
    elseif s:IsCtrlSFCommand(l:cmd)
        return zero#Word()
    elseif s:IsInputCommand()
        return zero#shell#Word()
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
    elseif s:IsCtrlSFCommand(l:cmd)
        return zero#ctrlsf#Vword()
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
    elseif s:IsCtrlSFCommand(l:cmd)
        return zero#ctrlsf#Pword()
    elseif s:IsInputCommand()
        return zero#shell#Pword()
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
    elseif s:IsCtrlSFCommand(l:cmd)
        return zero#ctrlsf#Input()
    elseif s:IsInputCommand()
        return zero#shell#Input()
    else
        return zero#shell#Input()
    endif
endfunction

" Replace typographic characters
" Copied from https://github.com/srstevenson/dotfiles {{{
function! zero#ReplaceTypographicCharacters() abort
    let l:map = {}
    let l:map['–'] = '--'
    let l:map['—'] = '---'
    let l:map['‘'] = "'"
    let l:map['’'] = "'"
    let l:map['“'] = '"'
    let l:map['”'] = '"'
    let l:map['•'] = '*'
    let l:map['…'] = '...'
    execute ':keeppatterns :%substitute/'.join(keys(l:map), '\|').'/\=l:map[submatch(0)]/ge'
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

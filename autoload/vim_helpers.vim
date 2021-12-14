" vim_helpers.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:Print(msg) abort
    echohl WarningMsg | echomsg a:msg | echohl None
endfunction

function! vim_helpers#Error(msg) abort
    echohl ErrorMsg | echomsg a:msg | echohl None
endfunction

function! vim_helpers#LogCommand(cmd, ...) abort
    if g:vim_helpers_debug
        let l:tag = get(a:, 1, '')
        if strlen(l:tag)
            let l:tag = '[' . l:tag . '] '
        endif
        call s:Print('Running: ' . l:tag . a:cmd)
    endif
endfunction

if exists('*trim')
    function! vim_helpers#Strip(str) abort
        return trim(a:str)
    endfunction
else
    function! vim_helpers#Strip(str) abort
        return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
    endfunction
endif

" TODO: Remove this function
function! vim_helpers#strip(str) abort
    return vim_helpers#Strip(a:str)
endfunction

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

function! vim_helpers#GrepShellEscape(text) abort
    if empty(a:text)
        return ''
    endif

    " Escape alternative file
    let escaped_text = substitute(a:text, '#', '\\\\#', 'g')

    " Escape some characters
    let escaped_text = escape(escaped_text, s:grep_escape_characters)

    return shellescape(escaped_text)
endfunction

function! vim_helpers#CCword() abort
    return '\b' . expand('<cword>') . '\b'
endfunction

function! vim_helpers#Cword() abort
    return expand('<cword>')
endfunction

function! vim_helpers#Word() abort
    return expand('<cWORD>')
endfunction

function! vim_helpers#Vword() range abort
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

function! vim_helpers#CCwordForShell() abort
    let cword = s:TrimNewLines(vim_helpers#Cword())
    let cword = escape(cword, s:shell_escape_characters)
    return shellescape('\b' . cword . '\b')
endfunction

function! vim_helpers#CwordForShell() abort
    let cword = s:TrimNewLines(vim_helpers#Cword())
    return s:ShellEscape(cword)
endfunction

function! vim_helpers#WordForShell() abort
    let word = s:TrimNewLines(vim_helpers#Word())
    return s:ShellEscape(word)
endfunction

function! vim_helpers#VwordForShell() range abort
    let selection = s:TrimNewLines(vim_helpers#Vword())
    return s:ShellEscape(selection)
endfunction

function! vim_helpers#Pword() abort
    let search = @/

    if search ==# "\n" || empty(search)
        return ''
    endif

    return substitute(search, '^\\<\(.\+\)\\>$', '\\b\1\\b', '')
endfunction

function! vim_helpers#PwordForShell() abort
    let search = vim_helpers#Pword()
    return s:ShellEscape(search)
endfunction

function! vim_helpers#CCwordForCtrlSF() abort
    if get(g:, 'ctrlsf_backend', '') ==# 'rg'
        return '-R ' . vim_helpers#CCword()
    else
        return vim_helpers#Cword()
    endif
endfunction

function! vim_helpers#PwordForCtrlSF() abort
    let l:pword = vim_helpers#Pword()
    return (stridx(l:pword, '\b') > -1 ? '-R ' : '') . l:pword
endfunction

function! vim_helpers#CCwordForGrep() abort
    let cword = vim_helpers#CCword()
    return vim_helpers#GrepShellEscape(cword)
endfunction

function! vim_helpers#CwordForGrep() abort
    let cword = vim_helpers#Cword()
    return vim_helpers#GrepShellEscape(cword)
endfunction

function! vim_helpers#WordForGrep() abort
    let word = vim_helpers#Word()
    return vim_helpers#GrepShellEscape(word)
endfunction

function! vim_helpers#VwordForGrep() range abort
    let selection = vim_helpers#Vword()
    return vim_helpers#GrepShellEscape(selection)
endfunction

function! vim_helpers#PwordForGrep() abort
    let search = vim_helpers#Pword()
    return vim_helpers#GrepShellEscape(search)
endfunction

function! vim_helpers#CCwordForSubstitute() abort
    return '\<' . vim_helpers#Cword() . '\>'
endfunction

function! vim_helpers#CwordForSubstitute() abort
    return vim_helpers#Cword()
endfunction

function! vim_helpers#WordForSubstitute() abort
    let word = vim_helpers#Word()

    " Escape regex characters
    let word = escape(word, s:substitute_escape_characters)

    return word
endfunction

function! vim_helpers#VwordForSubstitute() range abort
    let selection = vim_helpers#Vword()

    " Escape regex characters
    let selection = escape(selection, s:substitute_escape_characters)

    " Escape the line endings
    let selection = substitute(selection, '\n', '\\n', 'g')

    return selection
endfunction

function! vim_helpers#PwordForSubstitute() range abort
    let search = vim_helpers#Pword()

    " Escape regex characters
    let search = escape(search, '^$.*\/~[]')

    " Escape the line endings
    let search = substitute(search, '\n', '\\n', 'g')

    return search
endfunction

function! s:RgKnownFileTypes() abort
    if exists('g:rg_known_filetypes')
        return g:rg_known_filetypes
    endif
    if executable('rg')
        let g:rg_known_filetypes = systemlist("rg --type-list | cut -d ':' -f 1")
    else
        let g:rg_known_filetypes = []
    endif
    return g:rg_known_filetypes
endfunction

function! vim_helpers#RgFileType(ft) abort
    return get(g:rg_filetype_mappings, a:ft, a:ft)
endfunction

function! vim_helpers#IsRgKnownFileType(ft) abort
    return index(s:RgKnownFileTypes(), a:ft) >= 0
endfunction

function! vim_helpers#RgFileTypeOption() abort
    let ext = expand('%:e')
    let ft = vim_helpers#RgFileType(&filetype)

    if strlen(ft) && (ft ==# 'vim' || ft ==# 'nvim')
        return "-g '*.vim' -g '*.nvim'"
    elseif strlen(ft) && vim_helpers#IsRgKnownFileType(ft)
        return printf("-t %s", ft)
    elseif strlen(ext)
        if ext ==# 'vim' || ext ==# 'nvim'
            return "-g '*.vim' -g '*.nvim'"
        else
            return printf("-g '*.%s'", ext)
        endif
    endif

    return ''
endfunction

function! vim_helpers#GrepFileTypeOption() abort
    let ext = expand('%:e')

    if strlen(ext)
        if ext ==# 'vim' || ext ==# 'nvim'
            return "-include='*.vim' -include='*.nvim'"
        else
            return printf("-include='*.%s'", ext)
        endif
    endif

    return ''
endfunction

function! s:IsSubstituteCommand(cmd) abort
    return a:cmd =~# '^%\?\(s\|substitute\|S\|Subvert\)/' ||
                \ a:cmd =~# '^\(c\|l\)do \(s\|substitute\|S\|Subvert\)/' ||
                \ a:cmd =~# '^\(c\|l\)fdo %\(s\|substitute\|S\|Subvert\)/'
endfunction

function! s:IsGrepCommand(cmd) abort
    return a:cmd =~# '^\(Grep\|LGrep\|BGrep\|TGrep\|FGrep\|GrepCode\|LGrepCode\|grep\|lgrep\)\s' ||
                \ a:cmd =~# '^\(Ggrep!\?\|Gcgrep!\?\|Glgrep!\?\)\s' ||
                \ a:cmd =~# '^\(Git!\?\s\+grep\)\s'
endfunction

function! s:IsCtrlSFCommand(cmd) abort
    return a:cmd =~# '^CtrlSF' ||
                \ a:cmd =~# '^PCtrlSF' ||
                \ a:cmd =~# '^TCtrlSF'
endfunction

function! vim_helpers#InsertWord() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return vim_helpers#WordForSubstitute()
    elseif s:IsGrepCommand(l:cmd)
        return vim_helpers#WordForGrep()
    elseif s:IsCtrlSFCommand(l:cmd)
        return vim_helpers#Word()
    elseif getcmdtype() == '@'
        return vim_helpers#WordForShell()
    else
        return vim_helpers#WordForShell()
    endif
endfunction

function! vim_helpers#InsertCCword() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return vim_helpers#CCwordForSubstitute()
    elseif s:IsGrepCommand(l:cmd)
        return vim_helpers#CCwordForGrep()
    elseif s:IsCtrlSFCommand(l:cmd)
        return vim_helpers#CCwordForCtrlSF()
    elseif getcmdtype() == '@'
        return vim_helpers#CCwordForShell()
    else
        return vim_helpers#CCwordForShell()
    endif
endfunction

function! vim_helpers#InsertPword() abort
    let l:cmd = getcmdline()
    if s:IsSubstituteCommand(l:cmd)
        return vim_helpers#PwordForSubstitute()
    elseif s:IsGrepCommand(l:cmd)
        return vim_helpers#PwordForGrep()
    elseif s:IsCtrlSFCommand(l:cmd)
        return vim_helpers#PwordForCtrlSF()
    elseif getcmdtype() == '@'
        return vim_helpers#PwordForShell()
    else
        return vim_helpers#PwordForShell()
    endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

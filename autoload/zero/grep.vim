let s:escape_characters = '^$.*+?()[]{}|-'

function! s:Escape(text) abort
    return escape(a:text, s:escape_characters)
endfunction

function! s:GrepEscape(text) abort
    " Escape alternative file
    let text = substitute(a:text, '#', '\\\\#', 'g')
    let text = s:Escape(text)
    return shellescape(text)
endfunction

" Grep Helpers
function! s:GrepDir(dir) abort
    let l:dir = fnamemodify(empty(a:dir) ? expand('%') : a:dir, ':~:.:h')
    let l:dir = zero#Strip(l:dir)

    if empty(l:dir) || l:dir ==# '.' || l:dir =~ '^/' || l:dir =~ '^\~'
        return ''
    endif

    return l:dir
endfunction

function! s:Grep(cmd, ...) abort
    let l:cmd = zero#Strip(a:cmd . ' ' . join(a:000, ' '))
    call zero#LogCommand(l:cmd)
    try
        execute l:cmd
    catch
    endtry
endfunction

function! zero#grep#Grep(...) abort
    call call(function('s:Grep'), ['Grep'] + a:000)
endfunction

function! zero#grep#LGrep(...) abort
    call call(function('s:Grep'), ['LGrep'] + a:000)
endfunction

function! zero#grep#BGrep(...) abort
    call call(function('s:Grep'), ['BGrep'] + a:000)
endfunction

function! zero#grep#CCword() abort
    return s:GrepEscape(zero#CCword())
endfunction

function! zero#grep#Cword() abort
    return s:GrepEscape(zero#Cword())
endfunction

function! zero#grep#Word() abort
    return s:GrepEscape(zero#word())
endfunction

function! zero#grep#Vword() range abort
    return s:GrepEscape(zero#Vword())
endfunction

function! zero#grep#Pword() abort
    return s:GrepEscape(zero#Pword())
endfunction

function! zero#grep#Escape(text) abort
    return s:GrepEscape(a:text)
endfunction

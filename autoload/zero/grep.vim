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
    let cword = zero#CCword()
    return zero#GrepShellEscape(cword)
endfunction

function! zero#grep#Cword() abort
    let cword = zero#Cword()
    return zero#GrepShellEscape(cword)
endfunction

function! zero#grep#Word() abort
    let word = zero#Word()
    return zero#GrepShellEscape(word)
endfunction

function! zero#grep#Vword() range abort
    let selection = zero#Vword()
    return zero#GrepShellEscape(selection)
endfunction

function! zero#grep#Pword() abort
    let search = zero#Pword()
    return zero#GrepShellEscape(search)
endfunction

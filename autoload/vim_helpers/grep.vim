" Grep Helpers
function! s:GrepCmd() abort
    return split(&grepprg, '\s\+')[0]
endfunction

function! s:GrepDir(dir) abort
    let l:dir = fnamemodify(empty(a:dir) ? expand('%') : a:dir, ':~:.:h')
    let l:dir = vim_helpers#Strip(l:dir)

    if empty(l:dir) || l:dir ==# '.' || l:dir =~ '^/' || l:dir =~ '^\~'
        return ''
    endif

    return l:dir
endfunction

function! s:Grep(cmd, ...) abort
    let l:cmd = vim_helpers#Strip(a:cmd . ' ' . join(a:000, ' '))
    call vim_helpers#LogCommand(l:cmd)
    try
        execute l:cmd
    catch
    endtry
endfunction

function! vim_helpers#grep#Grep(...) abort
    call call(function('s:Grep'), ['Grep'] + a:000)
endfunction

function! vim_helpers#grep#LGrep(...) abort
    call call(function('s:Grep'), ['LGrep'] + a:000)
endfunction

function! vim_helpers#grep#BGrep(...) abort
    call call(function('s:Grep'), ['BGrep'] + a:000)
endfunction

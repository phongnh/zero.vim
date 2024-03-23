let s:escape_characters = '^$.*+?()[]{}|-'

function! s:Escape(text) abort
    " Escape alternative file
    let text = substitute(a:text, '#', '\\\\#', 'g')
    let text = escape(text, s:escape_characters)
    return shellescape(text)
endfunction

function! zero#grep#Escape(text) abort
    return s:Escape(a:text)
endfunction

function! zero#grep#Input(...) abort
    let l:prompt = get(a:, 1, 'Grep: ')
    return s:Escape(input(l:prompt)) . ' '
endfunction

" Grep Helpers
function! s:GrepDir(dir) abort
    let l:dir = fnamemodify(empty(a:dir) ? expand('%') : a:dir, ':~:.:h')
    let l:dir = zero#Trim(l:dir)

    if empty(l:dir) || l:dir ==# '.' || l:dir =~ '^/' || l:dir =~ '^\~'
        return ''
    endif

    return l:dir
endfunction

function! s:Grep(cmd, ...) abort
    let l:cmd = zero#Trim(a:cmd . ' ' . join(a:000, ' '))
    call zero#LogCommand(l:cmd)
    try
        execute l:cmd
    catch
    endtry
endfunction

function! s:BuildGrepCommand(...) abort
    let l:opts = map(copy(a:000), 'expandcmd(v:val)')
    let l:opts = len(l:opts) > 2 && (l:opts[-1] ==# '%' || l:opts[-1] ==# '#') ? l:opts[0:-2] : l:opts
    let l:cmd = join([&grepprg] + l:opts, ' ')
    return l:cmd
endfunction

function! zero#grep#Grep(...) abort
    let l:cmd = call('s:BuildGrepCommand', a:000)
    cgetexpr system(l:cmd)
    botright cwindow
    call setqflist([], 'a', { 'title': l:cmd })
endfunction

function! zero#grep#LGrep(...) abort
    let l:cmd = call('s:BuildGrepCommand', a:000)
    lgetexpr system(l:cmd)
    lwindow
    call setloclist(0, [], 'a', { 'title': l:cmd })
endfunction

function! zero#grep#CCword() abort
    return s:Escape(zero#CCword())
endfunction

function! zero#grep#Cword() abort
    return s:Escape(zero#Cword())
endfunction

function! zero#grep#Word() abort
    return s:Escape(zero#Word())
endfunction

function! zero#grep#Vword() range abort
    return s:Escape(zero#Vword())
endfunction

function! zero#grep#Pword() abort
    return s:Escape(zero#Pword())
endfunction

function! zero#grep#Escape(text) abort
    return s:Escape(a:text)
endfunction

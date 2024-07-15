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
function! s:BuildGrepCommand(args, path) abort
    let l:opts = strlen(a:args) ? [a:args] : []
    let l:opts = extend(l:opts, strlen(a:path) ? [shellescape(a:path)] : [])
    let l:cmd = join([&grepprg] + l:opts, ' ')
    return l:cmd
endfunction

function! s:Log(grep, cmd) abort
    echo printf('%s: Running `%s`!', a:grep, a:cmd)
endfunction

function! s:PrintError(grep, cmd) abort
    if strlen(v:errmsg)
        call zero#Error(printf('%s: `%s` failed! (%s)', a:grep, a:cmd, v:errmsg))
    else
        call zero#Error(printf('%s: `%s` failed!', a:grep, a:cmd))
    endif
endfunction

function! zero#grep#Grep(args, ...) abort
    echomsg a:args
    let l:errorformat = &errorformat
    let &errorformat = &grepformat
    let l:cmd = s:BuildGrepCommand(a:args, get(a:, 1, ''))
    try
        call s:Log('Grep', l:cmd)
        cgetexpr system(l:cmd)
        botright cwindow
        call setqflist([], 'a', { 'title': l:cmd })
    catch
        call s:PrintError('Grep', l:cmd)
    finally
        let &errorformat = l:errorformat
    endtry
endfunction

function! zero#grep#LGrep(args, ...) abort
    let l:errorformat = &errorformat
    let &errorformat = &grepformat
    let l:cmd = s:BuildGrepCommand(a:args, get(a:, 1, ''))
    try
        lgetexpr system(l:cmd)
        lwindow
        call setloclist(0, [], 'a', { 'title': l:cmd })
    catch
        call s:PrintError('LGrep', l:cmd)
    finally
        let &errorformat = l:errorformat
    endtry
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

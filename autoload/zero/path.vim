function! s:Copy(path) abort
    let @" = a:path
    if has('clipboard')
        let [@*, @+] = [@", @"]
    endif
    echo 'Copied:' @"
endfunction

function! s:ExpandPath(path, line_number) abort
    let l:result = expand(a:path)
    if a:line_number
        let l:result ..= ':' .. line('.')
    endif
    return l:result
endfunction

function! s:DoCopyPath(path, line_number) abort
    call s:Copy(s:ExpandPath(a:path, a:line_number))
endfunction

function! s:DoCopyDirPath(path) abort
    let l:result = s:ExpandPath(a:path, 0)
    if l:result == '.'
        let l:result = fnamemodify(getcwd(), ':t')
    endif
    call s:Copy(l:result)
endfunction

function! zero#path#CopyPath(line_number) abort
    call s:DoCopyPath('%:~:.', a:line_number)
endfunction

function! zero#path#CopyFullPath(line_number) abort
    call s:DoCopyPath('%:p:~', a:line_number)
endfunction

function! zero#path#CopyAbsolutePath(line_number) abort
    call s:DoCopyPath('%:p', a:line_number)
endfunction

function! zero#path#CopyDirPath() abort
    call s:DoCopyDirPath('%:p:.:h')
endfunction

function! zero#path#CopyFullDirPath() abort
    call s:DoCopyDirPath('%:p:~:h')
endfunction

function! zero#path#CopyAbsoluteDirPath() abort
    call s:DoCopyDirPath('%:p:h')
endfunction

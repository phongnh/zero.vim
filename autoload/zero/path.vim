" Copy path to clipboard
function! s:Copy(path) abort
    let @" = a:path
    if has('clipboard')
        let [@*, @+] = [@", @"]
    endif
    echo 'Copied: ' . @"
endfunction

function! s:ExpandPath(path, line_number) abort
    let l:path = expand(a:path)
    if a:line_number
        let l:path .= ':' . line('.')
    endif
    return l:path
endfunction

function! s:CopyPath(path, line_number) abort
    call s:Copy(s:ExpandPath(a:path, a:line_number))
endfunction

function! zero#path#CopyPath(line_number) abort
    call s:CopyPath('%:~:.', a:line_number)
endfunction

function! zero#path#CopyFullPath(line_number) abort
    call s:CopyPath('%:p:~', a:line_number)
endfunction

function! zero#path#CopyAbsolutePath(line_number) abort
    call s:CopyPath('%:p', a:line_number)
endfunction

function! s:CopyDirPath(path) abort
    let l:path = s:ExpandPath(a:path, 0)
    if l:path == '.'
        let l:path = fnamemodify(getcwd(), ':t')
    endif
    call s:Copy(l:path)
endfunction

function! zero#path#CopyDirPath() abort
    call s:CopyDirPath('%:p:~:h')
endfunction

function! zero#path#CopyFullDirPath() abort
    call s:CopyDirPath('%:p:.:h')
endfunction

function! zero#path#CopyAbsoluteDirPath() abort
    call s:CopyDirPath('%:p:h')
endfunction

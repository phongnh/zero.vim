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

function! s:CopyPathWithCwd(path, line_number) abort
    let l:cwd = fnamemodify(getcwd(), ':t')
    call s:Copy(l:cwd . '/' . s:ExpandPath(a:path, a:line_number))
endfunction

function! vim_helpers#path#CopyRelativePath(line_number) abort
    call s:CopyPath('%:~:.', a:line_number)
endfunction

function! vim_helpers#path#CopyRelativePathWithCwd(line_number) abort
    call s:CopyPathWithCwd('%:~:.', a:line_number)
endfunction

function! vim_helpers#path#CopyFullPath(line_number) abort
    call s:CopyPath('%:p', a:line_number)
endfunction

function! s:CopyDirPath(path) abort
    let l:path = s:ExpandPath(a:path, 0)
    if l:path == '.'
        let l:path = fnamemodify(getcwd(), ':t')
    endif
    call s:Copy(l:path)
endfunction

function! s:CopyDirPathWithCwd(path) abort
    let l:cwd = fnamemodify(getcwd(), ':t')
    let l:path = s:ExpandPath(a:path, 0)
    if l:path == '.'
        let l:path = l:cwd
    else
        let l:path = l:cwd . '/' . l:path
    endif
    call s:Copy(l:path)
endfunction

function! vim_helpers#path#CopyParentDirPath(bang) abort
    call s:CopyDirPath(a:bang ? '%:p:h' : '%:p:.:h')
endfunction

function! vim_helpers#path#CopyParentDirPathWithCwd(...) abort
    call s:CopyDirPathWithCwd('%:p:.:h')
endfunction

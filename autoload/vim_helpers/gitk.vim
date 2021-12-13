" Gitk
let s:is_windows = has('win64') || has('win32') || has('win32unix') || has('win16')
let s:gitk_cmd = 'gitk %s >/dev/null 2>&1'

if !s:is_windows
    let s:gitk_cmd .= ' &'
endif

let s:git_full_log_cmd = 'git log --name-only --format= --follow -- %s'

if executable('uniq')
    let s:git_full_log_cmd .= ' | uniq'
endif

function! s:RunGitk(options) abort
    let cmd = vim_helpers#Strip(printf(s:gitk_cmd, a:options))
    let cwd = shellescape(vim_helpers#git#WorkTree())
    call vim_helpers#LogCommand(cmd)
    execute printf('silent !cd %s && %s', cwd, cmd)
    redraw!
endfunction

function! s:BuildPath(path) abort
    let l:path = empty(a:path) ? expand('%') : a:path

    if empty(l:path)
        throw 'Path is required!'
    endif

    let l:path = fnamemodify(l:path, ':p')
    let l:path = substitute(l:path, vim_helpers#git#WorkTree() . '/', '', 'g')
    return l:path
endfunction

function! s:GitFullHistoryCommand(path) abort
    return printf('$(' . s:git_full_log_cmd . ')', shellescape(a:path))
endfunction

function! vim_helpers#gitk#Gitk(options) abort
    try
        call vim_helpers#git#FindRepo()
        call s:RunGitk(a:options)
    catch
        call vim_helpers#Error('Gitk: ' . v:exception)
    endtry
endfunction

function! vim_helpers#gitk#GitkFile(path, bang) abort
    try
        call vim_helpers#git#FindRepo()

        let path = s:BuildPath(a:path)

        if a:bang
            let path = s:GitFullHistoryCommand(path)
        else
            let path = shellescape(path)
        endif

        call s:RunGitk('-- ' . path)
    catch
        call vim_helpers#Error('GitkFile: ' . v:exception)
    endtry
endfunction

function! vim_helpers#gitk#GitkOnBlame() abort
    let ref = vim_helpers#git#ParseRef()
    if !empty(ref)
        call s:RunGitk(ref)
    endif
endfunction

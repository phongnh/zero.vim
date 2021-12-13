" Git helpers
function! vim_helpers#git#BuildPath(path) abort
    let l:path = empty(a:path) ? expand('%') : a:path

    if empty(l:path)
        throw 'Path is required!'
    endif

    let l:path = fnamemodify(l:path, ':p')
    let l:path = substitute(l:path, vim_helpers#git#WorkTree() . '/', '', 'g')
    return l:path
endfunction

function! vim_helpers#git#FindRepo() abort
    if exists('b:git_dir') && strlen(b:git_dir)
        return fnamemodify(b:git_dir, ':h')
    endif

    let path = expand('%:p:h')
    if empty(path)
        let path = getcwd()
    endif

    let git_dir = finddir('.git', path . ';')
    if empty(git_dir)
        throw 'Not in git repo!'
    endif

    let b:git_dir = fnamemodify(git_dir, ':p:h')

    return fnamemodify(b:git_dir, ':h')
endfunction

function! vim_helpers#git#WorkTree() abort
    if exists('b:__gitmessenger_popup')
        return gitmessenger#git#root_dir(b:__gitmessenger_popup.opener_bufnr)
    else
        return fnamemodify(b:git_dir, ':h:p')
    endif
endfunction

function! s:SystemRun(cmd, ...) abort
    let cwd = get(a:, 1, '')

    if strlen(cwd)
        let cmd = printf('cd %s && %s', fnameescape(cwd), a:cmd)
    else
        let cmd = a:cmd
    endif

    try
        call vim_helpers#LogCommand(cmd)
        return system(cmd)
    catch /E684/
    endtry

    return ''
endfunction

function! vim_helpers#git#Branches(A, L, P) abort
    try
        let repo_dir = vim_helpers#git#FindRepo()
        let output = s:SystemRun('git branch -a | cut -c 3-', repo_dir)
        let output = substitute(output, '\s->\s[0-9a-zA-Z_\-]\+/[0-9a-zA-Z_\-]\+', '', 'g')
        let output = substitute(output, 'remotes/', '', 'g')
        return output
    catch
        return ''
    endtry
endfunction

" Git Messenger Popup
function! s:ParseGitMessengerRef() abort
    for line in get(b:__gitmessenger_popup, 'contents', [])
        if line =~# '^\s\+Commit:\s\+[a-z0-9]\{40,\}$'
            return get(split(vim_helpers#Strip(line), '\s\+'), -1, '')
        endif
    endfor

    return ''
endfunction

" Fugitive Blame
function! s:ParseFugitiveRef() abort
    let line = vim_helpers#strip(getline('.'))

    let ref = get(split(line, '\s\+'), 0, '')
    if ref !~# '^0\{7,\}$' && ref =~# '^\^\?[a-z0-9]\{7,\}$'
        if ref[0] == '^'
            return printf('"$(git show --summary --format=format:%%h %s)"', ref)
        else
            return ref
        endif
    endif

    return ''
endfunction

function! vim_helpers#git#ParseRef() abort
    if exists('b:__gitmessenger_popup')
        return s:ParseGitMessengerRef()
    else
        return s:ParseFugitiveRef()
    endif
endfunction

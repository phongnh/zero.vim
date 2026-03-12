" Git helpers
function! zero#git#BuildPath(path) abort
    let l:path = empty(a:path) ? expand('%') : a:path

    if empty(l:path)
        throw 'Path is required!'
    endif

    let l:path = fnamemodify(l:path, ':p')
    let l:path = substitute(l:path, zero#git#WorkTree() .. '/', '', 'g')
    return l:path
endfunction

function! zero#git#FindRepo() abort
    if exists('b:git_dir') && !empty(b:git_dir)
        return fnamemodify(b:git_dir, ':h')
    endif

    let l:path = expand('%:p:h')
    if empty(l:path)
        let l:path = getcwd()
    endif

    let l:git_dir = finddir('.git', l:path .. ';')
    if empty(l:git_dir)
        throw 'Not in git repo!'
    endif

    let b:git_dir = fnamemodify(l:git_dir, ':p:h')

    return fnamemodify(b:git_dir, ':h')
endfunction

function! zero#git#WorkTree() abort
    if exists('b:__gitmessenger_popup')
        return gitmessenger#git#root_dir(b:__gitmessenger_popup.opener_bufnr)
    else
        return fnamemodify(b:git_dir, ':h:p')
    endif
endfunction

function! s:SystemRun(cmd, ...) abort
    let l:cwd = get(a:, 1, '')

    if !empty(l:cwd)
        let l:cmd = printf('cd %s && %s', fnameescape(l:cwd), a:cmd)
    else
        let l:cmd = a:cmd
    endif

    try
        call zero#LogCommand(l:cmd)
        return system(l:cmd)
    catch /E684/
    endtry

    return ''
endfunction

function! zero#git#Branches(A, L, P) abort
    try
        let l:repo_dir = zero#git#FindRepo()
        let l:output = s:SystemRun('git branch -a | cut -c 3-', l:repo_dir)
        let l:output = substitute(l:output, '\s->\s[0-9a-zA-Z_\-]\+/[0-9a-zA-Z_\-]\+', '', 'g')
        let l:output = substitute(l:output, 'remotes/', '', 'g')
        return l:output
    catch
        return ''
    endtry
endfunction

" Git Messenger Popup
function! s:ParseGitMessengerContent() abort
    for l:line in get(b:__gitmessenger_popup, 'contents', [])
        if l:line =~# '^\s\+Commit:\s\+[a-z0-9]\{40,\}$'
            return get(split(zero#Trim(l:line), '\s\+'), -1, '')
        endif
    endfor

    return ''
endfunction

" Git Rebase
function! s:ParseGitRebaseLine() abort
    let l:line = zero#Trim(getline('.'))

    if l:line =~# '^\(pick\|edit\|fixup\|squash\|reword\|drop\)\s'
        let [l:_action, l:hash; l:_text] = split(l:line)
        return l:hash
    endif

    return ''
endfunction

" Fugitive Blame
function! s:ParseFugitiveBlameLine() abort
    let l:line = zero#Trim(getline('.'))

    let [l:hash; l:_text] = split(l:line)
    if l:hash !~# '^0\{7,\}$' && l:hash =~# '^\^\?[a-z0-9]\{7,\}$'
        if l:hash[0] == '^'
            let l:new_hash = system('git show -s --format=format:%h ' .. l:hash)
            return !empty(l:new_hash) ? l:new_hash : l:hash[1:]
        else
            return l:hash
        endif
    endif

    return ''
endfunction

function! s:ParseCommitHash() abort
    if exists('b:__gitmessenger_popup')
        return s:ParseGitMessengerContent()
    elseif &filetype ==# 'gitrebase'
        return s:ParseGitRebaseLine()
    else
        return s:ParseFugitiveBlameLine()
    endif
endfunction

function! zero#git#ViewCommit(command)
    let l:hash = s:ParseCommitHash()
    if empty(l:hash)
        return
    endif
    if exists(a:command) == 2
        execute a:command l:hash
    elseif a:command ==# 'gitk'
        call zero#gitk#Gitk(l:hash)
    endif
endfunction

function! zero#git#SetupViewCommit()
    if executable('gitk')
        command! -buffer ViewCommitWithGitk call zero#git#ViewCommit('gitk')
        nnoremap <buffer> <silent> K :<C-U>ViewCommitWithGitk<CR>
    endif

    if exists(':GBrowse') == 2
        command! -buffer ViewCommitWithGBrowse call zero#git#ViewCommit(':GBrowse')
        nnoremap <buffer> <silent> gb :<C-U>ViewCommitWithGBrowse<CR>
    endif

    if exists(':OpenGithubCommit') == 2
        command! -buffer ViewCommitWithGithub call zero#git#ViewCommit(':OpenGithubCommit')
    endif
endfunction


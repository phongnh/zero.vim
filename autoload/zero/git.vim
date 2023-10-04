" Git helpers
function! zero#git#BuildPath(path) abort
    let l:path = empty(a:path) ? expand('%') : a:path

    if empty(l:path)
        throw 'Path is required!'
    endif

    let l:path = fnamemodify(l:path, ':p')
    let l:path = substitute(l:path, zero#git#WorkTree() . '/', '', 'g')
    return l:path
endfunction

function! zero#git#FindRepo() abort
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

function! zero#git#WorkTree() abort
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
        call zero#LogCommand(cmd)
        return system(cmd)
    catch /E684/
    endtry

    return ''
endfunction

function! zero#git#Branches(A, L, P) abort
    try
        let repo_dir = zero#git#FindRepo()
        let output = s:SystemRun('git branch -a | cut -c 3-', repo_dir)
        let output = substitute(output, '\s->\s[0-9a-zA-Z_\-]\+/[0-9a-zA-Z_\-]\+', '', 'g')
        let output = substitute(output, 'remotes/', '', 'g')
        return output
    catch
        return ''
    endtry
endfunction

" Git Messenger Popup
function! s:ParseGitMessengerContent() abort
    for line in get(b:__gitmessenger_popup, 'contents', [])
        if line =~# '^\s\+Commit:\s\+[a-z0-9]\{40,\}$'
            return get(split(zero#Strip(line), '\s\+'), -1, '')
        endif
    endfor

    return ''
endfunction

" Git Rebase
function! s:ParseGitRebaseLine() abort
    let line = zero#Strip(getline('.'))

    if line =~# '^\(pick\|edit\|fixup\|squash\|reword\|drop\)\s'
        let [_action, hash; _text] = split(line)
        return hash
    endif

    return ''
endfunction

" Fugitive Blame
function! s:ParseFugitiveBlameLine() abort
    let line = zero#Strip(getline('.'))

    let [hash; _text] = split(line)
    if hash !~# '^0\{7,\}$' && hash =~# '^\^\?[a-z0-9]\{7,\}$'
        if hash[0] == '^'
            let new_hash = system('git show -s --format=format:%h ' . hash)
            return strlen(new_hash) ? new_hash : hash[1:]
        else
            return hash
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
    let hash = s:ParseCommitHash()
    if empty(hash)
        return
    endif
    if exists(a:command) == 2
        execute a:command hash
    elseif a:command ==# 'gitk'
        call zero#gitk#Gitk(hash)
    elseif a:command ==# 'tig'
        call zero#tig#Tig('show ' . hash)
    endif
endfunction

function! zero#git#SetupViewCommit()
    if executable('gitk')
        command! -buffer ViewCommitWithGitk call zero#git#ViewCommit('gitk')
        nnoremap <buffer> <silent> K :<C-u>ViewCommitWithGitk<CR>
    endif

    if executable('tig')
        command! -buffer ViewCommitWithTig call zero#git#ViewCommit('tig')
        nnoremap <buffer> <silent> T :<C-u>ViewCommitWithTig<CR>
    endif

    if exists(':GBrowse') == 2
        command! -buffer ViewCommitWithGBrowse call zero#git#ViewCommit(':GBrowse')
        nnoremap <buffer> <silent> gb :<C-u>ViewCommitWithGBrowse<CR>
    endif

    if exists(':OpenGithubCommit') == 2
        command! -buffer ViewCommitWithGithub call zero#git#ViewCommit(':OpenGithubCommit')
    endif
endfunction

function! s:UrlEncode(str) abort
  " iconv trick to convert utf-8 bytes to 8bits indiviual char.
  return substitute(iconv(a:str, 'latin1', 'utf-8'), '[^A-Za-z0-9_.~-]', '\="%".printf("%02X",char2nr(submatch(0)))', 'g')
endfunction

function! s:ParseFugitiveRemoteUrl() abort
    let l:remote_url = fnamemodify(FugitiveRemoteUrl(), ':r')
    let [l:user_with_host, l:project; _ignore] = split(remote_url, ':')
    let [_user, l:host] = split(l:user_with_host, '@')
    let [l:owner, l:repo] = split(l:project, '/')
    return [l:host, l:owner, l:repo]
endfunction

function! zero#git#OpenCircleCIDashboard() abort
    let [l:host, l:owner, l:repo] = s:ParseFugitiveRemoteUrl()
    if l:host ==# 'github.com'
        let l:url = printf('https://app.circleci.com/pipelines/github/%s', l:owner)
        execute 'GBrowse' l:url
    endif
endfunction

function! zero#git#OpenCircleCIProject() abort
    let [l:host, l:owner, l:repo] = s:ParseFugitiveRemoteUrl()
    if l:host ==# 'github.com'
        let l:url = printf('https://app.circleci.com/pipelines/github/%s/%s', l:owner, l:repo)
        execute 'GBrowse' l:url
    endif
endfunction

function! zero#git#OpenCircleCIBranch() abort
    let l:branch = FugitiveHead()
    if empty(l:branch)
        call zero#git#OpenCircleCIProject()
    else
        let [l:host, l:owner, l:repo] = s:ParseFugitiveRemoteUrl()
        if l:host ==# 'github.com'
            let l:url = printf('https://app.circleci.com/pipelines/github/%s/%s?branch=%s', l:owner, l:repo, s:UrlEncode(l:branch))
            execute 'GBrowse' l:url
        endif
    endif
endfunction

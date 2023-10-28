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

function! zero#git#ParseGithubRemote() abort
    return s:ParseGithubRemote()
endfunction

function! s:ParseGithubRemote() abort
    let l:remote_url = zero#Strip(system('git ls-remote --get-url'))
    let l:https_repo = '^https\?://\(\%([[:alnum:]-_]\+\.\)*github\.com\)/\([^/]\+\)/\([^/]\+\)$'
    let l:https_personal_access_token_repo = '^https\?://[[:alnum:]]\+:\%(ghp_\)\?[[:alnum:]]\+@\(\%([[:alnum:]-_]\+\.\)*github\.com\)/\([^/]\+\)/\([^/]\+\)$'
    let l:ssh_over_https_repo = '^ssh://git@ssh\.github\.com:443/\([^/]\+\)/\([^/]\+\)$'
    let l:ssh_over_git_repo = '^ssh://git@\(\%([[:alnum:]-_]\+\.\)*github\.com\)/\([^/]\+\)/\([^/]\+\)$'
    let l:git_repo = '^git@\(\%([[:alnum:]-_]\+\.\)*github\.com\):\([^/]\+\)/\([^/]\+\)$'
    if l:remote_url =~# l:https_repo
        let [l:url, l:host, l:owner, l:repo; _ignores] = matchlist(l:remote_url, l:https_repo)
    elseif l:remote_url =~# l:https_personal_access_token_repo
        let [l:url, l:host, l:owner, l:repo; _ignores] = matchlist(l:remote_url, l:https_personal_access_token_repo)
    elseif l:remote_url =~# l:ssh_over_https_repo
        let [l:url, l:host, l:owner, l:repo; _ignores] = matchlist(l:remote_url, l:ssh_over_https_repo)
    elseif l:remote_url =~# l:ssh_over_git_repo
        let [l:url, l:host, l:owner, l:repo; _ignores] = matchlist(l:remote_url, l:ssh_over_git_repo)
    elseif l:remote_url =~# l:git_repo
        let [l:url, l:host, l:owner, l:repo; _ignores] = matchlist(l:remote_url, l:git_repo)
    else
        return {}
    endif
    let l:repo = substitute(l:repo, '\.git$', '', '')
    return { 'host': l:host, 'owner': l:owner, 'repo': l:repo }
endfunction

function! s:GitBranch() abort
    if exists('*FugitiveHead') == 1
        return FugitiveHead()
    else
        let l:branch = zero#Strip(system('git symbolic-ref --short -q HEAD'))
        if l:branch ==# ''
            let l:branch = zero#Strip(system('git rev-parse HEAD'))
        endif
        return l:branch
    endif
endfunction

function! s:OpenCircleCIUrl(opts) abort
    if has_key(a:opts, 'branch') && strlen(a:opts.branch)
        let l:path = printf('%s/%s?branch=%s', a:opts.owner, a:opts.repo, a:opts.branch)
    elseif has_key(a:opts, 'repo')
        let l:path = printf('%s/%s', a:opts.owner, a:opts.repo)
    else
        let l:path = printf('%s', a:opts.owner)
    endif
    if a:opts.host =~# 'github.com'
        let l:provider = 'github'
        let l:url = printf('https://app.circleci.com/pipelines/%s/%s', l:provider, l:path)
        call s:OpenUrl(l:url)
    endif
endfunction

function! s:OpenUrl(opts) abort
    if exists(':OpenBrowser') == 2
        if type(a:opts) == v:t_string
            execute 'OpenBrowser' a:opts
        else
            let l:host = get(a:opts, 'host', 'github.com')
            let l:path = get(a:opts, 'path', '/')
            let l:query = get(a:opts, 'query', '')
            let l:url = printf('https://%s', l:host)
            let l:url .= l:path
            let l:url .= strlen(l:query) ? '?' . query : ''
            execute 'OpenBrowser' l:url
        endif
    endif
endfunction

function! zero#git#OpenCircleCIDashboard() abort
    let l:remote = s:ParseGithubRemote()
    call s:OpenCircleCIUrl({ 'host': l:remote.host, 'owner': l:remote.owner })
endfunction

function! zero#git#OpenCircleCIProject() abort
    let l:remote = s:ParseGithubRemote()
    call s:OpenCircleCIUrl({ 'host': l:remote.host, 'owner': l:remote.owner, 'repo': l:remote.repo })
endfunction

function! zero#git#OpenCircleCIBranch() abort
    let l:remote = s:ParseGithubRemote()
    call s:OpenCircleCIUrl({ 'host': l:remote.host, 'owner': l:remote.owner, 'repo': l:remote.repo, 'branch': s:GitBranch() })
endfunction

" phongnh/zero.vim
" phongnh
function! zero#git#OpenGithubRepo(...) abort
    let l:remote = s:ParseGithubRemote()
    if a:0 > 0
        if stridx(a:1, '/') > -1
            " Assume that is in the format <owner>/<repo>!?
            let [l:owner, l:repo; _ignore] = split(a:1, '/')
            let l:path = printf('%s/%s', l:owner, l:repo)
        else
            let l:path = a:1
        endif
    else
        let l:path = printf('%s/%s', l:remote.owner, l:remote.repo)
    endif
    if l:remote.host =~# 'github.com'
        let l:url = printf('https://github.com/%s', l:path)
        call s:OpenUrl(l:url)
    endif
endfunction

" #100 phongnh/zero.vim
" #100 zero.vim
" phongnh/zero.vim#100
" phongnh/zero.vim
" zero.vim#100
" #100
" 100
function! zero#git#OpenGithubPRs(...) abort
    if a:0 > 1
        let l:parts = split(printf(a:1 =~# '^#' ? '%s%s' : '%s#%s', a:2, a:1), '#')
    else
        let l:parts = split(get(a:, 1, ''), '#')
    endif
    if len(l:parts) > 2
        return
    endif
    let l:remote = s:ParseGithubRemote()
    let [l:host, l:owner, l:repo] = [l:remote.host, l:remote.owner, l:remote.repo]
    if empty(l:parts)
        let l:path = printf('%s/%s/pulls', l:owner, l:repo)
    elseif len(l:parts) == 1
        if l:parts[0] =~# '^\d\+$'
            " It is a PR number
            let l:path = printf('%s/%s/pull/%s', l:owner, l:repo, l:parts[0])
        elseif stridx(l:parts[0], '/') > -1
            " Assume that is in the format <owner>/<repo>!?
            let [l:owner, l:repo; _ignore] = split(l:parts[0], '/')
            let l:path = printf('%s/%s/pulls', l:owner, l:repo)
        else
            " It is a repo name
            let l:path = printf('%s/%s/pulls', l:owner, l:parts[0])
        endif
    else
        let l:pr = l:parts[-1]
        if stridx(l:parts[0], '/') > -1
            " Assume that is in the format <owner>/<repo>!?
            let [l:owner, l:repo; _ignore] = split(l:parts[0], '/')
        else
            " It is a repo name
            let l:repo = l:parts[0]
        endif
        if l:pr =~# '^\d\+$'
            let l:path = printf('%s/%s/pull/%s', l:owner, l:repo, l:pr)
        else
            let l:path = printf('%s/%s/pulls', l:owner, l:repo)
        endif
    endif
    if l:host =~# 'github.com'
        let l:url = printf('https://github.com/%s', l:path)
        call s:OpenUrl(l:url)
    endif
endfunction

function! zero#git#OpenGithubMyPRs() abort
    call s:OpenUrl('https://github.com/pulls')
endfunction

function! zero#git#RemoteBranches(A, L, P) abort
    try
        let repo_dir = zero#git#FindRepo()
        let output = s:SystemRun('git branch -r | cut -f2- -d "/"', repo_dir)
        return output
    catch
        return ''
    endtry
endfunction

function! zero#git#OpenGithubBranch(...) abort
    let l:branch = a:0 > 0 ? a:1 : s:GitBranch()
    if strlen(l:branch)
        let l:remote = s:ParseGithubRemote()
        let [l:host, l:owner, l:repo] = [l:remote.host, l:remote.owner, l:remote.repo]
        if l:host =~# 'github.com'
            let l:url = printf('https://github.com/%s/%s/tree/%s', l:owner, l:repo, l:branch)
            call s:OpenUrl(l:url)
        endif
    else
        call zero#git#OpenGithubRepo()
    endif
endfunction

function! zero#git#OpenGithubFile(...) abort
    let l:branch = s:GitBranch()
    let l:file = a:0 > 0 ? expand(a:1) : expand('%')
    let l:file = fnamemodify(l:file, ':p:.')
    if strlen(l:branch) && strlen(l:file)
        let l:remote = s:ParseGithubRemote()
        let [l:host, l:owner, l:repo] = [l:remote.host, l:remote.owner, l:remote.repo]
        if l:host =~# 'github.com'
            let l:url = printf('https://github.com/%s/%s/blob/%s/%s', l:owner, l:repo, l:branch, l:file)
            call s:OpenUrl(l:url)
        endif
    endif
endfunction

function! zero#git#InsertGithubPR() abort
    let l:parts = split(input('Enter PR (owner/repo#number): '), '#')
    if empty(l:parts) || len(l:parts) > 2 || l:parts[-1] !~# '^\d\+$'
        return
    endif
    let l:remote = s:ParseGithubRemote()
    let [l:owner, l:repo] = [l:remote.owner, l:remote.repo]
    let l:pr = l:parts[-1]
    if len(l:parts) == 1
        " It is a PR number
        let l:path = printf('%s/%s/pull/%s', l:owner, l:repo, l:pr)
    else
        if stridx(l:parts[0], '/') > -1
            " Assume that is in the format <owner>/<repo>!?
            let [l:owner, l:repo; _ignore] = split(l:parts[0], '/')
        else
            " It is a repo name
            let l:repo = l:parts[0]
        endif
        let l:path = printf('%s/%s/pull/%s', l:owner, l:repo, l:pr)
    endif
    return printf('https://github.com/%s', l:path)
endfunction

function! s:UrlEncode(str) abort
  " iconv trick to convert utf-8 bytes to 8bits indiviual char.
  return substitute(iconv(a:str, 'latin1', 'utf-8'), '[^A-Za-z0-9_.~-]', '\="%".printf("%02X",char2nr(submatch(0)))', 'g')
endfunction

function! zero#github#ParseRemote() abort
    return s:ParseRemote()
endfunction

function! s:ParseRemote() abort
    let l:remote_url = zero#Trim(system('git ls-remote --get-url'))
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

function! zero#github#Branch() abort
    return s:GitBranch()
endfunction

function! s:GitBranch() abort
    if exists('*FugitiveHead') == 1
        return FugitiveHead()
    else
        let l:branch = zero#Trim(system('git symbolic-ref --short -q HEAD'))
        if l:branch ==# ''
            let l:branch = zero#Trim(system('git rev-parse HEAD'))
        endif
        return l:branch
    endif
endfunction

function! s:OpenUrl(opts) abort
    if type(a:opts) == v:t_string
        let l:url = a:opts
    else
        let l:host = get(a:opts, 'host', 'github.com')
        let l:path = get(a:opts, 'path', '/')
        let l:query = get(a:opts, 'query', '')
        let l:url = printf('https://%s', l:host)
        let l:url .= l:path
        let l:url .= strlen(l:query) ? '?' . query : ''
    endif
    if exists(':OpenBrowser') == 2
        execute 'OpenBrowser' l:url
    else
        let @" = l:url
        if has('clipboard')
            let [@*, @+] = [@", @"]
        endif
        echo 'Copied: ' . @"
    endif
endfunction

" phongnh/zero.vim
" phongnh
function! zero#github#OpenRepo(...) abort
    let l:remote = s:ParseRemote()
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
function! zero#github#OpenPRs(...) abort
    if a:0 > 1
        let l:parts = split(printf(a:1 =~# '^#' ? '%s%s' : '%s#%s', a:2, a:1), '#')
    else
        let l:parts = split(get(a:, 1, ''), '#')
    endif
    if len(l:parts) > 2
        return
    endif
    let l:remote = s:ParseRemote()
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

function! zero#github#OpenMyPRs() abort
    call s:OpenUrl('https://github.com/pulls')
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

function! zero#github#RemoteBranches(A, L, P) abort
    try
        let repo_dir = zero#git#FindRepo()
        let output = s:SystemRun('git branch -r | cut -f2- -d "/"', repo_dir)
        return output
    catch
        return ''
    endtry
endfunction

function! zero#github#OpenBranch(...) abort
    let l:branch = a:0 > 0 ? a:1 : s:GitBranch()
    if strlen(l:branch)
        let l:remote = s:ParseRemote()
        let [l:host, l:owner, l:repo] = [l:remote.host, l:remote.owner, l:remote.repo]
        if l:host =~# 'github.com'
            let l:url = printf('https://github.com/%s/%s/tree/%s', l:owner, l:repo, l:branch)
            call s:OpenUrl(l:url)
        endif
    else
        call zero#github#OpenRepo()
    endif
endfunction

function! zero#github#OpenFile(...) abort
    let l:branch = s:GitBranch()
    let l:file = a:0 > 0 ? expand(a:1) : expand('%')
    let l:file = fnamemodify(l:file, ':p:.')
    if strlen(l:branch) && strlen(l:file)
        let l:remote = s:ParseRemote()
        let [l:host, l:owner, l:repo] = [l:remote.host, l:remote.owner, l:remote.repo]
        if l:host =~# 'github.com'
            let l:url = printf('https://github.com/%s/%s/blob/%s/%s', l:owner, l:repo, l:branch, l:file)
            call s:OpenUrl(l:url)
        endif
    endif
endfunction

function! zero#github#InsertPR() abort
    let l:parts = split(input('Enter PR (owner/repo#number): '), '#')
    if empty(l:parts) || len(l:parts) > 2 || l:parts[-1] !~# '^\d\+$'
        return
    endif
    let l:remote = s:ParseRemote()
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

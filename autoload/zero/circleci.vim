function! zero#circleci#OpenDashboard(...) abort
    let l:remote = zero#github#ParseRemote()
    let l:filter = get(a:, 1, 0) ? 'mine' : 'all'
    call s:OpenUrl({ 'host': l:remote.host, 'owner': l:remote.owner, 'filter': l:filter })
endfunction

function! zero#circleci#OpenProject(...) abort
    let l:remote = zero#github#ParseRemote()
    let l:filter = get(a:, 1, 0) ? 'mine' : 'all'
    call s:OpenUrl({ 'host': l:remote.host, 'owner': l:remote.owner, 'repo': l:remote.repo, 'filter': l:filter })
endfunction

function! zero#circleci#OpenBranch(...) abort
    let l:remote = zero#github#ParseRemote()
    let l:filter = get(a:, 1, 0) ? 'mine' : 'all'
    call s:OpenUrl({ 'host': l:remote.host, 'owner': l:remote.owner, 'repo': l:remote.repo, 'branch': zero#github#Branch(), 'filter': l:filter })
endfunction

function! zero#circleci#OpenMyPipelines(...) abort
    let l:remote = zero#github#ParseRemote()
    call s:OpenUrl({ 'host': l:remote.host, 'owner': l:remote.owner, 'filter': 'mine' })
endfunction

function! s:OpenUrl(opts) abort
    if has_key(a:opts, 'branch') && strlen(a:opts.branch)
        let l:query = a:opts.filter ==# 'mine' ? 'filter=mine' : printf('branch=%s', a:opts.branch)
        let l:path = printf('%s/%s?%s', a:opts.owner, a:opts.repo, l:query)
    elseif has_key(a:opts, 'repo')
        let l:path = printf('%s/%s?filter=%s', a:opts.owner, a:opts.repo, a:opts.filter)
    else
        let l:path = printf('%s?filter=%s', a:opts.owner, a:opts.filter)
    endif
    if a:opts.host =~# 'github.com'
        let l:provider = 'github'
        let l:url = printf('https://app.circleci.com/pipelines/%s/%s', l:provider, l:path)
        call zero#browser#Open(l:url)
    endif
endfunction

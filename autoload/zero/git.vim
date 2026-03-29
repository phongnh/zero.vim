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

function! s:ViewCommit(command)
    let l:hash = s:ParseCommitHash()
    if empty(l:hash)
        return
    endif
    execute a:command l:hash
endfunction

function! zero#git#SetupViewCommit()
    if exists(':GBrowse') == 2
        nnoremap <buffer> <silent> gb :<C-U>call <SID>ViewCommit(':GBrowse')<CR>
    endif
endfunction

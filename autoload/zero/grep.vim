function! s:OnQuickFixCmdPost(...) abort
    let l:loclist = get(a:, 1, 0)
    if l:loclist
        belowright lwindow
        let l:total = getloclist(0, { 'id': 0, 'size': 0 }).size
    else
        botright cwindow
        let l:total = getqflist({ 'id': 0, 'size': 0 }).size
    endif
    redraw!
    if l:total > 0
        echo printf('Found %d %s.', l:total, l:total == 1 ? 'match' : 'matches')
    else
        echo 'No matches found.'
    endif
endfunction

function! zero#grep#OpenQuickfix() abort
    if exists('*timer_start')
        call timer_start(0, function('s:OnQuickFixCmdPost', [0]))
    else
        call <SID>OnQuickFixCmdPost(0)
    endif
endfunction

function! zero#grep#OpenLocationList() abort
    if exists('*timer_start')
        call timer_start(0, function('s:OnQuickFixCmdPost', [1]))
    else
        call <SID>OnQuickFixCmdPost(1)
    endif
endfunction

function! zero#grep#Exec(opts = {}) abort
    let l:args = get(a:opts, 'args', [])
    let l:args = filter(copy(args), '!empty(v:val)')

    if empty(l:args)
        let l:cword = expand('<cword>')
        if !empty(l:cword)
            let l:args = ['-w', l:cword]
        endif
    endif

    if empty(l:args)
        return
    endif

    let l:path = get(a:opts, 'path', '')
    if !empty(l:path)
        call add(l:args, fnameescape(l:path))
    endif

    let l:cmd = &grepprg .. ' ' .. join(l:args, ' ')
    if get(a:opts, 'cmd', 'grep') ==# 'lgrep'
        lgetexpr system(l:cmd)
        call setloclist(0, [], 'a', { 'title': l:cmd })
        call zero#grep#OpenLocationList()
    else
        cgetexpr system(l:cmd)
        call setqflist([], 'a', { 'title': l:cmd })
        call zero#grep#OpenQuickfix()
    endif
endfunction

function! zero#grep#Grep(...) abort
    call zero#grep#Exec({ 'args': a:000 })
endfunction

function! zero#grep#LGrep(...) abort
    call zero#grep#Exec({ 'cmd': 'lgrep', 'args': a:000 })
endfunction

function! zero#grep#BGrep(...) abort
    call zero#grep#Exec({ 'cmd': 'lgrep', 'args': a:000, 'path': expand('%:p:.') })
endfunction

function! zero#grep#GrepProject(...) abort
    call zero#grep#Exec({ 'args': a:000, 'path': fnamemodify(zero#project#Find(), ':p:.') })
endfunction

function! zero#grep#LGrepProject(...) abort
    call zero#grep#Exec({ 'cmd': 'lgrep', 'args': a:000, 'path': fnamemodify(zero#project#Find(), ':p:.') })
endfunction

function! zero#grep#GrepBufferDir(...) abort
    call zero#grep#Exec({ 'args': a:000, 'path': expand('%:p:.:h') })
endfunction

function! zero#grep#LGrepBufferDir(...) abort
    call zero#grep#Exec({ 'cmd': 'lgrep', 'args': a:000, 'path': expand('%:p:.:h') })
endfunction

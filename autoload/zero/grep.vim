let s:current_job = v:null

function! s:OnQuickFixCmdPost(...) abort
    let l:quickfix = get(a:, 1, 1)
    if l:quickfix
        botright cwindow
        let l:total = getqflist({ 'id': 0, 'size': 0 }).size
    else
        belowright lwindow
        let l:total = getloclist(0, { 'id': 0, 'size': 0 }).size
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
        call timer_start(0, function('s:OnQuickFixCmdPost', [1]))
    else
        call s:OnQuickFixCmdPost(1)
    endif
endfunction

function! zero#grep#OpenLocationList() abort
    if exists('*timer_start')
        call timer_start(0, function('s:OnQuickFixCmdPost', [0]))
    else
        call s:OnQuickFixCmdPost(0)
    endif
endfunction

function! s:BuildGrepprg(grepprg) abort
    if type(a:grepprg) == v:t_list
        return a:grepprg
    endif
    let l:new_grepprg = a:grepprg
    if type(a:grepprg) != v:t_string || empty(a:grepprg)
        let l:new_grepprg = &grepprg
    endif
    let l:cmd = []
    for l:token in split(l:new_grepprg, '\s\+')
        if l:token !~# '^[$%]'
            call add(l:cmd, l:token)
        endif
    endfor
    return l:cmd
endfunction

function! s:ExtractOptions(opts) abort
    let l:options = extend({
                \ 'quickfix': 1,
                \ 'path': [],
                \ 'grepprg': &grepprg,
                \ 'grepformat': &grepformat,
                \ 'append': 0,
                \ 'async': 1,
                \ }, deepcopy(a:opts))

    let l:options.args = get(l:options, 'args', [])
    call filter(l:options.args, '!empty(v:val)')

    if empty(l:options.path)
        let l:options.path = []
    elseif type(l:options.path) == v:t_string
        let l:options.path = [l:options.path]
    elseif type(l:options.path) != v:t_list
        let l:options.path = []
    endif
    call filter(l:options.path, '!empty(v:val)')

    let l:options.grepprg = s:BuildGrepprg(l:options.grepprg)

    return l:options
endfunction

function! s:BuildEscapedPath(paths) abort
    return mapnew(a:paths, 'fnameescape(v:val)')
endfunction

function! s:OnJobExit(opts, job, status) abort
    try
        if a:status < 0
            return
        endif
        if a:status == 0 || a:status == 1
            if a:opts.quickfix
                call zero#grep#OpenQuickfix()
            else
                call zero#grep#OpenLocationList()
            endif
        else
            echoerr 'Grep failed with error code:' status
        endif
    finally
        let s:current_job = v:null
    endtry
endfunction

function! s:ExecAsync(opts = {}) abort
    let l:title = join(a:opts.grepprg + a:opts.args + a:opts.path, ' ')
    let l:efm = a:opts.grepformat
    if a:opts.quickfix
        if !a:opts.append
            call setqflist([])
        endif
        call setqflist([], 'a', { 'title': l:title })
        let l:OnJobOut = {_channel, msg -> setqflist([], 'a', { 'lines': [msg], 'efm': l:efm })}
    else
        if !a:opts.append
            call setloclist(0, [])
        endif
        call setloclist(0, [], 'a', { 'title': l:title })
        let l:OnJobOut = {_channel, msg -> setloclist(0, [], 'a', { 'lines': [msg], 'efm': l:efm })}
    endif

    if exists('s:current_job') && type(s:current_job) == v:t_job && job_status(s:current_job) ==# 'run'
        call job_stop(s:current_job)
    endif

    let l:cmd = join(a:opts.grepprg + a:opts.args + s:BuildEscapedPath(a:opts.path), ' ')
    let s:current_job = job_start([&shell, &shellcmdflag, l:cmd], {
                \ 'in_io': 'null',
                \ 'err_io': 'out',
                \ 'out_cb': l:OnJobOut,
                \ 'exit_cb': function('s:OnJobExit', [a:opts]),
                \ })
endfunction

function! s:ExecSync(opts = {}) abort
    let l:title = join(a:opts.grepprg + a:opts.args + a:opts.path, ' ')
    let l:cmd = join(a:opts.grepprg + a:opts.args + s:BuildEscapedPath(a:opts.path), ' ')

    let l:errorformat = &errorformat
    try
        let &errorformat = a:opts.grepformat
        if a:opts.quickfix
            if a:opts.append
                caddexpr system(l:cmd)
            else
                cgetexpr system(l:cmd)
            endif
            call setqflist([], 'a', { 'title': l:title })
            call zero#grep#OpenQuickfix()
        else
            if a:opts.append
                laddexpr system(l:cmd)
            else
                lgetexpr system(l:cmd)
            endif
            call setloclist(0, [], 'a', { 'title': l:title })
            call zero#grep#OpenLocationList()
        endif
    finally
        let &errorformat = l:errorformat
    endtry
endfunction

function! zero#grep#Exec(opts = {}) abort
    let l:options = s:ExtractOptions(a:opts)

    if empty(l:options.grepprg) || empty(l:options.args)
        return
    endif

    if l:options.async && exists('*job_start')
        call s:ExecAsync(l:options)
    else
        call s:ExecSync(l:options)
    endif
endfunction

function! zero#grep#Grep(...) abort
    call zero#grep#Exec({ 'args': a:000, 'quickfix': 1 })
endfunction

function! zero#grep#LGrep(...) abort
    call zero#grep#Exec({ 'args': a:000, 'quickfix': 0 })
endfunction

function! zero#grep#BGrep(...) abort
    call zero#grep#Exec({ 'args': a:000, 'path': expand('%:p:.'), 'quickfix': 0 })
endfunction

function! zero#grep#GrepProject(...) abort
    call zero#grep#Exec({ 'args': a:000, 'path': fnamemodify(zero#project#Find(), ':p:.'), 'quickfix': 1 })
endfunction

function! zero#grep#LGrepProject(...) abort
    call zero#grep#Exec({ 'args': a:000, 'path': fnamemodify(zero#project#Find(), ':p:.'), 'quickfix': 0 })
endfunction

function! zero#grep#GrepBufferDir(...) abort
    call zero#grep#Exec({ 'args': a:000, 'path': expand('%:p:.:h'), 'quickfix': 1 })
endfunction

function! zero#grep#LGrepBufferDir(...) abort
    call zero#grep#Exec({ 'args': a:000, 'path': expand('%:p:.:h'), 'quickfix': 0 })
endfunction

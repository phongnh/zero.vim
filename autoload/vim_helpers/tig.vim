let s:tig_cmd = 'tig %s'
let s:tig_log_cmd = 'git log --name-only --format= --follow -- %s' . (executable('uniq') ? ' | uniq' . '')
let s:tigrc_user_path = fnamemodify(resolve(expand('<sfile>:p')), ':h:h:h') . '/config/vim.tigrc'
let s:tig_mode = get(g:, 'tig_mode', 'tab')

function! s:UpdateVimSettings() abort
    let s:tig_vim_settings = {
                \ 'showtabline': &showtabline,
                \ 'laststatus': &laststatus,
                \ }
    set showtabline=0
    set laststatus=0
endfunction

function! s:RestoreVimSettings() abort
    for [k, v] in items(s:tig_vim_settings)
        execute printf('set %s=%s', k, string(v))
    endfor
endfunction

function! s:GetTigVimActionFile() abort
    if !exists('s:tig_vim_action_file')
        let s:tig_vim_action_file = tempname()
    endif
    return s:tig_vim_action_file
endfunction

function! s:TigEnvDict(cwd) abort
    return {
                \ 'TIGRC_USER': s:tigrc_user_path,
                \ 'TIG_VIM_ACTION_FILE': s:GetTigVimActionFile(),
                \ 'TIG_VIM_CWD': a:cwd,
                \ }
endfunction

function! s:TigEnvString(cwd) abort
    return printf('TIG_VIM_ACTION_FILE=%s TIGRC_USER=%s TIG_VIM_CWD=%s',
                \ s:GetTigVimActionFile(),
                \ s:tigrc_user_path,
                \ a:cwd
                \ )
endfunction

function! s:OnExitTigCallback(code, cmd, mode) abort
    if a:code != 0
        call vim_helpers#Error(printf('[%s] %s: failed!', a:mode, a:cmd))
        return
    endif

    if exists(':Sayonara') == 2
        silent! Sayonara!
    elseif exists(':Bdelete') == 2
        silent! Bdelete
    else
        silent! buffer #
        silent! hide
    endif

    if s:tig_mode ==# 'tab'
        silent! tabclose
        call s:RestoreVimSettings()
    endif

    call s:OpenTigVimAction(a:cmd)
endfunction

function! s:OpenTigVimAction(cmd)
    if !filereadable(s:tig_vim_action_file)
        call vim_helpers#Error(printf('%s: failed to open vim action file %s!', a:cmd, s:tig_vim_action_file))
        unlet! s:tig_vim_action_file
        return
    endif

    " Restore Goyo mode
    if s:goyo_enabled
        let s:goyo_enabled = 0
        if exists('g:goyo_width') && exists('g:goyo_height')
            execute 'Goyo ' join([g:goyo_width, g:goyo_height], 'x')
        else
            Goyo
        endif
        redraw
    endif

    try
        for action in readfile(s:tig_vim_action_file)
            if action =~# '^Git commit'
                if exists(':Git') == 2
                    execute 'silent! ' . action
                endif
            else
                execute 'silent! ' . action
            endif
        endfor
    finally
    endtry
endfunction

function! s:RunTig(options) abort
    if type(a:options) == type([])
        let opts = join(a:options, ' ')
    else
        let opts = a:options
    endif

    let cwd = vim_helpers#git#WorkTree()
    let cmd = vim_helpers#Strip('tig ' . opts)

    " Use echo as fallback command
    call writefile(['echo'], s:GetTigVimActionFile())
    " Goyo integration
    let s:goyo_enabled = exists('#goyo')

    if has('nvim')
        if s:tig_mode ==# 'tab'
            tabnew
            call s:UpdateVimSettings()
        else
            enew
        endif
        setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile norelativenumber nonumber
        let cmd_with_env = printf('env %s %s', s:TigEnvString(cwd), cmd)
        call vim_helpers#LogCommand(cmd_with_env, 'nvim')
        call termopen(cmd_with_env, {
                    \ 'name': cmd,
                    \ 'cwd': cwd,
                    \ 'clear_env': v:false,
                    \ 'env': s:TigEnvDict(cwd),
                    \ 'on_exit': {job_id, code, event -> s:OnExitTigCallback(code, cmd_with_env, 'nvim')},
                    \ })
        startinsert
    elseif has('terminal')
        if s:tig_mode ==# 'tab'
            tabnew
            call s:UpdateVimSettings()
        endif
        call vim_helpers#LogCommand(cmd, 'terminal')
        let term_options = {
                    \ 'term_name': cmd,
                    \ 'cwd': cwd,
                    \ 'env': s:TigEnvDict(cwd),
                    \ 'curwin': v:true,
                    \ 'exit_cb': {channel, code -> s:OnExitTigCallback(code, cmd, 'terminal')},
                    \ }
        if v:version >= 802
            let term_options['norestore'] = v:true
        endif
        silent call term_start(cmd, term_options)
    else
        let cmd_with_env = printf('env %s %s', s:TigEnvString(cwd), cmd)
        call vim_helpers#LogCommand(cmd_with_env, 'vim')
        execute printf('silent !cd %s && %s', shellescape(cwd), cmd_with_env)
        call s:OpenTigVimAction(cmd_with_env)
        redraw!
    endif
endfunction

function! vim_helpers#tig#Tig(options) abort
    try
        call vim_helpers#git#FindRepo()
        call s:RunTig(a:options)
    catch
        call vim_helpers#Error('Tig: ' . v:exception)
    endtry
endfunction

function! s:TigShellEscape(path) abort
    return '"' . a:path . '"'
endfunction

function! s:TigFullHistoryCommand(path) abort
    return printf('$(' . s:tig_log_cmd . ')', s:TigShellEscape(a:path))
endfunction

function! vim_helpers#tig#TigFile(path, bang) abort
    let l:path = vim_helpers#git#BuildPath(a:path)

    if a:bang
        let l:path = s:TigFullHistoryCommand(l:path)
    else
        let l:path = s:TigShellEscape(l:path)
    endif

    call vim_helpers#tig#Tig('-- ' . l:path)
endfunction

function! vim_helpers#tig#TigBlame(path) abort
    let opts = ['blame']

    if empty(a:path)
        let l:path = vim_helpers#git#BuildPath('')
        call add(opts, '+' . line('.'))
    endif

    call extend(opts, ['--', s:TigShellEscape(l:path)])

    call vim_helpers#tig#Tig(opts)
endfunction

function! vim_helpers#tig#TigStatus() abort
    call vim_helpers#tig#Tig('status')
endfunction

function! vim_helpers#tig#TigOnBlame() abort
    let ref = vim_helpers#git#ParseRef()
    if !empty(ref)
        call s:RunTig('show ' . ref)
    endif
endfunction

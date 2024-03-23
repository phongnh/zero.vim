let s:tig_cmd = 'tig %s'
let s:tig_log_cmd = 'git log --name-only --format= --follow -- %s'
let s:tigrc_user_path = fnamemodify(resolve(expand('<sfile>:p')), ':h:h:h') . '/config/vim.tigrc'
let s:tig_mode = get(g:, 'zero_vim_tig_mode', 'tab')
let s:tig_use_shell = 1

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
                \ 'TIGRC_USER':          shellescape(s:tigrc_user_path),
                \ 'TIG_VIM_ACTION_FILE': shellescape(s:GetTigVimActionFile()),
                \ 'TIG_VIM_CWD':         shellescape(a:cwd),
                \ }
endfunction

function! s:TigEnvString(cwd) abort
    return join(map(items(s:TigEnvDict(a:cwd)), 'join(v:val, "=")'), ' ')
endfunction

function! s:OnExitTigCallback(code, cmd, mode) abort
    if a:code != 0
        call zero#Error(printf('[%s] %s: failed!', a:mode, a:cmd))
        return
    endif

    if exists(':SmartQ') == 2
        silent! SmartQ!
    elseif exists(':Sayonara') == 2
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
        call zero#Error(printf('%s: failed to open vim action file %s!', a:cmd, s:tig_vim_action_file))
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
    let cwd = zero#git#WorkTree()
    let cmd = zero#Trim('tig ' . a:options)

    " Use echo as fallback command
    call writefile(['echo'], s:GetTigVimActionFile())
    " Goyo integration
    let s:goyo_enabled = exists('#goyo')

    if has('nvim')
        call s:OpenTigInNvim(cmd, cwd)
    elseif has('terminal') && !s:tig_use_shell
        call s:OpenTigInTerminal(cmd, cwd)
    else
        call s:OpenTigInShell(cmd, cwd)
    endif
endfunction

function! s:OpenTigInNvim(tig_cmd, cwd) abort
    if s:tig_mode ==# 'tab'
        tabnew
        call s:UpdateVimSettings()
    else
        enew
    endif
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile norelativenumber nonumber
    let cmd = printf('env %s %s', s:TigEnvString(a:cwd), a:tig_cmd)
    call zero#LogCommand(cmd, 'nvim')
    call termopen(cmd, {
                \ 'name': cmd,
                \ 'cwd': a:cwd,
                \ 'clear_env': v:false,
                \ 'env': s:TigEnvDict(a:cwd),
                \ 'on_exit': {job_id, code, event -> s:OnExitTigCallback(code, cmd, 'nvim')},
                \ })
    startinsert
endfunction

function! s:OpenTigInTerminal(tig_cmd, cwd) abort
    if s:tig_mode ==# 'tab'
        tabnew
        call s:UpdateVimSettings()
    endif
    let cmd = a:tig_cmd
    call zero#LogCommand(cmd, 'terminal')
    let term_options = {
                \ 'term_name': cmd,
                \ 'cwd': a:cwd,
                \ 'env': s:TigEnvDict(a:cwd),
                \ 'curwin': v:true,
                \ 'exit_cb': {channel, code -> s:OnExitTigCallback(code, cmd, 'terminal')},
                \ }
    if v:version >= 802
        let term_options['norestore'] = v:true
    endif
    silent call term_start(cmd, term_options)
endfunction

function! s:OpenTigInShell(tig_cmd, cwd) abort
    let cmd = printf('cd %s && env %s %s', shellescape(a:cwd), s:TigEnvString(a:cwd), a:tig_cmd)
    call zero#LogCommand(cmd, 'shell')
    execute printf('silent !%s', cmd)
    call s:OpenTigVimAction(cmd)
    redraw!
endfunction

function! zero#tig#Tig(options) abort
    try
        call zero#git#FindRepo()
        call s:RunTig(a:options)
    catch
        call zero#Error('Tig: ' . v:exception)
    endtry
endfunction

function! s:TigShellEscape(path) abort
    return '"' . a:path . '"'
endfunction

function! s:TigOldPaths(path) abort
    let cmd = printf(s:tig_log_cmd, s:TigShellEscape(a:path))
    return map(uniq(split(system(cmd))), 's:TigShellEscape(v:val)')
endfunction

function! zero#tig#TigFile(path, bang) abort
    try
        call zero#git#FindRepo()

        let l:path = zero#git#BuildPath(a:path)

        if a:bang
            let l:path = join(s:TigOldPaths(l:path), ' ')
        else
            let l:path = s:TigShellEscape(l:path)
        endif

        call s:RunTig('-- ' . l:path)
    catch
        call zero#Error('TigFile: ' . v:exception)
    endtry
endfunction

function! zero#tig#TigBlame(path) abort
    try
        call zero#git#FindRepo()

        let opts = ['blame']

        let l:path = a:path

        if empty(a:path)
            let l:path = zero#git#BuildPath('')
            call add(opts, '+' . line('.'))
        endif

        call extend(opts, ['--', s:TigShellEscape(l:path)])

        call s:RunTig(join(opts, ' '))
    catch
        call zero#Error('TigBlame: ' . v:exception)
    endtry
endfunction

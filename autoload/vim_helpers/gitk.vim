" Gitk
let s:is_windows = has('win64') || has('win32') || has('win32unix') || has('win16')
let s:gitk_cmd = 'gitk %s'
let s:gitk_log_cmd = 'git log --name-only --format= --follow -- %s'

function! s:RunGitk(options) abort
    let cwd = vim_helpers#git#WorkTree()
    let cmd = vim_helpers#Strip(printf(s:gitk_cmd, a:options))
    if has('nvim')
        call s:OpenGitkInNvim(cmd, cwd)
    elseif has('terminal')
        call s:OpenGitkInTerminal(cmd, cwd)
    else
        call s:OpenGitkInShell(cmd, cwd)
    endif
endfunction

function! s:OpenGitkInNvim(gitk_cmd, cwd) abort
    let cmd = a:gitk_cmd
    call vim_helpers#LogCommand(cmd, 'nvim')
    call jobstart(cmd, {
                \ 'cwd': a:cwd,
                \ 'clear_env': v:false,
                \ })
endfunction

function! s:OpenGitkInTerminal(gitk_cmd, cwd) abort
    let cmd = a:gitk_cmd
    call vim_helpers#LogCommand(cmd, 'terminal')
    silent call job_start(cmd, {
                \ 'cwd': a:cwd,
                \ })
endfunction

function! s:OpenGitkInShell(gitk_cmd, cwd) abort
    let cmd = printf('cd %s && %s', shellescape(a:cwd), a:gitk_cmd)
    let cmd .= !s:is_windows ? ' >/dev/null 2>&1 &' : ''
    call vim_helpers#LogCommand(cmd, 'shell')
    execute printf('silent !%s', cmd)
    redraw!
endfunction

function! s:GitkShellEscape(path) abort
    return '"' . a:path . '"'
endfunction

function! s:GitOldPaths(path) abort
    let cmd = printf(s:gitk_log_cmd, a:path)
    return map(uniq(split(system(cmd))), 's:GitkShellEscape(v:val)')
endfunction

function! vim_helpers#gitk#Gitk(options) abort
    try
        call vim_helpers#git#FindRepo()
        call s:RunGitk(a:options)
    catch
        call vim_helpers#Error('Gitk: ' . v:exception)
    endtry
endfunction

function! vim_helpers#gitk#GitkFile(path, bang) abort
    try
        call vim_helpers#git#FindRepo()

        let path = vim_helpers#git#BuildPath(a:path)

        if a:bang
            let path = join(s:GitOldPaths(path), ' ')
        else
            let path = s:GitkShellEscape(path)
        endif

        call s:RunGitk('-- ' . path)
    catch
        call vim_helpers#Error('GitkFile: ' . v:exception)
    endtry
endfunction

function! vim_helpers#gitk#GitkOnBlame() abort
    let ref = vim_helpers#git#ParseRef()
    if !empty(ref)
        call vim_helpers#gitk#Gitk(ref)
    endif
endfunction

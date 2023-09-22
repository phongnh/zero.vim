" Gitk
let s:is_windows = has('win64') || has('win32') || has('win32unix') || has('win16')
let s:gitk_cmd = 'gitk %s'
let s:gitk_log_cmd = 'git log --name-only --format= --follow -- %s'

function! s:RunGitk(options) abort
    let cwd = zero#git#WorkTree()
    let cmd = zero#Strip(printf(s:gitk_cmd, a:options))
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
    call zero#LogCommand(cmd, 'nvim')
    call jobstart(cmd, {
                \ 'cwd': a:cwd,
                \ 'clear_env': v:false,
                \ })
endfunction

function! s:OpenGitkInTerminal(gitk_cmd, cwd) abort
    let cmd = a:gitk_cmd
    call zero#LogCommand(cmd, 'terminal')
    silent call job_start(cmd, {
                \ 'cwd': a:cwd,
                \ })
endfunction

function! s:OpenGitkInShell(gitk_cmd, cwd) abort
    let cmd = printf('cd %s && %s', shellescape(a:cwd), a:gitk_cmd)
    let cmd .= !s:is_windows ? ' >/dev/null 2>&1 &' : ''
    call zero#LogCommand(cmd, 'shell')
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

function! zero#gitk#Gitk(options) abort
    try
        call zero#git#FindRepo()
        call s:RunGitk(a:options)
    catch
        call zero#Error('Gitk: ' . v:exception)
    endtry
endfunction

function! zero#gitk#GitkFile(path, bang) abort
    try
        call zero#git#FindRepo()

        let path = zero#git#BuildPath(a:path)

        if a:bang
            let path = join(s:GitOldPaths(path), ' ')
        else
            let path = s:GitkShellEscape(path)
        endif

        call s:RunGitk('-- ' . path)
    catch
        call zero#Error('GitkFile: ' . v:exception)
    endtry
endfunction

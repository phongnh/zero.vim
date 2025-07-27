" Gitk
let s:gitk_cmd = 'gitk %s'
let s:gitk_log_cmd = 'git log --name-only --format= --follow -- %s'

function! s:RunGitk(options) abort
    let cwd = zero#git#WorkTree()
    let cmd = zero#Trim(printf(s:gitk_cmd, a:options))
    call zero#term#Launch(cmd, { 'cwd': cwd })
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

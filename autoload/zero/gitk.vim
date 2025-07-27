" Gitk
function! s:RunGitk(...) abort
    let cwd = zero#git#WorkTree()
    let cmd = extend(['gitk'], a:000)
    call zero#term#Launch(cmd, { 'cwd': cwd })
endfunction

function! s:GitOldPaths(path) abort
    let cmd = printf('git log --name-only --format= --follow -- %s', shellescape(a:path))
    return uniq(split(system(cmd)))
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
        let path = a:bang ? s:GitOldPaths(path) : [path]
        let path = map(path, 'escape(v:val, " ")')
        call call('s:RunGitk', ['--'] + path)
    catch
        call zero#Error('GitkFile: ' . v:exception)
    endtry
endfunction

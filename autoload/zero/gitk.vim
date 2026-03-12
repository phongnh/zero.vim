" Gitk
function! s:RunGitk(...) abort
    let l:cwd = zero#git#WorkTree()
    let l:cmd = extend(['gitk'], a:000)
    call zero#term#Launch(l:cmd, { 'cwd': l:cwd })
endfunction

function! s:GitOldPaths(path) abort
    let l:cmd = printf('git log --name-only --format= --follow -- %s', shellescape(a:path))
    return uniq(split(system(l:cmd)))
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
        let l:path = zero#git#BuildPath(a:path)
        let l:path = a:bang ? s:GitOldPaths(l:path) : [l:path]
        let l:path = map(l:path, 'escape(v:val, " ")')
        call call('s:RunGitk', ['--'] + l:path)
    catch
        call zero#Error('GitkFile: ' . v:exception)
    endtry
endfunction

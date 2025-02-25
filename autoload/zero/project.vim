" Find project dir from buffer based on root markers
let s:vcs_root_markers = get(g:, 'zero_vim_vcs_root_markers', [
            \ '.git',
            \ '.hg',
            \ '.svn',
            \ '.bzr',
            \ '_darcs',
            \ ])

let s:file_root_markers = get(g:, 'zero_vim_file_root_markers', [
            \ 'Gemfile',
            \ 'rebar.config',
            \ 'mix.exs',
            \ 'Cargo.toml',
            \ 'shard.yml',
            \ 'go.mod',
            \ '.root',
            \ ])

let s:root_markers = s:vcs_root_markers + s:file_root_markers

let s:ignored_root_dirs = get(g:, 'zero_vim_ignored_root_dirs', [
            \ '/',
            \ '/root',
            \ '/Users',
            \ '/home',
            \ '/usr',
            \ '/usr/local',
            \ '/opt',
            \ '/etc',
            \ '/var',
            \ expand('~'),
            \ ])

function! zero#project#find(...) abort
    let l:starting_dir = get(a:, 1, "")

    if type(l:starting_dir) != v:t_string
        let l:starting_dir = ""
    endif

    if empty(l:starting_dir)
        let l:starting_dir = expand('%:p:h')
    endif

    if empty(l:starting_dir) || !isdirectory(l:starting_dir)
        return ''
    endif

    let l:root_dir = ''

    for l:root_marker in s:root_markers
        if index(s:file_root_markers, l:root_marker) > -1
            let l:root_dir = findfile(l:root_marker, l:starting_dir . ';')
        else
            let l:root_dir = finddir(l:root_marker, l:starting_dir . ';')
        endif

        if l:root_dir == l:root_marker
            let l:root_dir = '.'
        else
            let l:root_dir = substitute(l:root_dir, l:root_marker . '$', '', '')
        endif

        if strlen(l:root_dir)
            let l:root_dir = fnamemodify(l:root_dir, ':p:h')
            break
        endif
    endfor

    if empty(l:root_dir) || index(s:ignored_root_dirs, l:root_dir) > -1
        let l:cwd = getcwd()
        if index(s:ignored_root_dirs, cwd) > -1
            let l:root_dir = l:starting_dir
        elseif stridx(l:starting_dir, cwd) == 0
            let l:root_dir = cwd
        else
            let l:root_dir = l:starting_dir
        endif
    endif

    return fnamemodify(l:root_dir, ':p:h:~')
endfunction

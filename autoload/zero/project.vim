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

function! zero#project#Find(...) abort
    " Handle optional starting directory argument
    let l:starting_dir = a:0 > 0 && type(a:1) == v:t_string && !empty(a:1)
                \ ? a:1
                \ : expand('%:p:h')

    " Return empty if directory is invalid
    if empty(l:starting_dir) || !isdirectory(l:starting_dir)
        return ''
    endif

    " Search for VCS markers first (prioritize them as they're more reliable)
    for l:marker in s:vcs_root_markers
        let l:found = finddir(l:marker, l:starting_dir .. ';')
        if !empty(l:found)
            return fnamemodify(l:found, ':p:h:h:~')
        endif
    endfor

    " Search for file markers
    for l:marker in s:file_root_markers
        let l:found = findfile(l:marker, l:starting_dir .. ';')
        if !empty(l:found)
            return fnamemodify(l:found, ':p:h:~')
        endif
    endfor

    " No marker found, determine fallback directory
    let l:cwd = getcwd()

    if index(s:ignored_root_dirs, l:cwd) == -1 && stridx(l:starting_dir, fnamemodify(l:cwd, ':p')) == 0
        " Use cwd if it's valid and starting_dir is under it
        return fnamemodify(l:cwd, ':~')
    else
        " Fall back to starting directory
        return fnamemodify(l:starting_dir, ':~')
    endif
endfunction

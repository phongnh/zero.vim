vim9script

# Find project dir from buffer based on root markers
const vcs_root_markers: list<string> = get(g:, 'zero_vim_vcs_root_markers', [
    '.git',
    '.hg',
    '.svn',
    '.bzr',
    '_darcs',
])

const file_root_markers: list<string> = get(g:, 'zero_vim_file_root_markers', [
    'Gemfile',
    'rebar.config',
    'mix.exs',
    'Cargo.toml',
    'shard.yml',
    'go.mod',
    '.root',
])

const ignored_root_dirs: list<string> = get(g:, 'zero_vim_ignored_root_dirs', [
    '/',
    '/root',
    '/Users',
    '/home',
    '/usr',
    '/usr/local',
    '/opt',
    '/etc',
    '/var',
    expand('~'),
])

export def Find(buffer_dir: string = ''): string
    # Handle optional starting directory argument
    var starting_dir = !empty(buffer_dir) ? buffer_dir : expand('%:p:h')

    # Return empty if directory is invalid
    if empty(starting_dir) || !isdirectory(starting_dir)
        return ''
    endif

    # Search for VCS markers first (prioritize them as they're more reliable)
    for marker in vcs_root_markers
        var found = finddir(marker, starting_dir .. ';')
        if !empty(found)
            return fnamemodify(found, ':p:h:h:~')
        endif
    endfor

    # Search for file markers
    for marker in file_root_markers
        var found = findfile(marker, starting_dir .. ';')
        if !empty(found)
            return fnamemodify(found, ':p:h:~')
        endif
    endfor

    # No marker found, determine fallback directory
    const cwd = getcwd()

    if index(ignored_root_dirs, cwd) == -1 && stridx(starting_dir, fnamemodify(cwd, ':p')) == 0
        # Use cwd if it's valid and starting_dir is under it
        return fnamemodify(cwd, ':~')
    else
        # Fall back to starting directory
        return fnamemodify(starting_dir, ':~')
    endif
enddef

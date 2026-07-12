" Find commands
let s:cache = { 'all': [], 'selected': v:null }
let s:tab = repeat(nr2char(0xa0), 2)

function! s:LiveGrep(arglead, _cmdline, _cursorpos) abort
    return a:arglead->len() > 1 ? systemlist(printf('%s -e "%s"', expandcmd(&grepprg), a:arglead)) : []
endfunction

function! s:LiveGrepLiteral(arglead, _cmdline, _cursorpos) abort
    return a:arglead->len() > 1 ? systemlist(printf('%s -F -- %s', expandcmd(&grepprg), a:arglead)) : []
endfunction

function! s:VisitFile() abort
    if !empty(s:cache.selected)
        let l:qfitem = getqflist({'lines': [s:cache.selected]}).items[0]
        if l:qfitem->has_key('bufnr') && l:qfitem.lnum > 0
            let l:pos = l:qfitem.vcol > 0 ? 'setcharpos' : 'setpos'
            execute printf(':buffer +call\ %s(".",\ [0,\ %d,\ %d,\ 0]) %d', l:pos, l:qfitem.lnum, l:qfitem.col, l:qfitem.bufnr)
            call setbufvar(l:qfitem.bufnr, '&buflisted', 1)
        endif
    endif
endfunction

function! s:Files(...) abort
    let l:dir = a:0 > 0 ? fnamemodify(a:1, ':p:.:h') : '.'
    let l:allfiles = systemlist('git ls-files --cached --others --exclude-standard ' .. shellescape(l:dir))
    if v:shell_error == 0
        return l:allfiles
    endif
    if executable('fd')
        return systemlist('fd . ' .. shellescape(l:dir) .. ' --type file --color never --hidden --follow --exclude ".git/*/"')
        " Print $HOME as ~
        " return systemlist(printf('fd -C %s --type file --color never --hidden --follow --exclude .git --format "%s/{}"', shellescape(l:dir), fnamemodify(l:dir, ':p:~:.:h')))
    endif
    if executable('rg')
        return systemlist('rg ' .. shellescape(l:dir) .. ' --files --color never --hidden --follow --glob "!.git/*/"')
    endif
    return globpath(l:dir, '**', 1, 1)->filter('!isdirectory(v:val)')->map("fnamemodify(v:val, ':.')")
endfunction

function! s:FuzzyFind(arglead, _cmdline, _cursorpos) abort
    if empty(s:cache.all)
        let g:find_root = get(g:, 'find_root', getcwd())
        let s:cache.all = s:Files(g:find_root)
        unlet! g:find_root
    endif
    return a:arglead ==# '' ? s:cache.all : s:cache.all->matchfuzzy(a:arglead)
endfunction

function! s:OpenFile(cmd) abort
    if !empty(s:cache.selected)
        execute a:cmd s:cache.selected
    endif
endfunction

function! s:FuzzyFindMixed(arglead, _cmdline, _cursorpos) abort
    if empty(s:cache.all)
        let g:find_root = get(g:, 'find_root', getcwd())
        let s:cache.all = s:VimRecentFiles() + s:Files(g:find_root)
        unlet! g:find_root
    endif
    return a:arglead ==# '' ? s:cache.all : s:cache.all->matchfuzzy(a:arglead)
endfunction

function! s:AllFiles(...) abort
    let l:dir = a:0 > 0 ? fnamemodify(a:1, ':p:.:h') : '.'
    if executable('fd')
        return systemlist('fd . ' .. shellescape(l:dir) .. ' --type file --color never --no-ignore --hidden --follow --exclude ".git/*/"')
        " Print $HOME as ~
        " return systemlist(printf('fd -C %s --type file --color never --hidden --follow --exclude .git --format "%s/{}"', shellescape(l:dir), fnamemodify(l:dir, ':p:~:.:h')))
    endif
    if executable('rg')
        return systemlist('rg ' .. shellescape(l:dir) .. ' --files --color never --no-ignore --hidden --follow --glob "!.git/*/"')
    endif
    return globpath(l:dir, '**', 1, 1)->filter('!isdirectory(v:val)')->map("fnamemodify(v:val, ':.')")
endfunction

function! s:FuzzyFindAll(arglead, _cmdline, _cursorpos) abort
    if empty(s:cache.all)
        let g:find_root = get(g:, 'find_root', getcwd())
        let s:cache.all = s:AllFiles(g:find_root)
        unlet! g:find_root
    endif
    return a:arglead ==# '' ? s:cache.all : s:cache.all->matchfuzzy(a:arglead)
endfunction

function! s:Unique(list) abort
    let l:visited = {}
    let l:ret = []
    for l:item in a:list
        if !empty(l:item) && !has_key(l:visited, l:item)
            call add(l:ret, l:item)
            let l:visited[l:item] = 1
        endif
    endfor
    return l:ret
endfunction

function! s:Buflisted() abort
    return filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&filetype") !=# "qf"')
endfunction

function! s:VimRecentFiles() abort
    return s:Unique(
                \ map(
                \   filter([expand('%')], 'len(v:val)')
                \   + filter(map(s:Buflisted(), 'bufname(v:val)'), 'len(v:val)')
                \   + filter(copy(v:oldfiles), "filereadable(fnamemodify(v:val, ':p'))"),
                \   'fnamemodify(v:val, ":~:.")'
                \ )
                \ )
endfunction

function! s:FuzzyMru(arglead, _cmdline, _cursorpos) abort
    if empty(s:cache.all)
        let s:cache.all = s:VimRecentFiles()
    endif
    return a:arglead ==# '' ? s:cache.all : s:cache.all->matchfuzzy(a:arglead)
endfunction

function! s:FuzzyMruInCwd(arglead, _cmdline, _cursorpos) abort
    if empty(s:cache.all)
        let s:cache.all = s:VimRecentFiles()->filter('v:val !~# "^[/~]"')
    endif
    return a:arglead ==# '' ? s:cache.all : s:cache.all->matchfuzzy(a:arglead)
endfunction

function! s:FuzzyBuffer(arglead, _cmdline, _cursorpos) abort
    let l:buffers = execute('buffers', 'silent!')->split("\n")
    let l:altbuf = l:buffers->indexof({_k, v -> v =~# '^\s*\d\+\s\+#'})
    if l:altbuf != -1
        let [l:buffers[0], l:buffers[l:altbuf]] = [l:buffers[l:altbuf], l:buffers[0]]
    endif
    return a:arglead ==# '' ? l:buffers : l:buffers->matchfuzzy(a:arglead)
endfunction

function! s:OpenBuffer(cmd) abort
    if !empty(s:cache.selected)
        execute a:cmd s:cache.selected->matchstr('\d\+')
    endif
endfunction

function! s:SelectItem() abort
    let s:cache.selected = ''
    if getcmdline() =~# '^\s*\%(LiveGrepLiteral\|LiveGrep\|TabFind\|SFind\|VFind\|FindAll\|FindMixed\|Find\|FuzzyMruInCwd\|FuzzyMru\|SBuffer\|Buffer\|FuzzyBLines\|FuzzyBOutline\|FuzzyBTags\)\s'
        let l:info = cmdcomplete_info()
        if !empty(l:info) && l:info.pum_visible && !l:info.matches->empty()
            let s:cache.selected = l:info.selected != -1 ? l:info.matches[l:info.selected] : l:info.matches[0]
            call setcmdline(l:info.cmdline_orig) " Preserve search pattern in history
        endif
    endif
endfunction

function! s:BufferLines() abort
    let l:linefmt = '%' .. len(string(line('$'))) .. 'd'
    let l:format = l:linefmt .. s:tab .. '%s'
    return map(getline(1, '$'), 'printf(l:format, v:key + 1, v:val)')
endfunction

function! s:FuzzyBLines(arglead, _cmdline, _cursorpos) abort
    if empty(s:cache.all)
        let s:cache.all = s:BufferLines()
    endif
    return a:arglead ==# '' ? s:cache.all : s:cache.all->matchfuzzy(a:arglead)
endfunction

function! s:VisitLine() abort
    if !empty(s:cache.selected)
        normal! m'
        execute s:cache.selected->matchstr('^\s*\d\+')
        normal! ^zvzz
    endif
endfunction

function! s:AlignLists(lists)
    let l:maxes = {}
    for l:list in a:lists
        let l:i = 0
        while l:i < len(l:list)
            let maxes[l:i] = max([get(l:maxes, l:i, 0), len(l:list[l:i])])
            let l:i += 1
        endwhile
    endfor
    for l:list in a:lists
        call map(l:list, "printf('%-' .. l:maxes[v:key] .. 's', v:val)")
    endfor
    return a:lists
endfunction

function! s:BufOutlineFormat(line) abort
    let l:columns = split(a:line, "\t")
    let l:tag = l:columns[0]
    let [l:linenr, l:preview, _] = split(l:columns[2], ';')
    let l:preview = trim(l:preview[2:-3])
    return join([l:linenr, l:tag, l:preview], "\t")
endfunction

function! s:BufOutline() abort
    if !filereadable(expand('%'))
        throw 'Save the file first'
    endif

    let l:language = get({ 'cpp': 'c++' }, &filetype, &filetype)
    let l:filename = expand('%:S')
    let l:null = has('win32') || has('win64') ? 'nul' : '/dev/null'
    let l:ctags_options = '-f - --sort=no --excmd=combine' .. get({ 'ruby': ' --kinds-ruby=-r' }, l:language, '')
    let l:tag_cmds = [
                \ printf('%s %s --language-force=%s %s 2> %s', 'ctags', l:ctags_options, l:language, l:filename, l:null),
                \ printf('%s %s %s 2> %s', 'ctags', l:ctags_options, l:filename, l:null),
                \ ]

    let l:lines = []

    for l:cmd in l:tag_cmds
        let l:lines = split(system(l:cmd), "\n")
        if !v:shell_error && len(l:lines)
            break
        endif
    endfor

    if v:shell_error
        throw get(l:lines, 0, 'Failed to extract tags')
    elseif empty(l:lines)
        throw 'No tags found'
    endif

    call map(l:lines, 's:BufOutlineFormat(v:val)')

    return map(s:AlignLists(map(l:lines, 'split(v:val, "\t")')), 'join(v:val, s:tab)')
endfunction

function! s:FuzzyBOutline(arglead, _cmdline, _cursorpos) abort
    if empty(s:cache.all)
        let s:cache.all = s:BufOutline()
    endif
    return a:arglead ==# '' ? s:cache.all : s:cache.all->matchfuzzy(a:arglead)
endfunction

function! s:BufTagsFormat(line) abort
    let l:columns = split(a:line, "\t")
    let l:tag = l:columns[0]
    let l:kind = l:columns[3]
    let l:extra = get(l:columns, 4, '')
    let l:linenr = split(l:columns[2], ';')->get(0)
    return join([l:linenr, l:tag, l:kind, l:extra], "\t")
endfunction

function! s:BufTags() abort
    if !filereadable(expand('%'))
        throw 'Save the file first'
    endif

    let l:language = get({ 'cpp': 'c++' }, &filetype, &filetype)
    let l:filename = expand('%:S')
    let l:null = has('win32') || has('win64') ? 'nul' : '/dev/null'
    let l:ctags_options = '-f - --sort=yes --excmd=number' .. get({ 'ruby': ' --kinds-ruby=-r' }, l:language, '')
    let l:tag_cmds = [
                \ printf('%s %s --language-force=%s %s 2> %s', 'ctags', l:ctags_options, l:language, l:filename, l:null),
                \ printf('%s %s %s 2> %s', 'ctags', l:ctags_options, l:filename, l:null),
                \ ]

    let l:lines = []

    for l:cmd in l:tag_cmds
        let l:lines = split(system(l:cmd), "\n")
        if !v:shell_error && len(l:lines)
            break
        endif
    endfor

    if v:shell_error
        throw get(l:lines, 0, 'Failed to extract tags')
    elseif empty(l:lines)
        throw 'No tags found'
    endif

    call map(l:lines, 's:BufTagsFormat(v:val)')

    return map(s:AlignLists(map(l:lines, 'split(v:val, "\t")')), 'join(v:val, s:tab)')
endfunction

function! s:FuzzyBTags(arglead, _cmdline, _cursorpos) abort
    if empty(s:cache.all)
        let s:cache.all = s:BufTags()
    endif
    return a:arglead ==# '' ? s:cache.all : s:cache.all->matchfuzzy(a:arglead)
endfunction

function! g:SetFindRoot(root) abort
    let g:find_root = a:root
    return ''
endfunction

command! -nargs=+ -complete=customlist,<SID>LiveGrep        LiveGrep        call <SID>VisitFile()
command! -nargs=+ -complete=customlist,<SID>LiveGrepLiteral LiveGrepLiteral call <SID>VisitFile()
command! -nargs=* -complete=customlist,<SID>FuzzyFind       Find            call <SID>OpenFile('edit')
command! -nargs=* -complete=customlist,<SID>FuzzyFind       SFind           call <SID>OpenFile('split')
command! -nargs=* -complete=customlist,<SID>FuzzyFind       VFind           call <SID>OpenFile('vertical split')
command! -nargs=* -complete=customlist,<SID>FuzzyFind       TabFind         call <SID>OpenFile('tabedit')
command! -nargs=* -complete=customlist,<SID>FuzzyFindAll    FindAll         call <SID>OpenFile('edit')
command! -nargs=* -complete=customlist,<SID>FuzzyFindMixed  FindMixed       call <SID>OpenFile('edit')
command! -nargs=* -complete=customlist,<SID>FuzzyMru        FuzzyMru        call <SID>OpenFile('edit')
command! -nargs=* -complete=customlist,<SID>FuzzyMruInCwd   FuzzyMruInCwd   call <SID>OpenFile('edit')
command! -nargs=* -complete=customlist,<SID>FuzzyBuffer     Buffer          call <SID>OpenBuffer('buffer')
command! -nargs=* -complete=customlist,<SID>FuzzyBuffer     SBuffer         call <SID>OpenBuffer('sbuffer')
command! -nargs=* -complete=customlist,<SID>FuzzyBLines     FuzzyBLines     call <SID>VisitLine()
command! -nargs=* -complete=customlist,<SID>FuzzyBOutline   FuzzyBOutline   call <SID>VisitLine()
command! -nargs=* -complete=customlist,<SID>FuzzyBTags      FuzzyBTags      call <SID>VisitLine()

augroup ZeroVimFind
    autocmd!
    autocmd CmdlineEnter : let s:cache.all = [] | set pumheight=20
    autocmd CmdlineLeavePre : call <SID>SelectItem() | set pumheight=12
augroup END

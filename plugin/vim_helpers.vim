" vim_helpers.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

if get(g:, 'loaded_vim_helpers', 0)
    finish
endif

let g:vim_helpers_debug = get(g:, 'vim_helpers_debug', 0)

if exists('*trim')
    function! s:strip(str) abort
        return trim(a:str)
    endfunction
else
    function! s:strip(str) abort
        return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
    endfunction
endif

" Search Helpers {{{
    function! s:TrimNewLines(text) abort
        let text = substitute(a:text, '^\n\+', '', 'g')
        let text = substitute(text, '\n\+$', '', 'g')
        return text
    endfunction

    function! s:ShellEscape(text) abort
        if empty(a:text)
            return ''
        endif

        " Escape some characters
        let escaped_text = escape(a:text, '^$.*+?()[]{}|')
        return shellescape(escaped_text)
    endfunction

    function! s:GetSearchText() abort
        let selection = @/

        if selection ==# "\n" || empty(selection)
            return ''
        endif

        return substitute(selection, '^\\<\(.\+\)\\>$', '\\b\1\\b', '')
    endfunction

    function! GetSelectedText() range abort
        " Save the current register and clipboard
        let reg_save     = getreg('"')
        let regtype_save = getregtype('"')
        let cb_save      = &clipboard
        set clipboard&

        " Put the current visual selection in the " register
        normal! ""gvy

        let selection = getreg('"')

        " Put the saved registers and clipboards back
        call setreg('"', reg_save, regtype_save)
        let &clipboard = cb_save

        if selection ==# "\n"
            return ''
        else
            return selection
        endif
    endfunction

    function! GetSelectedTextForShell() range abort
        let selection = s:TrimNewLines(GetSelectedText())
        return s:ShellEscape(selection)
    endfunction

    function! GetSearchTextForShell() abort
        let search = s:GetSearchText()
        return s:ShellEscape(search)
    endfunction

    function! GetWordForSubstitute() abort
        let cword = expand('<cword>')

        if empty(cword)
            return ''
        else
            return cword . '/'
        endif
    endfunction

    function! GetSelectedTextForSubstitute() range abort
        let selection = GetSelectedText()

        " Escape regex characters
        let escaped_selection = escape(selection, '^$.*\/~[]')

        " Escape the line endings
        let escaped_selection = substitute(escaped_selection, '\n', '\\n', 'g')

        return escaped_selection
    endfunction
" }}}

" Copy Commands {{{
    if has('clipboard')
        " Copy yanked text to clipboard
        command! CopyYankedText let [@+, @*] = [@", @"]
    endif

    " Copy path to clipboard
    function! s:copy_path_to_clipboard(path) abort
        let @" = a:path
        if has('clipboard')
            let [@*, @+] = [@", @"]
        endif
        echo 'Copied: ' . @"
    endfunction

    function! s:copy_path(path, line) abort
        let path = expand(a:path)
        if a:line
            let path .= ':' . line('.')
        endif
        call s:copy_path_to_clipboard(path)
    endfunction

    command! -bang CopyRelativePath call <SID>copy_path('%', <bang>0)
    command! -bang CopyFullPath     call <SID>copy_path('%:p', <bang>0)
    command! -bang CopyParentPath   call <SID>copy_path(<bang>0 ? '%:p:h' : '%:h', 0)

    if get(g:, 'copypath_mappings', 1)
        nnoremap <silent> yp :CopyRelativePath<CR>
        nnoremap <silent> yP :CopyRelativePath!<CR>
        nnoremap <silent> yu :CopyFullPath<CR>
        nnoremap <silent> yU :CopyFullPath!<CR>
        nnoremap <silent> yd :CopyParentPath<CR>
        nnoremap <silent> yD :CopyParentPath!<CR>
    endif
" }}}

" Highlight commands {{{
    " Highlight current line
    command! HighlightLine call matchadd('Search', '\%' . line('.') . 'l')

    " Highlight the word underneath the cursor
    command! HighlightWord call matchadd('Search', '\<\w*\%' . line('.') . 'l\%' . col('.') . 'c\w*\>')

    " Highlight the words contained in the virtual column
    command! HighlightColumns call matchadd('Search', '\<\w*\%' . virtcol('.') . 'v\w*\>')

    " Clear the permanent highlights
    command! ClearHightlights call clearmatches()

    if get(g:, 'highlight_mappings', 0)
        nnoremap <silent> <Leader>hl :HighlightLine<CR>
        nnoremap <silent> <Leader>hw :HighlightWord<CR>
        nnoremap <silent> <Leader>hv :HighlightColumns<CR>
        nnoremap <silent> <Leader>hc :ClearHightlights<CR>
    endif
" }}}

" Replace typographic characters
" Copied from https://github.com/srstevenson/dotfiles
function! <SID>replace_typographic_characters() abort
    let l:map = {}
    let l:map['–'] = '--'
    let l:map['—'] = '---'
    let l:map['‘'] = "'"
    let l:map['’'] = "'"
    let l:map['“'] = '"'
    let l:map['”'] = '"'
    let l:map['•'] = '*'
    let l:map['…'] = '...'
    execute ':%substitute/'.join(keys(l:map), '\|').'/\=l:map[submatch(0)]/ge'
endfunction

command! -bar ReplaceTypographicCharacters call <SID>replace_typographic_characters()

" Grep
command! -bar -nargs=+ -complete=file Grep silent! grep! <args> | redraw! | cwindow
command! -nargs=? -complete=file GrepCCword Grep -w '<cword>' <args>
command! -nargs=? -complete=file GrepCword Grep '<cword>' <args>

" LGrep
command! -bar -nargs=+ -complete=file LGrep silent! lgrep! <args> | redraw! | lwindow
command! -nargs=? -complete=file LGrepCCword LGrep -w '<cword>' <args>
command! -nargs=? -complete=file LGrepCword LGrep '<cword>' <args>

" BGrep
command! -bar -nargs=1 BGrep silent! lgrep! <args> % | redraw! | lwindow
command! -nargs=0 BGrepCCword BGrep -w '<cword>'
command! -nargs=0 BGrepCword BGrep '<cword>'

if executable('rg')
    " https://github.com/BurntSushi/ripgrep
    let &grepprg = 'rg -H --no-heading --hidden --vimgrep --smart-case'

    if get(g:, 'grep_ignore_vcs', 0)
        let &grepprg .= ' --no-ignore-vcs'
    endif
elseif executable('ag')
    " https://github.com/ggreer/the_silver_searcher
    let s:default_vcs_ignore = "--ignore '.git' --ignore '.hg' --ignore '.svn' --ignore '.bzr'"
    let &grepprg = 'ag --hidden --vimgrep --smart-case ' . s:default_vcs_ignore

    if get(g:, 'grep_ignore_vcs', 0)
        let &grepprg .= ' --skip-vcs-ignores'
    endif
endif
set grepformat=%f:%l:%c:%m,%f:%l:%m

let s:rg_default_filetype_mappings = {
            \ 'bash':            'sh',
            \ 'javascript':      'js',
            \ 'javascript.jsx':  'js',
            \ 'javascriptreact': 'js',
            \ 'jsx':             'js',
            \ 'python':          'py',
            \ }

let g:rg_filetype_mappings = extend(s:rg_default_filetype_mappings, get(g:, 'rg_filetype_mappings', {}))

let s:ag_default_filetype_mappings = {
            \ 'bash':            'shell',
            \ 'javascript':      'js',
            \ 'javascript.jsx':  'js',
            \ 'javascriptreact': 'js',
            \ 'jsx':             'js',
            \ 'zsh':             'shell',
            \ }

let g:ag_filetype_mappings = extend(s:ag_default_filetype_mappings, get(g:, 'ag_filetype_mappings', {}))

command! -nargs=+ -complete=dir FTGrep execute printf(<SID>strip("Grep %s <args>"), vim_helpers#ParseGrepFileTypeOption(split(&grepprg)[0]))
command! -nargs=? -complete=dir FTGrepCCword FTGrep -w '<cword>' <args>
command! -nargs=? -complete=dir FTGrepCword FTGrep '<cword>' <args>

let s:is_windows = has('win64') || has('win32') || has('win32unix') || has('win16')

" Log command
function! s:LogCommand(cmd, ...) abort
    if !g:vim_helpers_debug
        return
    endif

    let cwd = get(a:, 1, '')
    let cmd = a:cmd

    if strlen(cwd) && cwd != '.'
        let cmd = printf('[%s] %s', cwd, cmd)
    endif

    echomsg cmd
endfunction

function! s:CloseWindowAndDeleteBuffer() abort
    " Close the current window, deleting buffers that are no longer displayed.
    set bufhidden=wipe
    bwipeout!
endfunction

function! s:SystemRun(cmd, ...) abort
    let cwd = get(a:, 1, '')

    if strlen(cwd)
        let cmd = printf('cd %s && %s', fnameescape(cwd), a:cmd)
    else
        let cmd = a:cmd
    endif

    try
        call s:LogCommand(cmd, cwd)
        return system(cmd)
    catch /E684/
    endtry

    return ''
endfunction

function! s:TermopenRun(cmd, cwd) abort
    let cmd = a:cmd
    let cwd = a:cwd

    let l:opts = {
                \ 'on_stderr': 'bdelete!',
                \ }

    function! l:opts.on_exit(job_id, data, event) abort
        call s:CloseWindowAndDeleteBuffer()
    endfunction

    if strlen(cwd)
        let l:opts['cwd'] = cwd
    endif

    call s:LogCommand(cmd, cwd)
    call termopen(cmd, l:opts)
endfunction

function! s:TermStartRun(cmd, cwd) abort
    let cmd = a:cmd
    let cwd = a:cwd

    let l:opts = {
                \ 'hidden': 1,
                \ 'norestore': 1,
                \ 'term_finish': 'close!',
                \ }

    function! l:opts.on_exit(job_id, data, event) abort
        call s:CloseWindowAndDeleteBuffer()
    endfunction

    if strlen(cwd)
        let l:opts['cwd'] = cwd
    endif

    call s:LogCommand(cmd, cwd)
    call term_start(cmd, l:opts)
endfunction

" Git helpers
function! s:FindGitRepo() abort
    if exists('b:git_dir') && strlen(b:git_dir)
        return b:git_dir
    endif

    let path = expand('%:p:h')
    if empty(path)
        let path = getcwd()
    endif

    let git_dir = finddir('.git', path . ';')
    if strlen(git_dir)
        let b:git_dir = fnamemodify(git_dir, ':p:h')
    endif

    return git_dir
endfunction

function! s:InGitRepo() abort
    return strlen(s:FindGitRepo())
endfunction

function! s:GitWorkTree() abort
    if exists('b:git_dir')
        return fnamemodify(b:git_dir, ':h:p')
    endif
    return ''
endfunction

function! s:ListGitBranches(A, L, P) abort
    if s:InGitRepo()
        try
            let output = s:SystemRun('git branch -a | cut -c 3-', s:GitWorkTree())
            let output = substitute(output, '\s->\s[0-9a-zA-Z_\-]\+/[0-9a-zA-Z_\-]\+', '', 'g')
            let output = substitute(output, 'remotes/', '', 'g')
            return output
        catch
            return ''
        endtry
    else
        return ''
    endif
endfunction

function! s:BuildPath(path) abort
    return empty(a:path) ? expand('%') : a:path
endfunction

function! s:ConvertPath(git_dir, path) abort
    let repo_dir = fnamemodify(a:git_dir, ':h:p') . '/'
    let path = fnamemodify(a:path, ':p')
    let path = substitute(path, repo_dir, '', 'g')
    return path
endfunction

let s:git_full_log_cmd = 'git log --name-only --format= --follow -- %s'

if executable('uniq')
    let s:git_full_log_cmd .= ' | uniq'
endif

function! s:GitFullHistoryCommand(path) abort
    return printf('$(' . s:git_full_log_cmd . ')', shellescape(a:path))
endfunction

function! s:ParseRef(line) abort
    if empty(a:line)
        return
    endif
    let line = substitute(a:line, '^\s\+', '', '')
    let line = substitute(line, '\s\+$', '', '')
    let ref = get(split(line, ' '), 0, '')
    if strlen(ref) && (ref !~# '^0\{7,\}$') && ref =~# '^\^\?[a-z0-9]\{7,\}$'
        if ref[0] == '^'
            return printf('"$(git show --summary --format=format:%%h %s)"', ref)
        else
            return ref
        endif
    endif
    return ''
endfunction

" Gitk
if executable('gitk')
    let s:gitk_cmd = 'gitk %s'
    if !s:is_windows
        let s:gitk_cmd .= ' &'
    endif

    function! s:RunGitk(options) abort
        let cmd = printf(s:gitk_cmd, a:options)
        call s:SystemRun(cmd, s:GitWorkTree())
        redraw!
    endfunction

    function! s:Gitk(options) abort
        if s:InGitRepo()
            call s:RunGitk(a:options)
        endif
    endfunction

    function! s:GitkFile(path, bang) abort
        if s:InGitRepo()
            let path = s:BuildPath(a:path)
            if empty(path)
                return
            endif

            let path = s:ConvertPath(b:git_dir, path)

            if a:bang
                call s:RunGitk('-- ' . s:GitFullHistoryCommand(path))
            else
                call s:RunGitk('-- ' . shellescape(path))
            endif
        endif
    endfunction

    command! -nargs=? -complete=custom,<SID>ListGitBranches Gitk call <SID>Gitk(<q-args>)
    command! -nargs=? -bang -complete=file GitkFile call <SID>GitkFile(<q-args>, <bang>0)

    nnoremap <silent> gK :GitkFile<CR>

    function! s:GitkRef(line) abort
        let ref = s:ParseRef(a:line)
        call s:RunGitk(ref)
    endfunction

    augroup CommandHelpersGitk
        autocmd!
        autocmd FileType fugitiveblame nnoremap <buffer> <silent> gK :call <SID>GitkRef(getline('.'))<CR>
    augroup END
endif

if s:is_windows
    finish
endif

" Tig
if executable('tig')
    let s:tig_cmd = 'tig %s'

    if has('nvim')
        " augroup CommandHelpersTigNVim
        "     autocmd!
        "     autocmd TermClose term://*tig* tabclose
        " augroup END

        function! s:RunTig(options) abort
            let cmd = printf(s:tig_cmd, a:options)
            let cwd = s:GitWorkTree()
            tabnew
            call s:TermopenRun(cmd, cwd)
            startinsert
        endfunction
    elseif !has('gui_running')
        function! s:RunTig(options) abort
            let cmd = printf(s:tig_cmd, a:options)
            call s:SystemRun(cmd, s:GitWorkTree())
            redraw!
        endfunction
    else
        function! s:RunTig(options) abort
        endfunction
    endif

    function! s:Tig(options) abort
        if s:InGitRepo()
            call s:RunTig(a:options)
        endif
    endfunction

    function! s:TigFile(path, bang) abort
        if s:InGitRepo()
            let path = s:BuildPath(a:path)
            if empty(path)
                return
            endif

            let path = s:ConvertPath(b:git_dir, path)

            if a:bang
                call s:RunTig('-- ' . s:GitFullHistoryCommand(path))
            else
                call s:RunTig('-- ' . shellescape(path))
            endif
        endif
    endfunction

    function! s:TigBlame(path) abort
        if s:InGitRepo()
            let path = s:BuildPath(a:path)
            if empty(path)
                return
            endif

            let path = s:ConvertPath(b:git_dir, path)

            call s:RunTig('blame -- ' . shellescape(path))
        endif
    endfunction

    function! s:TigStatus() abort
        if s:InGitRepo()
            call s:RunTig('status')
        endif
    endfunction

    command! -nargs=? -complete=custom,<SID>ListGitBranches Tig call <SID>Tig(<q-args>)
    command! -nargs=? -bang -complete=file TigFile call <SID>TigFile(<q-args>, <bang>0)
    command! -nargs=? -complete=file TigBlame call <SID>TigBlame(<q-args>)
    command! -nargs=? TigStatus call <SID>TigStatus()

    nnoremap <silent> gC :TigStatus<CR>
    nnoremap <silent> gL :TigFile<CR>
    nnoremap <silent> gB :TigBlame<CR>

    function! s:TigShow(line) abort
        let ref = s:ParseRef(a:line)
        call s:RunTig('show ' . ref)
    endfunction

    augroup CommandHelpersTig
        autocmd!
        autocmd FileType fugitiveblame nnoremap <buffer> <silent> gB :call <SID>TigShow(getline('.'))<CR>
    augroup END
endif

" Sudo write
command! -bang SW w<bang> !sudo tee >/dev/null %

" Clear terminal console
command! -bar Cls execute 'silent! !clear' | redraw!

let g:loaded_vim_helpers = 1

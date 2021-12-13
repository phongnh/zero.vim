" vim_helpers.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

if get(g:, 'loaded_vim_helpers', 0)
    finish
endif

let g:vim_helpers_debug = get(g:, 'vim_helpers_debug', 0)

" Remove zero-width spaces (<200b>) {{{
command! -bar Remove200b silent! %s/\%u200b//g | update | redraw
command! -bar RemoveZeroWidthSpaces Remove200b
" }}}

" Replace typographic characters
" Copied from https://github.com/srstevenson/dotfiles {{{
function! s:ReplaceTypographicCharacters() abort
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

command! -bar ReplaceTypographicCharacters call <SID>ReplaceTypographicCharacters()
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

    function! s:expand_path(path, line) abort
        let l:path = expand(a:path)
        if a:line
            let l:path .= ':' . line('.')
        endif
        return l:path
    endfunction

    function! s:copy_path(path, line) abort
        call s:copy_path_to_clipboard(s:expand_path(a:path, a:line))
    endfunction

    function! s:copy_path_with_cwd(path, line) abort
        let l:cwd = fnamemodify(getcwd(), ':t')
        call s:copy_path_to_clipboard(l:cwd . '/' . s:expand_path(a:path, a:line))
    endfunction

    command! -bang CopyRelativePath        call <SID>copy_path('%:~:.', <bang>0)
    command! -bang CopyRelativePathWithCwd call <SID>copy_path_with_cwd('%:~:.', <bang>0)
    command! -bang CopyFullPath            call <SID>copy_path('%:p',  <bang>0)
    command! -bang CopyParentPath          call <SID>copy_path(<bang>0 ? '%:p:h' : '%:h', 0)
    command! -bang CopyParentPathWithCwd   call <SID>copy_path_with_cwd('%:h', 0)

    if get(g:, 'copypath_mappings', 1)
        nnoremap <silent> yp :CopyRelativePath<CR>
        nnoremap <silent> yP :CopyRelativePath!<CR>
        nnoremap <silent> yc :CopyRelativePathWithCwd<CR>
        nnoremap <silent> yC :CopyRelativePathWithCwd!<CR>
        nnoremap <silent> yu :CopyFullPath<CR>
        nnoremap <silent> yU :CopyFullPath!<CR>
        nnoremap <silent> yd :CopyParentPath<CR>
        nnoremap <silent> yD :CopyParentPathWithCwd<CR>
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

" Grep Settings
let s:rg_default_filetype_mappings = {
            \ 'bash':            'sh',
            \ 'javascript':      'js',
            \ 'javascript.jsx':  'js',
            \ 'javascriptreact': 'js',
            \ 'jsx':             'js',
            \ 'python':          'py',
            \ }

let g:rg_filetype_mappings = extend(s:rg_default_filetype_mappings, get(g:, 'rg_filetype_mappings', {}))

if executable('rg')
    " https://github.com/BurntSushi/ripgrep
    let &grepprg = 'rg -H --no-heading -n -S --hidden'
    let &grepprg .= get(g:, 'grep_follow_links', 0) ? ' --follow' : ''
    let &grepprg .= get(g:, 'grep_ignore_vcs', 0) ? ' --no-ignore-vcs' : ''
endif

" Grep Helpers
function! s:GrepCmd() abort
    return split(&grepprg, '\s\+')[0]
endfunction

function! s:GrepDir(dir) abort
    let l:dir = fnamemodify(empty(a:dir) ? expand('%') : a:dir, ':~:.:h')
    let l:dir = vim_helpers#Strip(l:dir)

    if empty(l:dir) || l:dir ==# '.' || l:dir =~ '^/' || l:dir =~ '^\~'
        return ''
    endif

    return l:dir
endfunction

function! s:Grep(cmd, ...) abort
    let l:cmd = vim_helpers#Strip(a:cmd . ' ' . join(a:000, ' '))
    call vim_helpers#LogCommand(l:cmd)
    try
        execute l:cmd
    catch
    endtry
endfunction

" Grep
command! -bar -nargs=+ -complete=file        Grep       silent! grep! <args>
command!      -nargs=? -complete=file        GrepCCword call <SID>Grep('Grep', vim_helpers#CCwordForGrep(), <f-args>)
command!      -nargs=? -complete=file        GrepCword  call <SID>Grep('Grep', vim_helpers#CwordForGrep(),  <f-args>)
command!      -nargs=? -complete=file        GrepWord   call <SID>Grep('Grep', vim_helpers#WordForGrep(),   <f-args>)
command!      -nargs=? -complete=file -range GrepVword  call <SID>Grep('Grep', vim_helpers#VwordForGrep(),  <f-args>)
command!      -nargs=? -complete=file        GrepPword  call <SID>Grep('Grep', vim_helpers#PwordForGrep(),  <f-args>)

" LGrep
command! -bar -nargs=+ -complete=file        LGrep       silent! lgrep! <args>
command!      -nargs=? -complete=file        LGrepCCword call <SID>Grep('LGrep', vim_helpers#CCwordForGrep(), <f-args>)
command!      -nargs=? -complete=file        LGrepCword  call <SID>Grep('LGrep', vim_helpers#CwordForGrep(),  <f-args>)
command!      -nargs=? -complete=file        LGrepWord   call <SID>Grep('LGrep', vim_helpers#WordForGrep(),   <f-args>)
command!      -nargs=? -complete=file -range LGrepVword  call <SID>Grep('LGrep', vim_helpers#VwordForGrep(),  <f-args>)
command!      -nargs=? -complete=file        LGrepPword  call <SID>Grep('LGrep', vim_helpers#PwordForGrep(),  <f-args>)

" BGrep
command! -bar -nargs=1        BGrep       silent! lgrep! <args> %
command!      -nargs=0        BGrepCCword call <SID>Grep('BGrep', vim_helpers#CCwordForGrep())
command!      -nargs=0        BGrepCword  call <SID>Grep('BGrep', vim_helpers#CwordForGrep())
command!      -nargs=0        BGrepWord   call <SID>Grep('BGrep', vim_helpers#WordForGrep())
command!      -nargs=0 -range BGrepVword  call <SID>Grep('BGrep', vim_helpers#VwordForGrep())
command!      -nargs=0        BGrepPword  call <SID>Grep('BGrep', vim_helpers#PwordForGrep())

augroup CommandHelpersGrep
    autocmd!
    autocmd QuickFixCmdPost grep*  cwindow | redraw!
    autocmd QuickFixCmdPost lgrep* lwindow | redraw!
augroup END

if s:GrepCmd() =~# 'rg\|grep'
    function! s:ParseFileTypeOption() abort
        let l:cmd = get(a:, 1, s:GrepCmd())

        if l:cmd ==# 'rg'
            return vim_helpers#RgFileTypeOption()
        elseif l:cmd ==# 'grep'
            return vim_helpers#GrepFileTypeOption()
        endif

        return ''
    endfunction

    " TGrep
    command! -nargs=+ -complete=dir TGrep       call <SID>Grep('Grep', <SID>ParseFileTypeOption(), <f-args>)
    command! -nargs=? -complete=dir TGrepCCword call <SID>Grep('Grep', <SID>ParseFileTypeOption(), vim_helpers#CCwordForGrep(), <f-args>)
    command! -nargs=? -complete=dir TGrepCword  call <SID>Grep('Grep', <SID>ParseFileTypeOption(), vim_helpers#CwordForGrep(),  <f-args>)
    command! -nargs=? -complete=dir TGrepWord   call <SID>Grep('Grep', <SID>ParseFileTypeOption(), vim_helpers#WordForGrep(),   <f-args>)

    " FGrep
    command! -nargs=+ -complete=file FGrep       call <SID>Grep('Grep', '--fixed-strings', <f-args>)
    command! -nargs=? -complete=file FGrepCCword call <SID>Grep('Grep', '--fixed-strings', vim_helpers#CCwordForGrep(), <f-args>)
    command! -nargs=? -complete=file FGrepCword  call <SID>Grep('Grep', '--fixed-strings', vim_helpers#CwordForGrep(),  <f-args>)
    command! -nargs=? -complete=file FGrepWord   call <SID>Grep('Grep', '--fixed-strings', vim_helpers#WordForGrep(),   <f-args>)
endif


let s:is_windows = has('win64') || has('win32') || has('win32unix') || has('win16')

" Gitk
if executable('gitk')
    command! -nargs=? -complete=custom,vim_helpers#git#Branches Gitk call vim_helpers#gitk#Gitk(<q-args>)
    command! -bang -nargs=? -complete=file GitkFile call vim_helpers#gitk#GitkFile(<q-args>, <bang>0)

    nnoremap <silent> gK :GitkFile<CR>

    augroup CommandHelpersGitk
        autocmd!
        autocmd FileType fugitiveblame,gitmessengerpopup nnoremap <buffer> <silent> gK :call vim_helpers#gitk#GitkOnBlame()<CR>
    augroup END
endif

if s:is_windows
    finish
endif

" Tig
if executable('tig')
    command! -nargs=? -complete=custom,vim_helpers#git#Branches Tig call vim_helpers#tig#Tig(<q-args>)
    command! -bang -nargs=? -complete=file TigFile call vim_helpers#tig#TigFile(<q-args>, <bang>0)
    command! -nargs=? -complete=file TigBlame call vim_helpers#tig#TigBlame(<q-args>)
    command! -nargs=? TigStatus call vim_helpers#tig#TigStatus()

    nnoremap <silent> gC :TigStatus<CR>
    nnoremap <silent> gL :TigFile<CR>
    nnoremap <silent> gB :TigBlame<CR>

    augroup CommandHelpersTig
        autocmd!
        autocmd FileType fugitiveblame,gitmessengerpopup nnoremap <buffer> <silent> gB :call vim_helpers#tig#TigOnBlame()<CR>
    augroup END
endif

" Sudo write
command! -bang SW w<bang> !sudo tee >/dev/null %

" Clear terminal console
command! -bar Cls execute 'silent! !clear' | redraw!

let g:loaded_vim_helpers = 1

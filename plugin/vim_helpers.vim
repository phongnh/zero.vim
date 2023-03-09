" vim_helpers.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

if get(g:, 'loaded_vim_helpers', 0)
    finish
endif

let s:is_windows = has('win64') || has('win32') || has('win32unix') || has('win16')

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

command! -bang CopyRelativePath         call vim_helpers#path#CopyRelativePath(<bang>0)
command! -bang CopyRelativePathWithCwd  call vim_helpers#path#CopyRelativePathWithCwd(<bang>0)
command! -bang CopyFullPath             call vim_helpers#path#CopyFullPath(<bang>0)
command! -bang CopyParentDirPath        call vim_helpers#path#CopyParentDirPath(<bang>0)
command! -bang CopyParentDirPathWithCwd call vim_helpers#path#CopyParentDirPathWithCwd()

if get(g:, 'vim_helpers_path_mappings', 1)
    nnoremap <silent> yp :CopyRelativePath<CR>
    nnoremap <silent> yP :CopyRelativePath!<CR>
    nnoremap <silent> yc :CopyRelativePathWithCwd<CR>
    nnoremap <silent> yC :CopyRelativePathWithCwd!<CR>
    nnoremap <silent> yu :CopyFullPath<CR>
    nnoremap <silent> yU :CopyFullPath!<CR>
    nnoremap <silent> yd :CopyParentDirPath<CR>
    nnoremap <silent> yD :CopyParentDirPathWithCwd<CR>
endif
" }}}

" Highlight commands {{{
if get(g:, 'vim_helpers_highlight_commands', 0)
    " Highlight current line
    command! HighlightLine call matchadd('Search', '\%' . line('.') . 'l')

    " Highlight the word underneath the cursor
    command! HighlightWord call matchadd('Search', '\<\w*\%' . line('.') . 'l\%' . col('.') . 'c\w*\>')

    " Highlight the words contained in the virtual column
    command! HighlightColumns call matchadd('Search', '\<\w*\%' . virtcol('.') . 'v\w*\>')

    " Clear the permanent highlights
    command! ClearHightlights call clearmatches()

    if get(g:, 'vim_helpers_highlight_mappings', 0)
        nnoremap <silent> <Leader>hl :HighlightLine<CR>
        nnoremap <silent> <Leader>hw :HighlightWord<CR>
        nnoremap <silent> <Leader>hv :HighlightColumns<CR>
        nnoremap <silent> <Leader>hc :ClearHightlights<CR>
    endif
endif
" }}}

" Insert mappings {{{
if get(g:, 'vim_helpers_insert_mappings', 1)
    cnoremap <C-r><C-t> <C-r>=vim_helpers#InsertWord()<CR>
    cnoremap <C-r><C-b> <C-r>=vim_helpers#InsertCCword()<CR>
    cnoremap <C-r><C-_> <C-r>=vim_helpers#InsertPword()<CR>
    cnoremap <C-r>?     <C-r>=vim_helpers#PwordForGrep()<CR>
    cnoremap <C-r><C-d> <C-r>=expand("%:p:h")<CR>
    inoremap <C-r><C-d> <C-r>=expand("%:p:h")<CR>
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

let g:vim_helpers_code_ignore  = get(g:, 'vim_helpers_code_ignore', '.code.ignore')
let g:vim_helpers_grep_ignores = get(g:, 'vim_helpers_grep_ignores', [])

if executable('rg')
    " https://github.com/BurntSushi/ripgrep
    let &grepprg = 'rg -H --no-heading -n -S --hidden'
    let &grepprg .= get(g:, 'grep_follow_links', 0) ? ' --follow' : ''
    let &grepprg .= get(g:, 'grep_ignore_vcs', 0) ? ' --no-ignore-vcs' : ''
endif

if get(g:, 'vim_helpers_grep_commands', 0)
    function! s:GrepCmd() abort
        return split(&grepprg, '\s\+')[0]
    endfunction

    " Grep
    command! -bar -nargs=+ -complete=file        Grep       silent! grep! <args>
    command!      -nargs=? -complete=file        GrepCCword call vim_helpers#grep#Grep(vim_helpers#CCwordForGrep(), <f-args>)
    command!      -nargs=? -complete=file        GrepCword  call vim_helpers#grep#Grep(vim_helpers#CwordForGrep(), <f-args>)
    command!      -nargs=? -complete=file        GrepWord   call vim_helpers#grep#Grep(vim_helpers#WordForGrep(), <f-args>)
    command!      -nargs=? -complete=file -range GrepVword  call vim_helpers#grep#Grep(vim_helpers#VwordForGrep(), <f-args>)
    command!      -nargs=? -complete=file        GrepPword  call vim_helpers#grep#Grep(vim_helpers#PwordForGrep(), <f-args>)

    " LGrep
    command! -bar -nargs=+ -complete=file        LGrep       silent! lgrep! <args>
    command!      -nargs=? -complete=file        LGrepCCword call vim_helpers#grep#LGrep(vim_helpers#CCwordForGrep(), <f-args>)
    command!      -nargs=? -complete=file        LGrepCword  call vim_helpers#grep#LGrep(vim_helpers#CwordForGrep(), <f-args>)
    command!      -nargs=? -complete=file        LGrepWord   call vim_helpers#grep#LGrep(vim_helpers#WordForGrep(), <f-args>)
    command!      -nargs=? -complete=file -range LGrepVword  call vim_helpers#grep#LGrep(vim_helpers#VwordForGrep(), <f-args>)
    command!      -nargs=? -complete=file        LGrepPword  call vim_helpers#grep#LGrep(vim_helpers#PwordForGrep(), <f-args>)

    " BGrep
    command! -bar -nargs=1        BGrep       silent! lgrep! <args> %
    command!      -nargs=0        BGrepCCword call vim_helpers#grep#BGrep(vim_helpers#CCwordForGrep())
    command!      -nargs=0        BGrepCword  call vim_helpers#grep#BGrep(vim_helpers#CwordForGrep())
    command!      -nargs=0        BGrepWord   call vim_helpers#grep#BGrep(vim_helpers#WordForGrep())
    command!      -nargs=0 -range BGrepVword  call vim_helpers#grep#BGrep(vim_helpers#VwordForGrep())
    command!      -nargs=0        BGrepPword  call vim_helpers#grep#BGrep(vim_helpers#PwordForGrep())

    if s:GrepCmd() =~# 'rg\|grep'
        " TGrep
        command! -nargs=+ -complete=dir         TGrep       call vim_helpers#grep#TGrep(<f-args>)
        command! -nargs=? -complete=dir         TGrepCCword call vim_helpers#grep#TGrep(vim_helpers#CCwordForGrep(), <f-args>)
        command! -nargs=? -complete=dir         TGrepCword  call vim_helpers#grep#TGrep(vim_helpers#CwordForGrep(), <f-args>)
        command! -nargs=? -complete=dir         TGrepWord   call vim_helpers#grep#TGrep(vim_helpers#WordForGrep(), <f-args>)
        command! -nargs=? -complete=file -range TGrepVword  call vim_helpers#grep#TGrep(vim_helpers#VwordForGrep(), <f-args>)
        command! -nargs=? -complete=file        TGrepPword  call vim_helpers#grep#TGrep(vim_helpers#PwordForGrep(), <f-args>)

        " FGrep
        command! -nargs=+ -complete=file        FGrep       call vim_helpers#grep#FGrep(<f-args>)
        command! -nargs=? -complete=file        FGrepCCword call vim_helpers#grep#FGrep('-w', vim_helpers#CwordForGrep(), <f-args>)
        command! -nargs=? -complete=file        FGrepCword  call vim_helpers#grep#FGrep(vim_helpers#CwordForGrep(), <f-args>)
        command! -nargs=? -complete=file        FGrepWord   call vim_helpers#grep#FGrep(vim_helpers#WordForGrep(), <f-args>)
        command! -nargs=? -complete=file -range FGrepVword  call vim_helpers#grep#FGrep(vim_helpers#VwordForGrep(), <f-args>)
        command! -nargs=? -complete=file        FGrepPword  call vim_helpers#grep#FGrep(vim_helpers#PwordForGrep(), <f-args>)
    endif

    if s:GrepCmd() =~# 'rg'
        " GrepCode
        command! -nargs=+ -complete=dir         GrepCode       call vim_helpers#grep#GrepCode(<f-args>)
        command! -nargs=? -complete=dir         GrepCodeCCword call vim_helpers#grep#GrepCode(vim_helpers#CCwordForGrep(), <f-args>)
        command! -nargs=? -complete=dir         GrepCodeCword  call vim_helpers#grep#GrepCode(vim_helpers#CwordForGrep(), <f-args>)
        command! -nargs=? -complete=dir         GrepCodeWord   call vim_helpers#grep#GrepCode(vim_helpers#WordForGrep(), <f-args>)
        command! -nargs=? -complete=file -range GrepCodeVword  call vim_helpers#grep#GrepCode(vim_helpers#VwordForGrep(), <f-args>)
        command! -nargs=? -complete=file        GrepCodePword  call vim_helpers#grep#GrepCode(vim_helpers#PwordForGrep(), <f-args>)

        " LGrepCode
        command! -nargs=+ -complete=file        LGrepCode       call vim_helpers#grep#LGrepCode(<f-args>)
        command! -nargs=? -complete=file        LGrepCodeCCword call vim_helpers#grep#LGrepCode(vim_helpers#CCwordForGrep(), <f-args>)
        command! -nargs=? -complete=file        LGrepCodeCword  call vim_helpers#grep#LGrepCode(vim_helpers#CwordForGrep(), <f-args>)
        command! -nargs=? -complete=file        LGrepCodeWord   call vim_helpers#grep#LGrepCode(vim_helpers#WordForGrep(), <f-args>)
        command! -nargs=? -complete=file -range LGrepCodeVword  call vim_helpers#grep#LGrepCode(vim_helpers#VwordForGrep(), <f-args>)
        command! -nargs=? -complete=file        LGrepCodePword  call vim_helpers#grep#LGrepCode(vim_helpers#PwordForGrep(), <f-args>)
    endif

    augroup CommandHelpersGrep
        autocmd!
        autocmd QuickFixCmdPost grep*  cwindow | redraw!
        autocmd QuickFixCmdPost lgrep* lwindow | redraw!
    augroup END
else
    " Grep
    command! -bar -nargs=+ -complete=file Grep  silent! grep! <args> | cwindow | redraw!
    " LGrep
    command! -bar -nargs=+ -complete=file LGrep silent! lgrep! <args> | lwindow | redraw!
    " BGrep
    command! -bar -nargs=1                BGrep silent! lgrep! <args> % | lwindow | redraw!
endif

" Gitk
if executable('gitk')
    command! -nargs=? -complete=custom,vim_helpers#git#Branches Gitk call vim_helpers#gitk#Gitk(<q-args>)
    command! -bang -nargs=? -complete=file GitkFile call vim_helpers#gitk#GitkFile(<q-args>, <bang>0)

    nnoremap <silent> gK :GitkFile<CR>

    augroup CommandHelpersGitk
        autocmd!
        autocmd FileType fugitiveblame,gitmessengerpopup nnoremap <buffer> <silent> gh :call vim_helpers#gitk#GitkOnBlame()<CR>
        autocmd FileType fugitiveblame,gitmessengerpopup nnoremap <buffer> <silent> K  :call vim_helpers#gitk#GitkOnBlame()<CR>
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
        autocmd FileType fugitiveblame,gitmessengerpopup nnoremap <buffer> <silent> T :call vim_helpers#tig#TigOnBlame()<CR>
    augroup END
endif

augroup CommandHelpersGBrowse
    autocmd!
    autocmd FileType fugitiveblame,gitmessengerpopup nnoremap <buffer> <silent> gb :call vim_helpers#git#GBrowseOnBlame()<CR>
augroup END

" Sudo write
command! -bang SW w<bang> !sudo tee >/dev/null %

" Clear terminal console
command! -bar Cls execute 'silent! !clear' | redraw!

let g:loaded_vim_helpers = 1

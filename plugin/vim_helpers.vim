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

command! -bang CopyPath                 call vim_helpers#path#CopyPath(<bang>0)
command! -bang CopyFullPath             call vim_helpers#path#CopyFullPath(<bang>0)
command! -bang CopyAbsolutePath         call vim_helpers#path#CopyAbsolutePath(<bang>0)
command! -bang CopyDirPath              call vim_helpers#path#CopyDirPath(<bang>0)
command! -bang CopyAbsoluteDirPath      call vim_helpers#path#CopyAbsoluteDirPath(<bang>0)

if get(g:, 'vim_helpers_path_mappings', 1)
    nnoremap <silent> yp :CopyPath<CR>
    nnoremap <silent> yP :CopyPath!<CR>
    nnoremap <silent> yc :CopyFullPath<CR>
    nnoremap <silent> yC :CopyFullPath!<CR>
    nnoremap <silent> yu :CopyAbsolutePath<CR>
    nnoremap <silent> yU :CopyAbsolutePath!<CR>
    nnoremap <silent> yd :CopyDirPath<CR>
    nnoremap <silent> yD :CopyDirPath!<CR>
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

    " LGrep
    command! -bar -nargs=+ -complete=file        LGrep       silent! lgrep! <args>
    command!      -nargs=? -complete=file        LGrepCCword call vim_helpers#grep#LGrep(vim_helpers#CCwordForGrep(), <f-args>)
    command!      -nargs=? -complete=file        LGrepCword  call vim_helpers#grep#LGrep(vim_helpers#CwordForGrep(), <f-args>)
    command!      -nargs=? -complete=file        LGrepWord   call vim_helpers#grep#LGrep(vim_helpers#WordForGrep(), <f-args>)
    command!      -nargs=? -complete=file -range LGrepVword  call vim_helpers#grep#LGrep(vim_helpers#VwordForGrep(), <f-args>)

    " BGrep
    command! -bar -nargs=1        BGrep       silent! lgrep! <args> %
    command!      -nargs=0        BGrepCCword call vim_helpers#grep#BGrep(vim_helpers#CCwordForGrep())
    command!      -nargs=0        BGrepCword  call vim_helpers#grep#BGrep(vim_helpers#CwordForGrep())
    command!      -nargs=0        BGrepWord   call vim_helpers#grep#BGrep(vim_helpers#WordForGrep())
    command!      -nargs=0 -range BGrepVword  call vim_helpers#grep#BGrep(vim_helpers#VwordForGrep())

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
        autocmd FileType fugitiveblame,gitmessengerpopup nnoremap <buffer> <silent> K  :<C-u>call vim_helpers#gitk#GitkOnBlame()<CR>
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

    nnoremap <silent> gL :TigFile<CR>
    nnoremap <silent> gB :TigBlame<CR>

    augroup CommandHelpersTig
        autocmd!
        autocmd FileType fugitiveblame,gitmessengerpopup nnoremap <buffer> <silent> T :<C-u>call vim_helpers#tig#TigOnBlame()<CR>
    augroup END
endif

augroup CommandHelpersGBrowse
    autocmd!
    autocmd FileType fugitiveblame,gitmessengerpopup nnoremap <buffer> <silent> gb :<C-u>call vim_helpers#git#GBrowseOnBlame()<CR>
    autocmd FileType fugitiveblame,gitmessengerpopup nnoremap <buffer> <silent> go :<C-u>call vim_helpers#git#GBrowseOnBlame()<CR>
augroup END

" Sudo write
command! -bang SW w<bang> !sudo tee >/dev/null %

" Clear terminal console
command! -bar Cls execute 'silent! !clear' | redraw!

let g:loaded_vim_helpers = 1

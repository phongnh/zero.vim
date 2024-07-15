" zero.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

if get(g:, 'loaded_zero_vim', 0)
    finish
endif

let s:is_windows = has('win64') || has('win32') || has('win32unix') || has('win16')

let g:zero_vim_debug = get(g:, 'zero_vim_debug', 0)

" Remove zero-width spaces (<200b>) {{{
command! -bar Remove200b silent! %s/\%u200b//g | update | redraw
command! -bar RemoveZeroWidthSpaces Remove200b
" }}}

" Replace typographic characters {{{
command! -bar ReplaceTypographicCharacters call zero#ReplaceTypographicCharacters()
" }}}

" Copy Commands {{{
if has('clipboard')
    " Copy yanked text to clipboard
    command! CopyYankedText let [@+, @*] = [@", @"]
endif

command! -bang CopyPath            call zero#path#CopyPath(<bang>0)
command! -bang CopyFullPath        call zero#path#CopyFullPath(<bang>0)
command! -bang CopyAbsolutePath    call zero#path#CopyAbsolutePath(<bang>0)
command! -bang CopyDirPath         call zero#path#CopyDirPath(<bang>0)
command! -bang CopyAbsoluteDirPath call zero#path#CopyAbsoluteDirPath(<bang>0)

if get(g:, 'zero_vim_path_mappings', 1)
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
if get(g:, 'zero_vim_highlight_commands', 0)
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
if get(g:, 'zero_vim_insert_mappings', 1)
    cnoremap <C-r><C-w> <C-r>=zero#InsertCword()<CR>
    cnoremap <C-r><C-b> <C-r>=zero#InsertCCword()<CR>
    cnoremap <C-r><C-t> <C-r>=zero#InsertWord()<CR>
    cnoremap <C-r><C-v> <C-r>=zero#InsertVword()<CR>
    cnoremap <C-r><C-_> <C-r>=zero#InsertPword()<CR>
    cnoremap <C-r>?     <C-r>=zero#InsertGrepPword()<CR>
    cnoremap <C-r><C-d> <C-r>=expand("%:p:h")<CR>
    inoremap <C-r><C-d> <C-r>=expand("%:p:h")<CR>
endif
" }}}

" Grep Settings
if executable('rg')
    " https://github.com/BurntSushi/ripgrep
    let &grepprg = 'rg --line-buffered -H --no-heading -n -S --hidden'
    let &grepprg .= get(g:, 'zero_vim_grep_follow_links', get(g:, 'zero_vim_follow_links', 0)) ? ' --follow' : ''
    let &grepprg .= get(g:, 'zero_vim_grep_ignore_vcs', 0) ? ' --no-ignore-vcs' : ''
endif

" Grep
function! s:Grep(cmd, args, path) abort
    let l:args = escape(a:args, '\"')
    let l:grepprg = &grepprg . ' ' . l:args . ' '
    let l:errorformat = &errorformat
    let &errorformat = &grepformat
    try
        if a:path ==# ''
            execute a:cmd . ' system("' . l:grepprg . '")'
        else
            execute a:cmd . ' system("' . l:grepprg . shellescape(a:path) . '")'
        endif
    catch
        call zero#Error(printf('%s: `%s` failed!', a:cmd, l:grepprg))
    finally
        let &errorformat = l:errorformat
    endtry
endfunction

command! -complete=file_in_path -nargs=+ Grep     call s:Grep('cgetexpr', <q-args>, ''            )
command!                        -nargs=+ GrepDir  call s:Grep('cgetexpr', <q-args>, expand('%:p:h'))
command! -complete=file_in_path -nargs=+ LGrep    call s:Grep('lgetexpr', <q-args>, ''            )
command!                        -nargs=+ LGrepDir call s:Grep('lgetexpr', <q-args>, expand('%:p:h'))
command!                        -nargs=+ BGrep    call s:Grep('lgetexpr', <q-args>, expand('%:p') )


function! s:with_grep_format(cmd, prg, args, path) abort
    let l:args = escape(a:args, '\"')
    let l:saved_errorformat = &errorformat
    let &errorformat = &grepformat
    try
        if a:path ==# ''
            exe a:cmd . ' system("' . a:prg . ' ' . l:args . ' ")'
        else
            exe a:cmd . ' system("' . a:prg . ' ' . l:args . ' ' . shellescape(a:path) . '")'
        endif
    finally
        let &errorformat = l:saved_errorformat
    endtry
endfunction

command!  -complete=file_in_path -nargs=+ GrepProject  call s:with_grep_format('cgetexpr', &grepprg,    <q-args>, ''            )
command!                         -nargs=+ GrepDir      call s:with_grep_format('cgetexpr', &grepprg,    <q-args>, expand('%:p:h'))
command!  -complete=file_in_path -nargs=+ LGrepProject call s:with_grep_format('lgetexpr', &grepprg,    <q-args>, ''            )
command!                         -nargs=+ LGrepDir     call s:with_grep_format('lgetexpr', &grepprg,    <q-args>, expand('%:p:h'))
command!                         -nargs=+ LGrepFile    call s:with_grep_format('lgetexpr', &grepprg,    <q-args>, expand('%:p') )
command!                         -nargs=+ GrepDiff     call s:with_grep_format('cgetexpr', 'grep_diff', <q-args>, ''            )

command! -nargs=+ -complete=file_in_path Grep  call zero#grep#Grep(<q-args>, '')
command! -nargs=+ -complete=file_in_path LGrep call zero#grep#LGrep(<q-args>)
command! -nargs=+                        BGrep call zero#grep#LGrep(<q-args>, expand('%:p'))

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

" Gitk
if executable('gitk')
    command! -nargs=? -complete=custom,zero#git#Branches Gitk     call zero#gitk#Gitk(<q-args>)
    command! -bang -nargs=? -complete=file               GitkFile call zero#gitk#GitkFile(<q-args>, <bang>0)
endif

if s:is_windows
    finish
endif

" Tig
if executable('tig')
    command! -nargs=? -complete=custom,zero#git#Branches Tig      call zero#tig#Tig(<q-args>)
    command! -bang -nargs=? -complete=file               TigFile  call zero#tig#TigFile(<q-args>, <bang>0)
    command! -nargs=? -complete=file                     TigBlame call zero#tig#TigBlame(<q-args>)
endif

" Depends on openbrowser
function! s:SetupCommands() abort
    if exists(':OpenBrowser') != 2
        return
    endif

    " CircleCI
    command! OpenCircleCIDashboard call zero#git#OpenCircleCIDashboard()
    command! OpenCircleCIProject call zero#git#OpenCircleCIProject()
    command! OpenCircleCIBranch call zero#git#OpenCircleCIBranch()

    " GitHub
    command! -nargs=? OpenGithubRepo call zero#git#OpenGithubRepo(<f-args>)
    command! -nargs=* OpenGithubPRs call zero#git#OpenGithubPRs(<f-args>)
    command! OpenGithubMyPRs call zero#git#OpenGithubMyPRs()
    command! -nargs=? -complete=custom,zero#git#RemoteBranches OpenGithubBranch call zero#git#OpenGithubBranch(<f-args>)
    if exists(':OpenGithubFile') != 2
        command! -nargs=? -complete=file OpenGithubFile call zero#git#OpenGithubFile(<f-args>)
    endif

    inoremap <C-x>g <C-r>=zero#git#InsertGithubPR()<CR>
endfunction

augroup ZeroVimGithubCommands
    autocmd!
    autocmd VimEnter * call <SID>SetupCommands()
augroup END

" Sudo write
command! -bang SW w<bang> !sudo tee >/dev/null %

" Clear terminal console
command! -bar Cls execute 'silent! !clear' | redraw!

let g:loaded_zero_vim = 1

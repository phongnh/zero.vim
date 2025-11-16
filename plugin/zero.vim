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

" CircleCI
command! -bang OpenCircleCIDashboard   call zero#circleci#OpenDashboard(<bang>0)
command! -bang OpenCircleCIProject     call zero#circleci#OpenProject(<bang>0)
command! -bang OpenCircleCIBranch      call zero#circleci#OpenBranch(<bang>0)
command! -bang OpenCircleCIMyPipelines call zero#circleci#OpenMyPipelines(<bang>0)

" GitHub
command!                                                      OpenGitHubMyPRs  call zero#github#OpenMyPRs()
command! -nargs=?                                             OpenGitHubRepo   call zero#github#OpenRepo(<f-args>)
command! -nargs=*                                             OpenGitHubPRs    call zero#github#OpenPRs(<f-args>)
command! -nargs=? -complete=custom,zero#github#RemoteBranches OpenGitHubBranch call zero#github#OpenBranch(<f-args>)
command! -nargs=? -complete=file                              OpenGitHubFile   call zero#github#OpenFile(<f-args>)

" Grep Settings
if executable('rg')
    " https://github.com/BurntSushi/ripgrep
    let &grepprg = 'rg --line-buffered -H --no-heading -n -S --hidden'
    let &grepprg .= get(g:, 'zero_vim_grep_follow_links', get(g:, 'zero_vim_follow_links', 0)) ? ' --follow' : ''
    let &grepprg .= get(g:, 'zero_vim_grep_ignore_vcs', 0) ? ' --no-ignore-vcs' : ''
endif

" Grep
command! -nargs=+ -complete=file_in_path Grep  call zero#grep#Grep(<f-args>)
command! -nargs=+ -complete=file_in_path LGrep call zero#grep#LGrep(<f-args>)
command! -nargs=+                        BGrep call zero#grep#LGrep(<f-args>, '%')

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

" Gitk
if executable('gitk')
    command! -nargs=? -complete=custom,zero#git#Branches Gitk     call zero#gitk#Gitk(expand(<q-args>))
    command! -bang -nargs=? -complete=file               GitkFile call zero#gitk#GitkFile(expand(<q-args>), <bang>0)
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

" Sudo write
command! -bang SW w<bang> !sudo tee >/dev/null %

" Clear terminal console
command! -bar Cls execute 'silent! !clear' | redraw!

let g:loaded_zero_vim = 1

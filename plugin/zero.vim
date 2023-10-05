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

command! -bang CopyPath            call zero#path#CopyPath(<bang>0)
command! -bang CopyFullPath        call zero#path#CopyFullPath(<bang>0)
command! -bang CopyAbsolutePath    call zero#path#CopyAbsolutePath(<bang>0)
command! -bang CopyDirPath         call zero#path#CopyDirPath(<bang>0)
command! -bang CopyAbsoluteDirPath call zero#path#CopyAbsoluteDirPath(<bang>0)

if get(g:, 'zero_vim_mappings', 1)
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
    let &grepprg = 'rg -H --no-heading -n -S --hidden'
    let &grepprg .= get(g:, 'zero_vim_grep_follow_links', get(g:, 'zero_vim_follow_links', 0)) ? ' --follow' : ''
    let &grepprg .= get(g:, 'zero_vim_grep_ignore_vcs', 0) ? ' --no-ignore-vcs' : ''
endif

" Grep
command! -bar -nargs=+ -complete=file Grep  silent! grep! <args> | botright cwindow | redraw!
command! -bar -nargs=+ -complete=file LGrep silent! lgrep! <args> | lwindow | redraw!
command! -bar -nargs=1                BGrep silent! lgrep! <args> % | lwindow | redraw!

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

" Depends on vim-fugitive
if findfile('plugin/fugitive.vim', &rtp) != ''
    function! s:SetupCommands() abort
        " CircleCI
        command! OpenCircleCIDashboard call zero#git#OpenCircleCIDashboard()
        command! OpenCircleCIProject call zero#git#OpenCircleCIProject()
        command! OpenCircleCIBranch call zero#git#OpenCircleCIBranch()

        " GitHub
        command! OpenGithubRepo call zero#git#OpenGithubRepo()
        command! -nargs=? OpenGithubPRs call zero#git#OpenGithubPRs(<q-args>)
        command! OpenGithubMyPRs call zero#git#OpenGithubMyPRs()
        command! OpenGithubBranch call zero#git#OpenGithubBranch()
        command! OpenGithubDir call zero#git#OpenGithubDir()
        if exists(':OpenGithubFile') != 2
            command! OpenGithubFile call zero#git#OpenGithubFile()
        endif
    endfunction

    augroup ZeroVimGithubCommands
        autocmd!
        autocmd VimEnter * call <SID>SetupCommands()
    augroup END
endif

" Sudo write
command! -bang SW w<bang> !sudo tee >/dev/null %

" Clear terminal console
command! -bar Cls execute 'silent! !clear' | redraw!

let g:loaded_zero_vim = 1

" zero.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

if get(g:, 'loaded_zero_vim', 0)
    finish
endif

let g:zero_vim_debug = get(g:, 'zero_vim_debug', 0)

" Replace typographic characters {{{
command! -bar ReplaceTypographicCharacters call zero#ReplaceTypographicCharacters()
" }}}

" Highlight commands {{{
if get(g:, 'zero_vim_highlight_commands', 0)
    " Highlight current line
    command! HighlightLine call matchadd('Search', '\%' .. line('.') .. 'l')

    " Highlight the word underneath the cursor
    command! HighlightWord call matchadd('Search', '\<\w*\%' .. line('.') .. 'l\%' .. col('.') .. 'c\w*\>')

    " Highlight the words contained in the virtual column
    command! HighlightColumns call matchadd('Search', '\<\w*\%' .. virtcol('.') .. 'v\w*\>')

    " Clear the permanent highlights
    command! ClearHightlights call clearmatches()
endif
" }}}

" GitHub
command!                                                      OpenGitHubMyPRs  call zero#github#OpenMyPRs()
command! -nargs=?                                             OpenGitHubRepo   call zero#github#OpenRepo(<f-args>)
command! -nargs=*                                             OpenGitHubPRs    call zero#github#OpenPRs(<f-args>)
command! -nargs=? -complete=custom,zero#github#RemoteBranches OpenGitHubBranch call zero#github#OpenBranch(<f-args>)
command! -nargs=? -complete=file                              OpenGitHubFile   call zero#github#OpenFile(<f-args>)

" Gitk
if executable('gitk')
    command! -nargs=? -complete=custom,zero#git#Branches Gitk     call zero#gitk#Gitk(expand(<q-args>))
    command! -bang -nargs=? -complete=file               GitkFile call zero#gitk#GitkFile(expand(<q-args>), <bang>0)
endif

let g:loaded_zero_vim = 1

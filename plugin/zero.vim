if has('nvim') || exists('g:loaded_zero_vim')
    finish
endif

let g:loaded_zero_vim = 1

" Save cpoptions
let s:save_cpo = &cpoptions
set cpoptions&vim

if get(g:, 'zero_path_user_commands', 0)
    command! -bang CopyPath            call zero#path#CopyPath(<bang>0)
    command! -bang CopyFullPath        call zero#path#CopyFullPath(<bang>0)
    command! -bang CopyAbsolutePath    call zero#path#CopyAbsolutePath(<bang>0)
    command!       CopyDirPath         call zero#path#CopyDirPath()
    command!       CopyFullDirPath     call zero#path#CopyFullDirPath()
    command!       CopyAbsoluteDirPath call zero#path#CopyAbsoluteDirPath()
endif

if get(g:, 'zero_path_mappings', 1)
    nnoremap <silent> yc :<C-U>call zero#path#CopyPath(0)<CR>
    nnoremap <silent> yC :<C-U>call zero#path#CopyPath(1)<CR>
    nnoremap <silent> yp :<C-U>call zero#path#CopyFullPath(0)<CR>
    nnoremap <silent> yP :<C-U>call zero#path#CopyFullPath(1)<CR>
    nnoremap <silent> yu :<C-U>call zero#path#CopyAbsolutePath(0)<CR>
    nnoremap <silent> yU :<C-U>call zero#path#CopyAbsolutePath(1)<CR>
    nnoremap <silent> y. :<C-U>call zero#path#CopyDirPath()<CR>
    nnoremap <silent> yd :<C-U>call zero#path#CopyFullDirPath()<CR>
    nnoremap <silent> yD :<C-U>call zero#path#CopyAbsoluteDirPath()<CR>
endif

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

" Restore cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo

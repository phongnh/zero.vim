" Exchange gj and gk to j and k {
function! zero#toggle#ToggleGJK() abort
    if empty(mapcheck('j', 'n')) || empty(mapcheck('k', 'n'))
        nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
        xnoremap <expr> j v:count == 0 ? 'gj' : 'j'
        nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
        xnoremap <expr> k v:count == 0 ? 'gk' : 'k'
        nnoremap gj j
        xnoremap gj j
        nnoremap gk k
        xnoremap gk k
        echo 'Enabled gj and gk!'
    else
        silent! nunmap j
        silent! xunmap j
        silent! nunmap k
        silent! xunmap k
        silent! nunmap gj
        silent! xunmap gj
        silent! nunmap gk
        silent! xunmap gk
        echo 'Disabled gj and gk!'
    endif
endfunction
" }

" Toggle Indent Guides {
function! zero#toggle#ToggleLeadmultispace() abort
    if &listchars =~# '\V\<leadmultispace\>'
        execute printf('set listchars-=leadmultispace:┊%s listchars?', escape(repeat(' ', &shiftwidth - 1), ' '))
    else
        execute printf('set listchars+=leadmultispace:┊%s listchars?', escape(repeat(' ', &shiftwidth - 1), ' '))
    endif
endfunction

function! zero#toggle#AdjustLeadmultispace(shiftwidth_old, shiftwidth_new) abort
    if &listchars =~# '\V\<leadmultispace\>'
        execute printf('set listchars-=leadmultispace:┊%s', escape(repeat(' ', a:shiftwidth_old - 1), ' '))
        execute printf('set listchars+=leadmultispace:┊%s', escape(repeat(' ', a:shiftwidth_new - 1), ' '))
    endif
endfunction
" }

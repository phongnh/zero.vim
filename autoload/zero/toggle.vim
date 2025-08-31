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

" Toggle clipboard {
if has('clipboard')
    function! zero#toggle#ToggleClipboard() abort
        let l:clipboard = has('unnamedplus') ? 'unnamedplus' : 'unnamed'
        if match(&clipboard, l:clipboard) > -1
            execute printf('set clipboard-=%s', l:clipboard)
            echo printf('Disabled "%s" clipboard!', l:clipboard)
        else
            execute printf('set clipboard^=%s', l:clipboard)
            echo printf('Enabled "%s" clipboard!', l:clipboard)
        endif
    endfunction
endif
" }

" Toggle conceallevel {
if has('conceal')
    function! zero#toggle#ToggleConceallevel() abort
        if &conceallevel > 0
            set conceallevel=0
        else
            set conceallevel=2
        endif
        set conceallevel?
    endfunction
endif
" }

" Toggle background {
function! zero#toggle#ToggleBackground() abort
    if &background == 'dark'
        set background=light background?
    else
        set background=dark background?
    endif
endfunction
" }

" Toggle diff {
function! zero#toggle#ToggleDiff() abort
    if &diff
        diffoff
        echo 'diffoff'
    else
        diffthis
        echo 'diffthis'
    endif
endfunction
" }

" Cycle Diff Option {
function! zero#toggle#CycleDiffOption() abort
    if &diffopt =~# 'algorithm'
        if &diffopt =~# 'algorithm:patience'
            set diffopt-=algorithm:myers diffopt-=algorithm:minimal diffopt-=algorithm:patience diffopt+=algorithm:histogram
        else
            set diffopt-=algorithm:myers diffopt-=algorithm:minimal diffopt-=algorithm:histogram diffopt+=algorithm:patience
        endif
    else
        set diffopt+=algorithm:patience
    endif
    set diffopt?
endfunction
" }

" Toggle virtualedit {
function! zero#toggle#ToggleVirtualEditAll() abort
    if &virtualedit =~# 'all'
        set virtualedit-=all
        echo 'set virtualedit-=all'
    else
        set virtualedit+=all
        echo 'set virtualedit+=all'
    endif
endfunction
" }

" Toggle cursorline and cursorcolumn {
function! zero#toggle#ToggleCursorOptions() abort
    if &cursorline && &cursorcolumn
        set nocursorline nocursorcolumn
        echo 'set nocursorline nocursorcolumn'
    else
        set cursorline cursorcolumn
        echo 'set cursorline cursorcolumn'
    endif
endfunction
" }

" Toggle colorcolumn {
function! zero#toggle#ToggleColorColumn() abort
    if !empty(&colorcolumn)
        let s:colorcolumn = &colorcolumn
    endif
    if !empty(&colorcolumn)
        set colorcolumn=
    else
        execute printf('set colorcolumn=%s', get(s:, 'colorcolumn', '+1'))
    endif
    set colorcolumn?
endfunction
" }

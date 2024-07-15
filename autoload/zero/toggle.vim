" Enable/disable gt/gT to cycle buffers when VIM has only one tabpage {
function! zero#toggle#CycleBuffersWithTabMappings() abort
    if empty(mapcheck('gt', 'n')) || empty(mapcheck('gT', 'n'))
        nnoremap <silent> <expr> gt printf(":\<C-u>%s%s\<CR>", v:count > 0 ? v:count : '', tabpagenr('$') == 1 ? 'bnext' : 'tabnext')
        nnoremap <silent> <expr> gT printf(":\<C-u>%s%s\<CR>", v:count > 0 ? v:count : '', tabpagenr('$') == 1 ? 'bprevious' : 'tabprevious')
        echo 'Enabled cycling buffers with gt/gT for VIM with only one tabpage!'
    else
        silent! nunmap gt
        silent! nunmap gT
        echo 'Disabled cycling buffers with gt/gT for VIM with only one tabpage!'
    endif
endfunction
" }

" Exchange gj and gk to j and k {
function! zero#toggle#ToggleGJK() abort
    if get(s:, 'enabled_gjk', 0)
        let s:enabled_gjk = 0

        noremap  <buffer> j j
        xnoremap <buffer> j j
        noremap  <buffer> k k
        xnoremap <buffer> k k

        noremap  <buffer> gj gj
        xnoremap <buffer> gj gj
        noremap  <buffer> gk gk
        xnoremap <buffer> gk gk

        echo 'Disabled gj and gk!'
    else
        let s:enabled_gjk = 1

        noremap  <buffer> j gj
        xnoremap <buffer> j gj
        noremap  <buffer> k gk
        xnoremap <buffer> k gk

        noremap  <buffer> gj j
        xnoremap <buffer> gj j
        noremap  <buffer> gk k
        xnoremap <buffer> gk k

        echo 'Enabled gj and gk!'
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

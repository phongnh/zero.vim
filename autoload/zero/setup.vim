function! zero#setup#ToggleMappings() abort
    " Change tab width
    nnoremap <silent> yo2 :<C-u>setlocal softtabstop=2 shiftwidth=2 shiftwidth?<CR>
    nnoremap <silent> yo4 :<C-u>setlocal softtabstop=4 shiftwidth=4 shiftwidth?<CR>
    nnoremap <silent> yo8 :<C-u>setlocal softtabstop=8 shiftwidth=8 shiftwidth?<CR>

    nnoremap <silent> yo@ :<C-u>setlocal tabstop=2 softtabstop=2 shiftwidth=2 shiftwidth?<CR>
    nnoremap <silent> yo$ :<C-u>setlocal tabstop=4 softtabstop=4 shiftwidth=4 shiftwidth?<CR>
    nnoremap <silent> yo* :<C-u>setlocal tabstop=8 softtabstop=8 shiftwidth=8 shiftwidth?<CR>

    " Toggle incsearch
    nnoremap <silent> yoI :<C-u>setlocal incsearch! incsearch?<CR>
    nnoremap <silent> yoS :<C-u>set incsearch! incsearch?<CR>

    " Toggle expandtab
    nnoremap <silent> yoe :<C-u>setlocal expandtab! expandtab?<CR>

    " Toggle showcmd
    nnoremap <silent> yo; :<C-u>set showcmd! showcmd?<CR>

    " Toggle "keep current line in the center of the screen" mode
    nnoremap <silent> yoz :<C-u>let &scrolloff = 1000 - &scrolloff<CR>:set scrolloff?<CR>

    if get(g:, 'zero_vim_cycle_buffers_with_tab_mappings', 0)
        silent! call zero#toggle#CycleBuffersWithTabMappings()
    endif

    " Enable/disable gt/gT to cycle buffers when VIM has only one tabpage
    nnoremap <silent> yot :<C-u>call zero#toggle#CycleBuffersWithTabMappings()<CR>

    " Exchange gj and gk to j and k
    nnoremap <silent> yom :<C-u>call zero#toggle#ToggleGJK()<CR>

    " Toggle clipboard
    if has('clipboard')
        nnoremap <silent> yoy :<C-u>call zero#toggle#ToggleClipboard()<CR>
    endif

    " Toggle conceallevel
    if has('conceal')
        nnoremap <silent> yoC :<C-u>call zero#toggle#ToggleConceallevel()<CR>
    endif

    " Improve folding mappings
    nnoremap <silent> zr zr:<C-u>setlocal foldlevel?<CR>
    nnoremap <silent> zm zm:<C-u>setlocal foldlevel?<CR>
    nnoremap <silent> zR zR:<C-u>setlocal foldlevel?<CR>
    nnoremap <silent> zM zM:<C-u>setlocal foldlevel?<CR>
    nnoremap <silent> zi zi:<C-u>setlocal foldenable?<CR>
    nnoremap <silent> z] :<C-u>let &foldcolumn = &foldcolumn + 1<CR>:<C-u>setlocal foldcolumn?<CR>
    nnoremap <silent> z[ :<C-u>let &foldcolumn = &foldcolumn - 1<CR>:<C-u>setlocal foldcolumn?<CR>

    if empty(globpath(&rtp, 'plugin/unimpaired.vim'))
        function! s:ToggleBackground() abort
            if &background == 'dark'
                set background=light background?
            else
                set background=dark background?
            endif
        endfunction

        function! s:ToggleDiff() abort
            if &diff
                diffoff
                echo 'diffoff'
            else
                diffthis
                echo 'diffthis'
            endif
        endfunction

        function! s:ToggleVirtualEditAll() abort
            if &virtualedit =~# 'all'
                set virtualedit-=all
                echo 'set virtualedit-=all'
            else
                set virtualedit+=all
                echo 'set virtualedit+=all'
            endif
        endfunction

        function! s:ToggleCursorOptions() abort
            if &cursorline && &cursorcolumn
                set nocursorline nocursorcolumn
                echo 'set nocursorline nocursorcolumn'
            else
                set cursorline cursorcolumn
                echo 'set cursorline cursorcolumn'
            endif
        endfunction

        function! s:ToggleColorColumn() abort
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

        nnoremap <silent> yob     :<C-u>call <SID>ToggleBackground()<CR>
        nnoremap <silent> yoc     :<C-u>setlocal cursorline! cursorline?<CR>
        nnoremap <silent> yo-     :<C-u>setlocal cursorline! cursorline?<CR>
        nnoremap <silent> yo_     :<C-u>setlocal cursorline! cursorline?<CR>
        nnoremap <silent> you     :<C-u>setlocal cursorcolumn! cursorcolumn?<CR>
        nnoremap <silent> yo<Bar> :<C-u>setlocal cursorcolumn! cursorcolumn?<CR>
        nnoremap <silent> yod     :<C-u>call <SID>ToggleDiff()<CR>
        nnoremap <silent> yoh     :<C-u>set hlsearch! hlsearch?<CR>
        nnoremap <silent> yoi     :<C-u>set ignorecase! ignorecase?<CR>
        nnoremap <silent> yol     :<C-u>setlocal list! list?<CR>
        nnoremap <silent> yon     :<C-u>setlocal number! number?<CR>
        nnoremap <silent> yor     :<C-u>setlocal relativenumber! relativenumber?<CR>
        nnoremap <silent> yos     :<C-u>setlocal spell! spell?<CR>
        nnoremap <silent> yow     :<C-u>setlocal wrap! wrap?<CR>
        nnoremap <silent> yov     :<C-u>call <SID>ToggleVirtualEditAll()<CR>
        nnoremap <silent> yox     :<C-u>call <SID>ToggleCursorOptions()<CR>
        nnoremap <silent> yo+     :<C-u>call <SID>ToggleCursorOptions()<CR>
        nnoremap <silent> yo+     :<C-u>call <SID>ToggleCursorOptions()<CR>
        nnoremap <silent> yot     :<C-u>call <SID>ToggleColorColumn()<CR>
    endif
endfunction

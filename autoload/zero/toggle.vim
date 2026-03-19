" Exchange gj and gk to j and k {
function! s:ToggleGJK() abort
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

function! s:SetupUnimpairedMappings() abort
    if empty(globpath(&rtp, 'plugin/unimpaired.vim'))
        nnoremap <silent> yob     :<C-U>set background=<C-R>=&background == 'dark' ? 'light' : 'dark'<CR><CR><Cmd>set background?<CR>
        nnoremap <silent> yoc     :<C-U>setlocal cursorline! cursorline?<CR>
        nnoremap <silent> yo-     :<C-U>setlocal cursorline! cursorline?<CR>
        nnoremap <silent> yo_     :<C-U>setlocal cursorline! cursorline?<CR>
        nnoremap <silent> you     :<C-U>setlocal cursorcolumn! cursorcolumn?<CR>
        nnoremap <silent> yo<Bar> :<C-U>setlocal cursorcolumn! cursorcolumn?<CR>
        nnoremap <silent> yoh     :<C-U>set hlsearch! hlsearch?<CR>
        nnoremap <silent> yoi     :<C-U>set ignorecase! ignorecase?<CR>
        nnoremap <silent> yol     :<C-U>setlocal list! list?<CR>
        nnoremap <silent> yon     :<C-U>setlocal number! number?<CR>
        nnoremap <silent> yor     :<C-U>setlocal relativenumber! relativenumber?<CR>
        nnoremap <silent> yos     :<C-U>setlocal spell! spell?<CR>
        nnoremap <silent> yow     :<C-U>setlocal wrap! wrap?<CR>
        nnoremap <expr>   yov     printf(":\<C-U>set virtualedit%s=all\<CR>", &virtualedit =~# 'all' ? '-' : '+')
        nnoremap <expr>   yox     printf(":\<C-U>set %s\<CR>", &cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn')
        nnoremap <expr>   yo+     printf(":\<C-U>set %s\<CR>", &cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn')
        nnoremap <expr>   yot     printf(":\<C-U>set colorcolumn=%s\<CR>", empty(&colorcolumn) ? '+1' : '')

        if has('diff')
            nnoremap <expr> yod printf(":\<C-U>%s\<CR>", &diff ? 'diffoff' : 'diffthis')
        endif

        " Move lines up or down
        nnoremap <silent> <M-j> <Cmd>move .+1<Bar>normal! ==<CR>
        nnoremap <silent> <M-k> <Cmd>move .-2<Bar>normal! ==<CR>
        vnoremap <silent> <M-j> :move '>+1<Bar>normal! gv=gv<CR>
        vnoremap <silent> <M-k> :move '<-2<Bar>normal! gv=gv<CR>
        inoremap <silent> <M-j> <Cmd>move .+1<Bar>normal! ==<CR>
        inoremap <silent> <M-k> <Cmd>move .-2<Bar>normal! ==<CR>

        nmap ∆ <M-j>
        nmap ˚ <M-k>
        vmap ∆ <M-j>
        vmap ˚ <M-k>
        imap ∆ <M-j>
        imap ˚ <M-k>

        nmap ]e <M-j>
        nmap [e <M-k>
        vmap ]e <M-j>
        vmap [e <M-k>
    endif
endfunction

function! zero#toggle#Setup() abort
    " Change shiftwidth / tabstop
    nnoremap <silent> yo2 :<C-U>setlocal <C-R>=&expandtab ? 'shiftwidth=2 shiftwidth?' : 'tabstop=2 tabstop?'<CR><CR>
    nnoremap <silent> yo4 :<C-U>setlocal <C-R>=&expandtab ? 'shiftwidth=4 shiftwidth?' : 'tabstop=4 tabstop?'<CR><CR>
    nnoremap <silent> yo8 :<C-U>setlocal <C-R>=&expandtab ? 'shiftwidth=8 shiftwidth?' : 'tabstop=8 tabstop?'<CR><CR>

    " Toggle incsearch
    nnoremap <silent> yoS :<C-U>set incsearch! incsearch?<CR>

    " Toggle expandtab
    nnoremap <silent> yoe :<C-U>setlocal expandtab! expandtab?<CR>

    " Toggle "keep current line in the center of the screen" mode
    nnoremap <silent> yoz :<C-U>let &scrolloff = 1000 - &scrolloff<Bar>set scrolloff?<CR>

    " Exchange gj and gk to j and k
    nnoremap <silent> yom :<C-U>call <SID>ToggleGJK()<CR>

    " Toggle clipboard
    if has('clipboard')
        if has('unnamedplus')
            nnoremap <expr> yoy printf(":\<C-U>set clipboard%s=unnamedplus\<CR>", stridx(&clipboard, 'unnamedplus') > -1 ? '-' : '^')
        else
            nnoremap <expr> yoy printf(":\<C-U>set clipboard%s=unnamed\<CR>", stridx(&clipboard, 'unnamed') > -1 ? '-' : '^')
        endif
    endif

    " Toggle conceallevel
    if has('conceal')
        nnoremap <expr> yoC printf(":\<C-U>set conceallevel=%s\<CR>", &conceallevel > 0 ? 0 : 2)
    endif

    " Cycle diff option
    if has('diff')
        nnoremap yoD :<C-U>set <C-R>=&diffopt =~# 'algorithm:histogram' ? 'diffopt-=algorithm:histogram diffopt+=algorithm:patience' : 'diffopt-=algorithm:patience diffopt+=algorithm:histogram'<CR><CR>
    endif

    " Toggle EOL
    nnoremap <expr> yoE printf(":\<C-U>set listchars%s=eol:§\<CR>", &listchars =~# '\V\<eol\>' ? '-' : '+')

    " Toggle trailing space
    nnoremap <expr> yo<Space> printf(":\<C-U>set listchars%s=trail:·\<CR>", &listchars =~# '\V\<trail\>' ? '-' : '+')

    " Toggle Indent Guides
    if has('patch-8.2.5066')
        nnoremap <expr> yoI printf(":\<C-U>set listchars%s=leadmultispace:┊%s\<CR>", &listchars =~# '\V\<leadmultispace\>' ? '-' : '+', escape(repeat(' ', (exists('*shiftwidth') ? shiftwidth() : &shiftwidth)  - 1), ' '))

        augroup ZeroVimShiftwidthOption
            autocmd!
            autocmd OptionSet shiftwidth
                        \   if &listchars =~# '\V\<leadmultispace\>'
                        \ |     execute printf('set listchars-=leadmultispace:┊%s', escape(repeat(' ', v:option_old - 1), ' '))
                        \ |     execute printf('set listchars+=leadmultispace:┊%s', escape(repeat(' ', v:option_new - 1), ' '))
                        \ | endif
        augroup END
    endif

    " Improve folding mappings
    nnoremap <silent> zr zr:<C-U>setlocal foldlevel?<CR>
    nnoremap <silent> zm zm:<C-U>setlocal foldlevel?<CR>
    nnoremap <silent> zR zR:<C-U>setlocal foldlevel?<CR>
    nnoremap <silent> zM zM:<C-U>setlocal foldlevel?<CR>
    nnoremap <silent> zi zi:<C-U>setlocal foldenable?<CR>
    nnoremap <silent> z] :<C-U>let &foldcolumn = &foldcolumn + 1<Bar>setlocal foldcolumn?<CR>
    nnoremap <silent> z[ :<C-U>let &foldcolumn = &foldcolumn - 1<Bar>setlocal foldcolumn?<CR>

    call <SID>SetupUnimpairedMappings()
endfunction

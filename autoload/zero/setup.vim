function! zero#setup#ToggleMappings() abort
    " Change tab width
    nnoremap <silent> yo2 :<C-u>execute printf('setlocal softtabstop=%s shiftwidth=2 shiftwidth?', &softtabstop <= 0 ? &softtabstop : 2)<CR>
    nnoremap <silent> yo4 :<C-u>execute printf('setlocal softtabstop=%s shiftwidth=4 shiftwidth?', &softtabstop <= 0 ? &softtabstop : 4)<CR>
    nnoremap <silent> yo8 :<C-u>execute printf('setlocal softtabstop=%s shiftwidth=8 shiftwidth?', &softtabstop <= 0 ? &softtabstop : 8)<CR>

    nnoremap <silent> yo@ :<C-u>execute printf('setlocal softtabstop=%s tabstop=2 shiftwidth=2 shiftwidth?', &softtabstop <= 0 ? &softtabstop : 2)<CR>
    nnoremap <silent> yo$ :<C-u>execute printf('setlocal softtabstop=%s tabstop=4 shiftwidth=4 shiftwidth?', &softtabstop <= 0 ? &softtabstop : 4)<CR>
    nnoremap <silent> yo* :<C-u>execute printf('setlocal softtabstop=%s tabstop=8 shiftwidth=8 shiftwidth?', &softtabstop <= 0 ? &softtabstop : 8)<CR>

    " Toggle incsearch
    nnoremap <silent> yoS :<C-u>set incsearch! incsearch?<CR>

    " Toggle expandtab
    nnoremap <silent> yoe :<C-u>setlocal expandtab! expandtab?<CR>

    " Toggle "keep current line in the center of the screen" mode
    nnoremap <silent> yoz :<C-u>let &scrolloff = 1000 - &scrolloff<Bar>set scrolloff?<CR>

    " Exchange gj and gk to j and k
    nnoremap <silent> yom :<C-u>call zero#toggle#ToggleGJK()<CR>

    " Toggle clipboard
    if has('clipboard')
        if has('unnamedplus')
            nnoremap <expr> yoy printf(":\<C-u>set clipboard%s=unnamedplus\<CR>", match(&clipboard, 'unnamedplus') > -1 ? '-' : '^')
        else
            nnoremap <expr> yoy printf(":\<C-u>set clipboard%s=unnamed\<CR>", match(&clipboard, 'unnamed') > -1 ? '-' : '^')
        endif
    endif

    " Toggle conceallevel
    if has('conceal')
        nnoremap <expr> yoC printf(":\<C-u>set conceallevel=%s\<CR>", &conceallevel > 0 ? 0 : 2)
    endif

    " Cycle diff option
    if has('diff')
        nnoremap yoD :<C-u>set diffopt-=algorithm:myers diffopt-=algorithm:minimal<CR>:<C-u>set <C-r>=&diffopt =~# 'algorithm:histogram' ? 'diffopt-=algorithm:histogram diffopt+=algorithm:patience' : 'diffopt-=algorithm:patience diffopt+=algorithm:histogram'<CR><CR>
    endif

    " Toggle EOL
    nnoremap <expr> yoE printf(":\<C-u>set listchars%s=eol:§\<CR>", &listchars =~# '\V\<eol\>' ? '-' : '+')

    " Toggle trailing space
    nnoremap <expr> yo<Space> printf(":\<C-u>set listchars%s=trail:·\<CR>", &listchars =~# '\V\<trail\>' ? '-' : '+')

    " Toggle Indent Guides
    if has('patch-8.2.5066')
        nnoremap <expr> yoI printf(":\<C-u>set listchars%s=leadmultispace:┊%s\<CR>", &listchars =~# '\V\<leadmultispace\>' ? '-' : '+', escape(repeat(' ', (exists('*shiftwidth') ? shiftwidth() : &shiftwidth)  - 1), ' '))

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
    nnoremap <silent> zr zr:<C-u>setlocal foldlevel?<CR>
    nnoremap <silent> zm zm:<C-u>setlocal foldlevel?<CR>
    nnoremap <silent> zR zR:<C-u>setlocal foldlevel?<CR>
    nnoremap <silent> zM zM:<C-u>setlocal foldlevel?<CR>
    nnoremap <silent> zi zi:<C-u>setlocal foldenable?<CR>
    nnoremap <silent> z] :<C-u>let &foldcolumn = &foldcolumn + 1<Bar>setlocal foldcolumn?<CR>
    nnoremap <silent> z[ :<C-u>let &foldcolumn = &foldcolumn - 1<Bar>setlocal foldcolumn?<CR>
endfunction

function! zero#setup#UnimpairedMappings() abort
    if empty(globpath(&rtp, 'plugin/unimpaired.vim'))
        nnoremap <silent> yob     :<C-u>set background=<C-r>=&background == 'dark' ? 'light' : 'dark'<CR><CR><Cmd>set background?<CR>
        nnoremap <silent> yoc     :<C-u>setlocal cursorline! cursorline?<CR>
        nnoremap <silent> yo-     :<C-u>setlocal cursorline! cursorline?<CR>
        nnoremap <silent> yo_     :<C-u>setlocal cursorline! cursorline?<CR>
        nnoremap <silent> you     :<C-u>setlocal cursorcolumn! cursorcolumn?<CR>
        nnoremap <silent> yo<Bar> :<C-u>setlocal cursorcolumn! cursorcolumn?<CR>
        nnoremap <silent> yoh     :<C-u>set hlsearch! hlsearch?<CR>
        nnoremap <silent> yoi     :<C-u>set ignorecase! ignorecase?<CR>
        nnoremap <silent> yol     :<C-u>setlocal list! list?<CR>
        nnoremap <silent> yon     :<C-u>setlocal number! number?<CR>
        nnoremap <silent> yor     :<C-u>setlocal relativenumber! relativenumber?<CR>
        nnoremap <silent> yos     :<C-u>setlocal spell! spell?<CR>
        nnoremap <silent> yow     :<C-u>setlocal wrap! wrap?<CR>
        nnoremap <expr>   yov     printf(":\<C-u>set virtualedit%s=all\<CR>", &virtualedit =~# 'all' ? '-' : '+')
        nnoremap <expr>   yox     printf(":\<C-u>set %s\<CR>", &cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn')
        nnoremap <expr>   yo+     printf(":\<C-u>set %s\<CR>", &cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn')
        nnoremap <expr>   yot     printf(":\<C-u>set colorcolumn=%s\<CR>", empty(&colorcolumn) ? '+1' : '')

        if has('diff')
            nnoremap <expr> yod printf(":\<C-u>%s\<CR>", &diff ? 'diffoff' : 'diffthis')
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

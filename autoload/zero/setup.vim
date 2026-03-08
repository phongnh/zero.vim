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

    " Toggle showcmd
    nnoremap <silent> yo; :<C-u>set showcmd! showcmd?<CR>

    " Toggle "keep current line in the center of the screen" mode
    nnoremap <silent> yoz :<C-u>let &scrolloff = 1000 - &scrolloff<CR>:set scrolloff?<CR>

    " Exchange gj and gk to j and k
    nnoremap <silent> yom :<C-u>call zero#toggle#ToggleGJK()<CR>

    " Toggle clipboard
    if has('clipboard')
        if has('unnamedplus')
            nnoremap <expr> yoy match(&clipboard, 'unnamedplus') > -1 ? ":\<C-u>set clipboard-=unnamedplus\<CR>" : ":\<C-u>set clipboard^=unnamedplus\<CR>"
        else
            nnoremap <expr> yoy match(&clipboard, 'unnamed') > -1 ? ":\<C-u>set clipboard-=unnamed\<CR>" : ":\<C-u>set clipboard^=unnamed\<CR>"
        endif
    endif

    " Toggle conceallevel
    if has('conceal')
        nnoremap <silent> <expr> yoC &conceallevel > 0 ? ":\<C-u>set conceallevel=0 conceallevel?\<CR>" : ":\<C-u>set conceallevel=2 conceallevel?\<CR>"
    endif

    " Cycle diff option
    if has('diff')
        nnoremap <silent> yoD :<C-u>call zero#toggle#CycleDiffOption()<CR>
    endif

    " Improve folding mappings
    nnoremap <silent> zr zr:<C-u>setlocal foldlevel?<CR>
    nnoremap <silent> zm zm:<C-u>setlocal foldlevel?<CR>
    nnoremap <silent> zR zR:<C-u>setlocal foldlevel?<CR>
    nnoremap <silent> zM zM:<C-u>setlocal foldlevel?<CR>
    nnoremap <silent> zi zi:<C-u>setlocal foldenable?<CR>
    nnoremap <silent> z] :<C-u>let &foldcolumn = &foldcolumn + 1<CR>:<C-u>setlocal foldcolumn?<CR>
    nnoremap <silent> z[ :<C-u>let &foldcolumn = &foldcolumn - 1<CR>:<C-u>setlocal foldcolumn?<CR>

    " Toggle EOL
    nnoremap <expr> yoE &listchars =~# '\V\<eol\>' ? ":\<C-u>set listchars-=eol:§\<CR>" : ":\<C-u>set listchars+=eol:§\<CR>"

    " Toggle Indent Guides
    if has('patch-8.2.5066')
        nnoremap <silent> yoI :<C-u>call zero#toggle#ToggleLeadmultispace()<CR>

        augroup ZeroVimShiftwidthOption
            autocmd!
            autocmd OptionSet shiftwidth call zero#toggle#AdjustLeadmultispace(v:option_old, v:option_new)
        augroup END
    endif
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
        nnoremap <expr>   yov     &virtualedit =~# 'all' ? ":\<C-u>set virtualedit-=all\<CR>" : ":\<C-u>set virtualedit+=all\<CR>"
        nnoremap <silent> yox     :<C-u>call zero#toggle#ToggleCursorOptions()<CR>
        nnoremap <silent> yo+     :<C-u>call zero#toggle#ToggleCursorOptions()<CR>
        nnoremap <silent> yot     :<C-u>call zero#toggle#ToggleColorColumn()<CR>

        if has('diff')
            nnoremap <expr> yod &diff ? ":\<C-u>diffoff\<CR>" : ":\<C-u>diffthis\<CR>"
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

vim9script

def ToggleGJK()
    if empty(mapcheck('j', 'n')) || empty(mapcheck('k', 'n'))
        nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
        xnoremap <expr> j v:count == 0 ? 'gj' : 'j'
        nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
        xnoremap <expr> k v:count == 0 ? 'gk' : 'k'
        nnoremap gj j
        xnoremap gj j
        nnoremap gk k
        xnoremap gk k
        echo 'Enabled gj/gk!'
    else
        silent! nunmap j
        silent! xunmap j
        silent! nunmap k
        silent! xunmap k
        silent! nunmap gj
        silent! xunmap gj
        silent! nunmap gk
        silent! xunmap gk
        echo 'Disabled gj/gk!'
    endif
enddef

# Move lines up/down
def SetupMoveMappings()
    nnoremap <silent> <Plug>(MoveLineUp)   <Cmd>move .-2<Bar>normal! ==<CR>
    nnoremap <silent> <Plug>(MoveLineDown) <Cmd>move .+1<Bar>normal! ==<CR>
    vnoremap <silent> <Plug>(MoveLineUp)   :move '<-2<Bar>normal! gv=gv<CR>
    vnoremap <silent> <Plug>(MoveLineDown) :move '>+1<Bar>normal! gv=gv<CR>
    inoremap <silent> <Plug>(MoveLineUp)   <Cmd>move .-2<Bar>normal! ==<CR>
    inoremap <silent> <Plug>(MoveLineDown) <Cmd>move .+1<Bar>normal! ==<CR>

    if get(g:, 'zero_toggle_move_mappings', true)
        # macOS Alt key aliases (Option+J / Option+K) (∆ / ˚)
        if has('mac')
            # Kitty sends ∆ / ˚
            execute 'nmap ˚ <Plug>(MoveLineUp)'
            execute 'nmap ∆ <Plug>(MoveLineDown)'
            execute 'vmap ˚ <Plug>(MoveLineUp)'
            execute 'vmap ∆ <Plug>(MoveLineDown)'
            # Alacritty / Wezterm send <1b>j / <1b>k
            execute 'nmap k <Plug>(MoveLineUp)'
            execute 'nmap j <Plug>(MoveLineDown)'
            execute 'vmap k <Plug>(MoveLineUp)'
            execute 'vmap j <Plug>(MoveLineDown)'
        endif
        nmap <M-j> <Plug>(MoveLineDown)
        nmap <M-k> <Plug>(MoveLineUp)
        vmap <M-j> <Plug>(MoveLineDown)
        vmap <M-k> <Plug>(MoveLineUp)
    endif

    if get(g:, 'zero_toggle_insert_move_mappings', true)
        if has('mac')
            # Kitty sends ∆ / ˚
            execute 'imap ˚ <Plug>(MoveLineUp)'
            execute 'imap ∆ <Plug>(MoveLineDown)'
            # Alacritty / Wezterm send <1b>j / <1b>k
            execute 'imap k <Plug>(MoveLineUp)'
            execute 'imap j <Plug>(MoveLineDown)'
        endif
        imap <M-j> <Plug>(MoveLineDown)
        imap <M-k> <Plug>(MoveLineUp)
    endif
enddef

def SetupUnimpairedMappings()
    # Background
    nnoremap <silent> yob :<C-U>set background=<C-R>=&background == 'dark' ? 'light' : 'dark'<CR><CR><Cmd>set background?<CR>
    # Cursorline
    nnoremap <silent> yoc :<C-U>setlocal cursorline! cursorline?<CR>
    nnoremap <silent> yo- :<C-U>setlocal cursorline! cursorline?<CR>
    nnoremap <silent> yo_ :<C-U>setlocal cursorline! cursorline?<CR>
    # Cursorcolumn
    nnoremap <silent> you :<C-U>setlocal cursorcolumn! cursorcolumn?<CR>
    nnoremap <silent> yo<Bar> :<C-U>setlocal cursorcolumn! cursorcolumn?<CR>
    # Hlsearch
    nnoremap <silent> yoh :<C-U>set hlsearch! hlsearch?<CR>
    # Ignorecase
    nnoremap <silent> yoi :<C-U>set ignorecase! ignorecase?<CR>
    # List
    nnoremap <silent> yol :<C-U>setlocal list! list?<CR>
    # Number
    nnoremap <silent> yon :<C-U>setlocal number! number?<CR>
    # Relativenumber
    nnoremap <silent> yor :<C-U>setlocal relativenumber! relativenumber?<CR>
    # Spell
    nnoremap <silent> yos :<C-U>setlocal spell! spell?<CR>
    # Wrap
    nnoremap <silent> yow :<C-U>setlocal wrap! wrap?<CR>
    # Virtualedit
    nnoremap <expr> yov printf(":\<C-U>set virtualedit%s=all\<CR>", &virtualedit =~# 'all' ? '-' : '+')
    # Cursorline + cursorcolumn cross
    nnoremap <expr> yox printf(":\<C-U>set %s\<CR>", &cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn')
    nnoremap <expr> yo+ printf(":\<C-U>set %s\<CR>", &cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn')
    # Colorcolumn
    nnoremap <expr> yot printf(":\<C-U>set colorcolumn=%s\<CR>", empty(&colorcolumn) ? '+1' : '')

    if has('diff')
        nnoremap <expr> yod printf(":\<C-U>%s\<CR>", &diff ? 'diffoff' : 'diffthis')
    endif

    # Move lines up/down
    nmap [e <Plug>(MoveLineUp)
    nmap ]e <Plug>(MoveLineDown)
    vmap [e <Plug>(MoveLineUp)
    vmap ]e <Plug>(MoveLineDown)
enddef

def SetupToggleMappings()
    # Change shiftwidth / tabstop
    nnoremap <silent> yo2 :<C-U>setlocal <C-R>=&expandtab ? 'shiftwidth=2 shiftwidth?' : 'tabstop=2 tabstop?'<CR><CR>
    nnoremap <silent> yo4 :<C-U>setlocal <C-R>=&expandtab ? 'shiftwidth=4 shiftwidth?' : 'tabstop=4 tabstop?'<CR><CR>
    nnoremap <silent> yo8 :<C-U>setlocal <C-R>=&expandtab ? 'shiftwidth=8 shiftwidth?' : 'tabstop=8 tabstop?'<CR><CR>

    # Toggle incsearch
    nnoremap <silent> yoS :<C-U>set incsearch! incsearch?<CR>

    # Toggle expandtab
    nnoremap <silent> yoe :<C-U>setlocal expandtab! expandtab?<CR>

    # Toggle "keep current line centred" (scrolloff trick)
    nnoremap <silent> yoz :<C-U>let &scrolloff = 1000 - &scrolloff<Bar>set scrolloff?<CR>

    # Toggle gj/gk
    nnoremap <silent> yom :<C-U>call <SID>ToggleGJK()<CR>

    # Toggle clipboard
    if has('clipboard')
        if has('unnamedplus')
            nnoremap <expr> yoy printf(":\<C-U>set clipboard%s=unnamedplus\<CR>", stridx(&clipboard, 'unnamedplus') > -1 ? '-' : '^')
        else
            nnoremap <expr> yoy printf(":\<C-U>set clipboard%s=unnamed\<CR>", stridx(&clipboard, 'unnamed') > -1 ? '-' : '^')
        endif
    endif

    # Toggle conceallevel
    if has('conceal')
        nnoremap <expr> yoC printf(":\<C-U>set conceallevel=%s\<CR>", &conceallevel > 0 ? 0 : 2)
    endif

    # Cycle diffopt's algorithm option: histogram <-> patience
    if has('diff')
        nnoremap yoD :<C-U>set diffopt+=<C-R>=&diffopt =~# 'algorithm:histogram' ? 'algorithm:patience' : 'algorithm:histogram'<CR><CR>
    endif

    # Toggle EOL in listchars
    nnoremap <expr> yoE printf(":\<C-U>setlocal listchars%s=eol:§\<CR>", &listchars =~# '\V\<eol\>' ? '-' : '+')

    # Toggle trailing space in listchars
    nnoremap <expr> yo<Space> printf(":\<C-U>setlocal listchars%s=trail:·\<CR>", &listchars =~# '\V\<trail\>' ? '-' : '+')

    # Toggle indent guides (requires Vim patch 8.2.5066 for leadmultispace)
    if has('patch-8.2.5066')
        nnoremap <expr> yoI printf(":\<C-U>setlocal listchars%s=leadmultispace:┊%s\<CR>", &listchars =~# '\V\<leadmultispace\>' ? '-' : '+', escape(repeat(' ', shiftwidth() - 1), ' '))

        augroup ZeroToggleShiftwidth
            autocmd!
            autocmd OptionSet shiftwidth
                        \   if &listchars =~# '\V\<leadmultispace\>'
                        \ |     execute printf('setlocal listchars-=leadmultispace:┊%s', escape(repeat(' ', str2nr(v:option_old) - 1), ' '))
                        \ |     execute printf('setlocal listchars+=leadmultispace:┊%s', escape(repeat(' ', str2nr(v:option_new) - 1), ' '))
                        \ | endif
        augroup END
    endif

    # Improved fold mappings — show foldlevel after each change
    nnoremap <silent> zr zr:<C-U>setlocal foldlevel?<CR>
    nnoremap <silent> zm zm:<C-U>setlocal foldlevel?<CR>
    nnoremap <silent> zR zR:<C-U>setlocal foldlevel?<CR>
    nnoremap <silent> zM zM:<C-U>setlocal foldlevel?<CR>
    nnoremap <silent> zi zi:<C-U>setlocal foldenable?<CR>
    nnoremap <silent> z] :<C-U>let &foldcolumn = &foldcolumn + 1<Bar>setlocal foldcolumn?<CR>
    nnoremap <silent> z[ :<C-U>let &foldcolumn = &foldcolumn - 1<Bar>setlocal foldcolumn?<CR>
enddef

export def Setup()
    SetupMoveMappings()
    if exists('g:zero_toggle_unimpaired_mappings') && g:zero_toggle_unimpaired_mappings
        SetupUnimpairedMappings()
    elseif !exists('g:zero_toggle_unimpaired_mappings') && globpath(&rtp, 'plugin/unimpaired.vim')->empty()
        SetupUnimpairedMappings()
    endif
    SetupToggleMappings()
enddef

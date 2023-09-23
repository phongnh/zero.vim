function! zero#substitute#CCword() abort
    return '\<' . zero#Cword() . '\>'
endfunction

function! zero#substitute#Cword() abort
    return zero#Cword()
endfunction

function! zero#substitute#Word() abort
    let word = zero#Word()
    return zero#SubstituteEscape(word)
endfunction

function! zero#substitute#Vword() range abort
    let selection = zero#Vword()
    return zero#SubstituteEscape(selection)
endfunction

function! zero#substitute#Pword() range abort
    let search = zero#Pword()
    return zero#SubstituteEscape(search)
endfunction

" zero#substitute#Prompt('%s')                                   
" :%s//cg
"
" zero#substitute#Prompt('%s', 'zero#substitute#Cword()')        
" :%s/<C-r>=zero#substitute#Cword()<CR>//cg
"
" zero#substitute#Prompt('%s', 'zero#substitute#Cword()', 'Ieg')
" :%s/<C-r>=zero#substitute#Cword()<CR>//Ieg
"
" zero#substitute#Prompt('%s', { 'search': 'zero#substitute#Cword()', 'flags': 'Ieg' })
" :%s/<C-r>=zero#substitute#Cword()<CR>//Ieg
"
" Overwrite default flags
" zero#substitute#Prompt('%Subvert', 'zero#substitute#Cword()', { 'flags': 'ceg' })
" :%Subvert/<C-r>=zero#substitute#Cword()<CR>//ceg
"
" Add extra flags to default flags
" zero#substitute#Prompt('%Subvert', 'zero#substitute#Cword()', { '+flags': 'Iw' })
" :%Subvert/<C-r>=zero#substitute#Cword()<CR>//Iwcg
"
" [In Quickfix buffer] zero#substitute#Prompt('%s', 'zero#substitute#Cword()')
" :silent cfdo %s/<C-r>=zero#substitute#Cword()<CR>//eg
"
" [In Location list buffer] zero#substitute#Prompt('%s', 'zero#substitute#Cword()')
" :silent lfdo %s/<C-r>=zero#substitute#Cword()<CR>//eg
function! zero#substitute#Prompt(cmd, ...) abort
    let l:opts = { 'cmd': a:cmd }

    let l:args = deepcopy(a:000)
    if len(l:args) > 0 && type(l:args[-1]) == v:t_dict
        let l:opts = extend(l:opts, l:args[-1], 'force')
        let l:args = l:args[0:-2]
    endif

    if len(l:args) > 1
        let l:opts.search = l:args[0]
        let l:opts.flags = l:args[1]
    elseif len(l:args) > 0
        let l:opts.search = l:args[0]
    endif

    let l:defaults = {
                \ 'esc': 0,
                \ 'search': '',
                \ 'raw': 0,
                \ 'qf': '',
                \ 'flags': (&filetype == 'qf' ? 'e' : 'c') . (&gdefault ? '' : 'g'),
                \ '+flags': '',
                \ 'ignore': 0,
                \ 'silent': 1,
                \ 'cdo': 'cfdo',
                \ 'ldo': 'lfdo',
                \ }
    let l:opts = extend(deepcopy(l:defaults), l:opts, 'force')
    " echomsg '==> l:opts' string(l:opts)

    let l:esc = l:opts.esc || &filetype == 'qf' ? "\<Esc>" : ''

    let l:search = l:opts.search
    if &filetype == 'qf'
        if strlen(l:opts.qf)
            let l:search = '/' . "\<C-r>=" . l:opts.qf . "\<CR>/"
        elseif l:search == '\%V'
            let l:search = ''
        elseif strlen(l:search)
            let l:search = '/' . "\<C-r>=" . l:search . "\<CR>/"
        endif
    elseif strlen(l:search)
        let l:search = l:opts.raw ? ('/' . l:search) : ("/\<C-r>=" . l:search . "\<CR>/")
    endif
    let l:search .= strlen(l:search) ? '/' : '//'

    let l:flags = l:opts['+flags'] . l:opts.flags
    let l:flags = (l:opts.ignore ? 'I' : '') . l:flags
    " let l:flags = (l:opts.ignore || (&ignorecase && &smartcase) ? 'I' : '') . l:flags

    let l:new_flags = ''
    for l:char in split(l:flags, '\zs')
        if stridx(l:new_flags, l:char) < 0
            let l:new_flags .= l:char
        endif
    endfor
    let l:flags = l:new_flags

    let l:left = repeat("\<Left>", strlen(l:flags) + 1)

    let l:cmd = (a:cmd =~# '^:' ? a:cmd[1:] : a:cmd)
    if &filetype == 'qf'
        let l:silent = (l:opts.silent > 1) ? 'silent! ' : (l:opts.silent == 1 ? 'silent ' : '')
        let l:qfcmd = getwininfo(win_getid())[0]['loclist'] ? l:opts.ldo : l:opts.cdo
        if l:qfcmd ==# 'cfdo' || l:qfcmd ==# 'lfdo'
            let l:cmd = l:silent . l:qfcmd . ' ' . (l:cmd !~ '^%' ? '%' : '') . l:cmd
        elseif l:qfcmd ==# 'cdo' || l:qfcmd ==# 'ldo'
            let l:cmd = l:silent . l:qfcmd . ' ' . (l:cmd =~ '^%' ? l:cmd[1:] : l:cmd)
        else
            let l:cmd = l:silent . ' ' . l:cmd
        endif
        if strlen(l:silent) && stridx(l:flags, 'c')
            let l:flags = substitute(l:flags, 'c', '', '')
        endif
    endif

    return l:esc . ':' . l:cmd . l:search . l:flags . l:left
endfunction

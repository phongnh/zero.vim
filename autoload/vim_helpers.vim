" vim_helpers.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

let s:save_cpo = &cpoptions
set cpoptions&vim

function! vim_helpers#GetRgKnownFileTypes() abort
    if executable('rg')
        try
            return systemlist("rg --type-list | cut -d ':' -f 1")
        catch
            return []
        endtry
    endif
    return []
endfunction

function! vim_helpers#GetAgKnownFileTypes() abort
    if executable('ag')
        try
            return systemlist("ag --list-file-types | grep '\-\-' | cut -d '-' -f 3")
        catch
            return []
        endtry
    endif
    return []
endfunction

function! s:SetRgKnownFileTypes() abort
    if exists('g:rg_known_filetypes')
        return
    endif
    let g:rg_known_filetypes = vim_helpers#GetRgKnownFileTypes()
endfunction

function! s:SetAgKnownFileTypes() abort
    if exists('g:ag_known_filetypes')
        return
    endif
    let g:ag_known_filetypes = vim_helpers#GetAgKnownFileTypes()
endfunction

function! vim_helpers#ParseGrepFileTypeOption(cmd) abort
    let ext = expand('%:e')

    if a:cmd ==# 'rg'
        let ft = get(g:rg_filetype_mappings, &filetype, &filetype)
        call s:SetRgKnownFileTypes()

        if strlen(ft) && index(g:rg_known_filetypes, ft) >= 0
            return printf("-t %s", ft)
        elseif strlen(ext)
            return printf("-g '*.%s'", ext)
        endif
    elseif a:cmd ==# 'ag'
        let ft = get(g:ag_filetype_mappings, &filetype, &filetype)
        call s:SetAgKnownFileTypes()

        if strlen(ft) && index(g:ag_known_filetypes, ft) >= 0
            return printf("--%s", ft)
        elseif strlen(ext)
            return printf("-G '.%s$'", ext)
        endif
    elseif a:cmd ==# 'grep'
        if strlen(ext)
            return printf("--include='*.%s'", ext)
        endif
    endif

    return ''
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

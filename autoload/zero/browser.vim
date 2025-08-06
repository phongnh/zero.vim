function! zero#browser#Open(opts) abort
    if type(a:opts) == v:t_string
        let l:url = a:opts
    else
        let l:host = get(a:opts, 'host', 'github.com')
        let l:path = get(a:opts, 'path', '/')
        let l:query = get(a:opts, 'query', '')
        let l:url = printf('https://%s', l:host)
        let l:url .= l:path
        let l:url .= strlen(l:query) ? '?' . query : ''
    endif
    if exists(':OpenBrowser') == 2
        execute 'OpenBrowser' l:url
        return
    endif
    if !exists('g:loaded_netrw')
        runtime! autoload/netrw.vim
        runtime! autoload/netrw/os.vim
    endif
    if exists('*netrw#os#Open')
        call netrw#os#Open(l:url)
    elseif exists('*netrw#Open')
        call netrw#Open(l:url)
    elseif exists('*netrw#BrowseX')
        try
            call netrw#BrowseX(l:url)
        catch
            call netrw#BrowseX(l:url, 0)
        endtry
    elseif exists('*netrw#NetrwBrowseX')
        call netrw#NetrwBrowseX(l:url, 0)
    elseif has('nvim-0.10')
        call luaeval('vim.ui.open(_A[1]) and nil', [l:url])
    else
        call s:CopyUrl(l:url)
    endif
endfunction

function! s:CopyUrl(url) abort
    let @" = a:url
    if has('clipboard')
        let [@*, @+] = [@", @"]
    endif
    echo 'Copied: ' . @"
endfunction

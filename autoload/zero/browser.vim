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
    endif
    if exists('*netrw#Open')
        call netrw#Open(l:url)
    elseif exists('*netrw#BrowseX')
        call netrw#BrowseX(l:url, 0)
    elseif exists('*netrw#NetrwBrowseX')
        call netrw#NetrwBrowseX(l:url, 0)
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

if executable('gitk')
    command! -buffer GitkOnBlame call zero#gitk#GitkOnBlame()
    nnoremap <buffer> <silent> K :<C-u>GitkOnBlame<CR>
endif

if executable('tig')
    command! -buffer TigOnBlame call zero#tig#TigOnBlame()
    nnoremap <buffer> <silent> T :<C-u>TigOnBlame<CR>
endif

if exists(':GBrowse') == 2
    command -buffer GBrowseOnBlame call zero#git#GBrowseOnBlame()
    nnoremap <buffer> <silent> gb :<C-u>GBrowseOnBlame<CR>
    nnoremap <buffer> <silent> go :<C-u>GBrowseOnBlame<CR>
endif

nnoremap <buffer> <expr> R zero#substitute#Prompt('%s', 'zero#substitute#Cword()')
xnoremap <buffer> <expr> R zero#substitute#Prompt('%s', 'zero#substitute#Vword()', { 'esc': 1 })

if exists(':Subvert') == 2
    nnoremap <buffer> <expr> S zero#substitute#Prompt('%Subvert', 'zero#substitute#Cword()')
    xnoremap <buffer> <expr> S zero#substitute#Prompt('%Subvert', 'zero#substitute#Vword()', { 'esc': 1 })
endif

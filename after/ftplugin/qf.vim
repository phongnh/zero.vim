nnoremap <buffer> <expr> R zero#substitute#Prompt(':%s')
xnoremap <buffer> <expr> R zero#substitute#Prompt(':%s', 'zero#substitute#Vword()')

if exists(':Subvert') == 2
    nnoremap <buffer> <expr> S zero#substitute#Prompt(':%Subvert')
    xnoremap <buffer> <expr> S zero#substitute#Prompt(':%Subvert', 'zero#substitute#Vword()')
endif

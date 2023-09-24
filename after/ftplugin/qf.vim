nnoremap <buffer> <expr> R zero#substitute#Prompt(':%s', 'zero#substitute#Cword()')
xnoremap <buffer> <expr> R zero#substitute#Prompt(':%s', 'zero#substitute#Vword()')
nmap <buffer> <C-r> R
xmap <buffer> <C-r> R

if exists(':Subvert') == 2
    nnoremap <buffer> <expr> S zero#substitute#Prompt(':%Subvert', 'zero#substitute#Cword()')
    xnoremap <buffer> <expr> S zero#substitute#Prompt(':%Subvert', 'zero#substitute#Vword()')
    nmap <buffer> <C-s> S
    xmap <buffer> <C-s> S
endif

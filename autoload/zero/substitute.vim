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


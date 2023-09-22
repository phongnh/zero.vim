function! zero#shell#CCword() abort
    let cword = zero#TrimNewLines(zero#Cword())
    return '\b' . zero#ShellEscape(cword) . '\b'
endfunction

function! zero#shell#Cword() abort
    let cword = zero#TrimNewLines(zero#Cword())
    return zero#ShellEscape(cword)
endfunction

function! zero#shell#Word() abort
    let word = zero#TrimNewLines(zero#Word())
    return zero#ShellEscape(word)
endfunction

function! zero#shell#Vword() range abort
    let selection = zero#TrimNewLines(zero#Vword())
    return zero#ShellEscape(selection)
endfunction

function! zero#shell#Pword() abort
    let search = zero#Pword()
    return zero#ShellEscape(search)
endfunction

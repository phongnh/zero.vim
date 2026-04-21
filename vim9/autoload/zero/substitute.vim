vim9script

# Escape regex characters
var escape_characters = '^$.*\/~[]'

export def Escape(text: string): string
    var escaped = escape(text, escape_characters)
    return substitute(escaped, '\n', '\\n', 'g')
enddef

export def Input(...args: list<any>): string
    const prompt = get(args, 0, 'Substitute: ')
    return Escape(input(prompt)) .. ' '
enddef

export def CCword(): string
    return '\<' .. zero#Cword() .. '\>'
enddef

export def Cword(): string
    return zero#Cword()
enddef

export def Word(): string
    return Escape(zero#Word())
enddef

export def Vword(...args: list<any>): string
    if get(args, 0, 0)
        return '\<' .. Escape(zero#Vword()) .. '\>'
    else
        return Escape(zero#Vword())
    endif
enddef

export def Pword(): string
    return Escape(zero#Pword())
enddef

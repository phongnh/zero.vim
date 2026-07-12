vim9script

export def Escape(text: string): string
    return shellescape(text)
enddef

export def CCword(): string
    return Escape(zero#CCword())
enddef

export def Cword(): string
    return Escape(zero#Cword())
enddef

export def Word(): string
    return Escape(zero#Word())
enddef

export def Vword(): string
    return Escape(zero#Vword())
enddef

export def Visual(): string
    return Escape(zero#Visual())
enddef

export def Pword(): string
    return Escape(zero#Pword())
enddef

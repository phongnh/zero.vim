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

export def GrepperEscape(text: string): string
    const shell = &shell
    &shell = 'sh'
    const escaped = shellescape(text)
    &shell = shell
    return escaped
enddef

export def GrepperCCword(): string
    return GrepperEscape(zero#CCword())
enddef

export def GrepperCword(): string
    return GrepperEscape(zero#Cword())
enddef

export def GrepperWord(): string
    return GrepperEscape(zero#Word())
enddef

export def GrepperVword(): string
    return GrepperEscape(zero#Vword())
enddef

export def GrepperVisual(): string
    return GrepperEscape(zero#Visual())
enddef

export def GrepperPword(): string
    return GrepperEscape(zero#Pword())
enddef

export def LeaderfEscape(text: string): string
    const shell = &shell
    &shell = 'sh'
    const escaped = shellescape(escape(text, '"'))
    &shell = shell
    return escaped
enddef

export def LeaderfCCword(): string
    return LeaderfEscape(zero#CCword())
enddef

export def LeaderfCword(): string
    return LeaderfEscape(zero#Cword())
enddef

export def LeaderfWord(): string
    return LeaderfEscape(zero#Word())
enddef

export def LeaderfVword(): string
    return LeaderfEscape(zero#Vword())
enddef

export def LeaderfVisual(): string
    return LeaderfEscape(zero#Visual())
enddef

export def LeaderfPword(): string
    return LeaderfEscape(zero#Pword())
enddef

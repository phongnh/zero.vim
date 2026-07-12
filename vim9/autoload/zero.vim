vim9script

export def Trim(str: string): string
    return trim(str)
enddef

# Search Helpers
export def CCword(): string
    return '\b' .. expand('<cword>') .. '\b'
enddef

export def Cword(): string
    return expand('<cword>')
enddef

export def Word(): string
    return expand('<cWORD>')
enddef

export def Vword(): string
    const saved = @"
    silent execute 'normal! ""gvy'
    const selection = @"
    @" = saved
    return selection ==# "\n" ? '' : substitute(selection, '\n\+$', '', 'g')
enddef

export def Visual(): string
    if exists('*getregion')
        return trim(join(call('getregion', [getpos("'<"), getpos("'>")])->slice(0, 1), "\n"))
    endif
    const line = getline("'<")
    const [_b1, l1, c1, _o1] = getpos("'<")
    const [_b2, l2, c2, _o2] = getpos("'>")
    if l1 != l2
        return trim(strpart(line, c1 - 1))
    endif
    return trim(strpart(line, c1 - 1, c2 - c1 + 1))
enddef

export def Pword(): string
    const search = @/
    if empty(search) || search ==# "\n"
        return ''
    endif
    return substitute(search, '^\\<\(.\+\)\\>$', '\\b\1\\b', '')
enddef

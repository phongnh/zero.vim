vim9script

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

def IsSubstituteCommand(cmd: string): bool
    return cmd =~# '^\%(''<,''>\|%\)\?\%(s\|substitute\|S\|Subvert\)/' ||
        cmd =~# '^\%(silent!\?\s\+\)\?\%(cfdo\|lfdo\|cdo\|ldo\)\s\+%\?\%(s\|substitute\|S\|Subvert\)/'
enddef

def IsGrepCommand(cmd: string): bool
    return cmd =~# '^\%(''<,''>\)\?\%(Grep\|LGrep\|BGrep\)\s' ||
        cmd =~# '^\%(\%(silent!\?\s\+\)\?grep\|lgrep\)!\?\s' ||
        cmd =~# '^\%(Ggrep!\?\|Glgrep!\?\|Git!\?\s\+grep\)\s'
enddef

def IsGrepperCommand(cmd: string): bool
    return cmd =~# '^\%(''<,''>\)\?\%(Grepper\|LGrepper\|PGrepper\|BGrepper\)\s'
enddef

def IsGrepperInputCommand(): bool
    return getcmdtype() ==# '@' && getcmdprompt() =~# '^\%(rg\|git\)\s\+.\+>'
enddef

export def InsertCCword(): string
    const cmd = getcmdline()
    if IsSubstituteCommand(cmd)
        return zero#substitute#CCword()
    endif
    return zero#CCword()
enddef

export def InsertCword(): string
    const cmd = getcmdline()
    if IsSubstituteCommand(cmd)
        return zero#substitute#Cword()
    endif
    return zero#Cword()
enddef

export def InsertWord(): string
    const cmd = getcmdline()
    if IsSubstituteCommand(cmd)
        return zero#substitute#Word()
    elseif IsGrepCommand(cmd)
        return escape(zero#Word(), ' ')
    elseif IsGrepperCommand(cmd) || IsGrepperInputCommand()
        return zero#grep#GrepperWord()
    endif
    return zero#grep#Word()
enddef

export def InsertVword(): string
    const cmd = getcmdline()
    if IsSubstituteCommand(cmd)
        return zero#substitute#Vword()
    elseif IsGrepCommand(cmd)
        return escape(zero#Vword(), ' ')
    elseif IsGrepperCommand(cmd) || IsGrepperInputCommand()
        return zero#grep#GrepperVword()
    endif
    return zero#grep#Vword()
enddef

export def InsertPword(): string
    const cmd = getcmdline()
    if IsSubstituteCommand(cmd)
        return zero#substitute#Pword()
    elseif IsGrepCommand(cmd)
        return escape(zero#Pword(), ' ')
    elseif IsGrepperCommand(cmd) || IsGrepperInputCommand()
        return zero#grep#GrepperPword()
    endif
    return zero#grep#Pword()
enddef

vim9script

def OnQuickFixCmdPost(...args: list<any>)
    const loclist = get(args, 0, false)
    var total = 0
    if loclist
        belowright lwindow
        total = getloclist(0, { 'id': 0, 'size': 0 }).size
    else
        botright cwindow
        total = getqflist({ 'id': 0, 'size': 0 }).size
    endif
    redraw!
    if total > 0
        echo $"Found {total} {total == 1 ? 'match' : 'matches'}."
    else
        echo 'No matches found.'
    endif
enddef

export def OpenQuickfix()
    timer_start(0, (_) => OnQuickFixCmdPost(false))
enddef

export def OpenLocationList()
    timer_start(0, (_) => OnQuickFixCmdPost(true))
enddef

export def Exec(opts: dict<any> = {}): void
    var args = opts->get('args', [])->copy()->filter((_, val) => !empty(val))

    if visualmode() == null_string
        if args->empty()
            const cword = expand('<cword>')
            if !cword->empty()
                args = ['-w', cword]
            endif
        endif
    else
        const vword = zero#Vword()
        if !vword->empty()
            args = ['-F', '-e', shellescape(vword)] + args
        endif
        visualmode(1)
    endif

    if empty(args)
        return
    endif

    const path = opts->get('path', '')
    if !empty(path)
        args->add(fnameescape(path))
    endif

    const cmd = &grepprg .. ' ' .. args->join(' ')
    if get(opts, 'cmd', 'grep') ==# 'lgrep'
        lgetexpr system(cmd)
        setloclist(0, [], 'a', { 'title': cmd })
        OpenLocationList()
    else
        cgetexpr system(cmd)
        setqflist([], 'a', { 'title': cmd })
        OpenQuickfix()
    endif
enddef

export def Grep(...args: list<any>): void
    Exec({ 'args': args })
enddef

export def LGrep(...args: list<any>): void
    Exec({ 'cmd': 'lgrep', 'args': args })
enddef

export def BGrep(...args: list<any>): void
    Exec({ 'cmd': 'lgrep', 'args': args, 'path': expand('%:p:.') })
enddef

export def GrepProject(...args: list<any>): void
    Exec({ 'args': args, 'path': zero#project#Find()->fnamemodify(':p:.') })
enddef

export def LGrepProject(...args: list<any>): void
    Exec({ 'cmd': 'lgrep', 'args': args, 'path': zero#project#Find()->fnamemodify(':p:.') })
enddef

export def GrepBufferDir(...args: list<any>): void
    Exec({ 'args': args, 'path': expand('%p:.:h') })
enddef

export def LGrepBufferDir(...args: list<any>): void
    Exec({ 'cmd': 'lgrep', 'args': args, 'path': expand('%p:.:h') })
enddef

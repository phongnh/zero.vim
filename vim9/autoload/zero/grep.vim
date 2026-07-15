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

    if args->empty()
        const cword = expand('<cword>')
        if !cword->empty()
            args = [shellescape('\b' .. cword .. '\b')]
        endif
    endif

    if empty(args)
        return
    endif

    const path = opts->get('path', '')
    if !empty(path)
        args->add(fnameescape(path))
    endif

    const cmd = &grepprg .. ' ' .. args->join(' ')
    if get(opts, 'quickfix', 1)
        cgetexpr system(cmd)
        setqflist([], 'a', { 'title': cmd })
        OpenQuickfix()
    else
        lgetexpr system(cmd)
        setloclist(0, [], 'a', { 'title': cmd })
        OpenLocationList()
    endif
enddef

export def Grep(...args: list<any>): void
    Exec({ 'args': args, 'quickfix': true })
enddef

export def LGrep(...args: list<any>): void
    Exec({ 'args': args, 'quickfix': false })
enddef

export def BGrep(...args: list<any>): void
    Exec({ 'args': args, 'path': expand('%:p:.'), 'quickfix': false })
enddef

export def GrepProject(...args: list<any>): void
    Exec({ 'args': args, 'path': zero#project#Find()->fnamemodify(':p:.'), 'quickfix': true })
enddef

export def LGrepProject(...args: list<any>): void
    Exec({ 'args': args, 'path': zero#project#Find()->fnamemodify(':p:.'), 'quickfix': false })
enddef

export def GrepBufferDir(...args: list<any>): void
    Exec({ 'args': args, 'path': expand('%p:.:h'), 'quickfix': true })
enddef

export def LGrepBufferDir(...args: list<any>): void
    Exec({ 'args': args, 'path': expand('%p:.:h'), 'quickfix': false })
enddef

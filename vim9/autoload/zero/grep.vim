vim9script

var current_job: any

def OnQuickFixCmdPost(quickfix: bool = true)
    var total = 0
    if quickfix
        botright cwindow
        total = getqflist({ 'id': 0, 'size': 0 }).size
    else
        belowright lwindow
        total = getloclist(0, { 'id': 0, 'size': 0 }).size
    endif
    redraw!
    if total > 0
        echo $"Found {total} {total == 1 ? 'match' : 'matches'}."
    else
        echo 'No matches found.'
    endif
enddef

export def OpenQuickfix()
    timer_start(0, (_) => OnQuickFixCmdPost(true))
enddef

export def OpenLocationList()
    timer_start(0, (_) => OnQuickFixCmdPost(false))
enddef

def BuildGrepCmd(grepprg: any): list<string>
    if type(grepprg) == v:t_list
        return grepprg
    elseif type(grepprg) == v:t_dict
        return [grepprg.cmd]->extend(get(grepprg, 'args', []))
    endif
    var cmd: list<string> = []
    for token in grepprg->split('\s\+')
        if token !~# '^[$%]'
            add(cmd, token)
        endif
    endfor
    return cmd
enddef

def ExtractOptions(opts: dict<any>): dict<any>
    var options = extend({
        'quickfix': true,
        'path': [],
        'grepprg': &grepprg,
        'grepformat': &grepformat,
        'cword': false,
        'async': true,
    }, deepcopy(opts))
    options.args = options->get('args', [])->copy()->filter((_, val) => !empty(val))
    if empty(options.args)
        options.cword = true
        const cword = expand('<cword>')
        if !empty(cword)
            args = [shellescape('\b' .. cword .. '\b')]
        endif
    endif
    if empty(options.path)
        options.path = []
    elseif type(options.path) == v:t_string
        options.path = [options.path]
    elseif type(options.path) != v:t_list
        options.path = []
    endif
    filter(options.path, (_, val) => !empty(val))
    options.grep_cmd = BuildGrepCmd(options.grepprg)
    return options
enddef

def OnJobExit(opts: dict<any>, job: any, status: any): void
    if status == 0 || status == 1
        if opts.quickfix
            OpenQuickfix()
        else
            OpenLocationList()
        endif
    else
        echoerr 'Grep failed with error code:' status
    endif
enddef

def ExecAsync(opts: dict<any> = {}): void
    const cmd = join(opts.grep_cmd + opts.args + mapnew(opts.path, (_, path) => fnameescape(path)), ' ')

    const efm = opts.grepformat
    var OnJobOut: any
    if opts.quickfix
        setqflist([], 'r', { 'items': [], 'title': cmd })
        OnJobOut = (_channel, msg) => setqflist([], 'a', { 'lines': [msg], 'efm': efm })
    else
        setloclist(0, [], 'r', { 'items': [], 'title': cmd })
        OnJobOut = (_channel, msg) => setloclist(0, [], 'a', { 'lines': [msg], 'efm': efm })
    endif

    current_job = job_start([&shell, &shellcmdflag, cmd], {
        'in_io': 'null',
        'err_io': 'out',
        'out_cb': OnJobOut,
        'exit_cb': (job, status) => OnJobExit(opts, job, status),
    })
enddef

def ExecSync(opts: dict<any> = {}): void
    const cmd = join(opts.grep_cmd + opts.args + mapnew(opts.path, (_, path) => fnameescape(path)), ' ')

    var errorformat = &errorformat
    try
        &errorformat = opts.grepformat
        if opts.quickfix
            cgetexpr system(cmd)
            setqflist([], 'a', { 'title': cmd })
            OpenQuickfix()
        else
            lgetexpr system(cmd)
            setloclist(0, [], 'a', { 'title': cmd })
            OpenLocationList()
        endif
    finally
        &errorformat = errorformat
    endtry
enddef

export def Exec(opts: dict<any> = {}): void
    var options = ExtractOptions(opts)

    if options.args->empty()
        return
    endif

    if options.async && exists('*job_start')
        ExecAsync(options)
    else
        ExecSync(options)
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

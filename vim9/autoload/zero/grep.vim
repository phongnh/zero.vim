vim9script

var current_job: job = null_job

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

def BuildGrepprg(grepprg: any): list<string>
    if type(grepprg) == v:t_list && !empty(grepprg)
        return grepprg
    endif
    var new_grepprg = grepprg
    if type(grepprg) != v:t_string || empty(grepprg)
        new_grepprg = &grepprg
    endif
    var cmd: list<string> = []
    for token in new_grepprg->split('\s\+')
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
        'escape': '\',
        'grepprg': &grepprg,
        'grepformat': &grepformat,
        'append': false,
        'async': true,
    }, deepcopy(opts))

    options.args = get(options, 'args', [])
    filter(options.args, (_, val) => !empty(val))

    if empty(options.path)
        options.path = []
    elseif type(options.path) == v:t_string
        options.path = [options.path]
    elseif type(options.path) != v:t_list
        options.path = []
    endif
    filter(options.path, (_, val) => !empty(val))

    options.grepprg = BuildGrepprg(options.grepprg)

    return options
enddef

def BuildEscapedArgs(args: list<string>, chars: string): list<string>
    return mapnew(args, (_, arg) => escape(arg, chars))
enddef

def BuildEscapedPath(paths: list<string>): list<string>
    return mapnew(paths, (_, path) => fnameescape(path))
enddef

def OnJobExit(opts: dict<any>, job: any, status: any): void
    try
        if status < 0
            return
        endif

        if status == 0 || status == 1
            if opts.quickfix
                OpenQuickfix()
            else
                OpenLocationList()
            endif
        else
            echoerr 'Grep failed with error code:' status
        endif
    finally
        current_job = null_job
    endtry
enddef

def ExecAsync(opts: dict<any> = {}): void
    const title = join(opts.grepprg + opts.args + opts.path, ' ')
    const efm = opts.grepformat
    var OnJobOut: any
    if opts.quickfix
        if opts.append
            setqflist([], 'a', { 'title': title })
        else
            setqflist([], 'r', { 'items': [], 'title': title })
        endif
        OnJobOut = (_channel, msg) => setqflist([], 'a', { 'lines': [msg], 'efm': efm })
    else
        if opts.append
            setloclist(0, [], 'a', { 'title': title })
        else
            setloclist(0, [], 'r', { 'items': [], 'title': title })
        endif
        OnJobOut = (_channel, msg) => setloclist(0, [], 'a', { 'lines': [msg], 'efm': efm })
    endif

    if current_job != null_job && job_status(current_job) ==# 'run'
        job_stop(current_job)
    endif

    const cmd = join(opts.grepprg + opts.args + BuildEscapedPath(opts.path), ' ')
    current_job = job_start([&shell, &shellcmdflag, cmd], {
        'in_io': 'null',
        'err_io': 'out',
        'out_cb': OnJobOut,
        'exit_cb': (job, status) => OnJobExit(opts, job, status),
    })
enddef

def ExecSync(opts: dict<any> = {}): void
    const title = join(opts.grepprg + opts.args + opts.path, ' ')
    const cmd = join(opts.grepprg + opts.args + BuildEscapedPath(opts.path), ' ')

    var errorformat = &errorformat
    try
        &errorformat = opts.grepformat
        if opts.quickfix
            if opts.append
                caddexpr system(cmd)
            else
                cgetexpr system(cmd)
            endif
            setqflist([], 'a', { 'title': title })
            OpenQuickfix()
        else
            if opts.append
                laddexpr system(cmd)
            else
                lgetexpr system(cmd)
            endif
            setloclist(0, [], 'a', { 'title': title })
            OpenLocationList()
        endif
    finally
        &errorformat = errorformat
    endtry
enddef

export def Exec(opts: dict<any> = {}): void
    var options = ExtractOptions(opts)

    if empty(options.grepprg) || empty(options.args)
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

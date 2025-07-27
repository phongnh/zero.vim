let s:is_windows = has('win64') || has('win32') || has('win32unix') || has('win16')
let s:default_opts = exists('*jobstart') ? { 'env': {}, 'clear_env': v:false } : { 'env': {} }

function! s:resolve(opts) abort
    return extendnew(s:default_opts, type(a:opts) == v:t_dict ? a:opts : {})
endfunction

function! zero#term#Launch(cmd, ...) abort
    let opts = s:resolve(get(a:, 1, {}))
    if exists('*jobstart')
        call zero#LogCommand(a:cmd, 'nvim')
        return jobstart(a:cmd, opts)
    elseif exists('*job_start')
        call zero#LogCommand(a:cmd, 'terminal')
        return job_start(a:cmd, opts)
    else
        opts.background = v:true
        return zero#term#Run(a:cmd, opts)
    endif
endfunction

function! zero#term#Run(cmd, ...) abort
    let cmd = type(a:cmd) == v:t_list ? join(a:cmd, ' ') : a:cmd
    let opts = get(a:, 1, {})
    let opts = type(opts) == v:t_dict ? opts : {}
    if has_key(opts, 'env') && !empty(opts.env)
        let env = 'env '
        for [l:name, l:value] in items(opts.env)
            if !empty(l:value)
                let env ..= printf(' %s=%s', l:name, shellescape(l:value))
            endif
        endfor
        if env !=# 'env '
            let cmd = env .. ' ' .. cmd
        endif
    endif
    if has_key(opts, 'cwd') && !empty(opts.cwd) && opts.cwd !=# getcwd()
        let cmd = printf('cd %s && %s', shellescape(opts.cwd), cmd)
    endif
    if has_key(opts, 'background') && opts.background && !s:is_windows
        let cmd ..= ' >/dev/null 2>&1 &'
    endif
    call zero#LogCommand(cmd, 'shell')
    execute 'silent' ('!' .. cmd)
    redraw!
    return v:null
endfunction

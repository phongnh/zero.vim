let s:is_windows = has('win64') || has('win32') || has('win32unix') || has('win16')
let s:default_opts = exists('*jobstart') ? { 'env': {}, 'clear_env': v:false } : { 'env': {} }

function! s:resolve(opts) abort
    return extendnew(s:default_opts, type(a:opts) == v:t_dict ? a:opts : {})
endfunction

function! zero#term#Launch(cmd, ...) abort
    let l:opts = s:resolve(get(a:, 1, {}))
    if exists('*jobstart')
        call zero#LogCommand(a:cmd, 'nvim')
        return jobstart(a:cmd, l:opts)
    elseif exists('*job_start')
        call zero#LogCommand(a:cmd, 'terminal')
        return job_start(a:cmd, l:opts)
    else
        let l:opts.background = v:true
        return zero#term#Run(a:cmd, l:opts)
    endif
endfunction

function! zero#term#Run(cmd, ...) abort
    let l:cmd = type(a:cmd) == v:t_list ? join(a:cmd, ' ') : a:cmd
    let l:opts = get(a:, 1, {})
    let l:opts = type(l:opts) == v:t_dict ? l:opts : {}
    if has_key(l:opts, 'env') && !empty(l:opts.env)
        let l:env = 'env '
        for [l:name, l:value] in items(l:opts.env)
            if !empty(l:value)
                let l:env ..= printf(' %s=%s', l:name, shellescape(l:value))
            endif
        endfor
        if l:env !=# 'env '
            let l:cmd = l:env .. ' ' .. l:cmd
        endif
    endif
    if has_key(l:opts, 'cwd') && !empty(l:opts.cwd) && l:opts.cwd !=# getcwd()
        let l:cmd = printf('cd %s && %s', shellescape(l:opts.cwd), l:cmd)
    endif
    if has_key(l:opts, 'background') && l:opts.background && !s:is_windows
        let l:cmd ..= ' >/dev/null 2>&1 &'
    endif
    call zero#LogCommand(l:cmd, 'shell')
    execute 'silent' ('!' .. l:cmd)
    redraw!
    return v:null
endfunction

" Grep Helpers
function! s:GrepCmd() abort
    return split(&grepprg, '\s\+')[0]
endfunction

function! s:GrepDir(dir) abort
    let l:dir = fnamemodify(empty(a:dir) ? expand('%') : a:dir, ':~:.:h')
    let l:dir = vim_helpers#Strip(l:dir)

    if empty(l:dir) || l:dir ==# '.' || l:dir =~ '^/' || l:dir =~ '^\~'
        return ''
    endif

    return l:dir
endfunction

function! s:Grep(cmd, ...) abort
    let l:cmd = vim_helpers#Strip(a:cmd . ' ' . join(a:000, ' '))
    call vim_helpers#LogCommand(l:cmd)
    try
        execute l:cmd
    catch
    endtry
endfunction

function! vim_helpers#grep#Grep(...) abort
    call call(function('s:Grep'), ['Grep'] + a:000))
endfunction

function! vim_helpers#grep#LGrep(...) abort
    call call(function('s:Grep'), ['LGrep'] + a:000))
endfunction

function! vim_helpers#grep#BGrep(...) abort
    call call(function('s:Grep'), ['BGrep'] + a:000))
endfunction

function! s:ParseFileTypeOption() abort
    let l:cmd = get(a:, 1, s:GrepCmd())

    if l:cmd ==# 'rg'
        return vim_helpers#RgFileTypeOption()
    elseif l:cmd ==# 'grep'
        return vim_helpers#GrepFileTypeOption()
    endif

    return ''
endfunction

function! vim_helpers#grep#TGrep(...) abort
    call call(function('s:Grep'), ['Grep', s:ParseFileTypeOption()] + a:000)
endfunction

function! vim_helpers#grep#FGrep(...) abort
    call call(function('s:Grep'), ['Grep', '--fixed-strings'] + a:000)
endfunction

" Grep Code
if executable('rg')
    function! s:GrepCodeOption() abort
        if s:GrepCmd() != 'rg'
            return ''
        endif

        let l:option = ''

        if !empty(g:vim_helpers_code_ignore)
            let l:code_ignore = findfile(g:vim_helpers_code_ignore, ';')

            if strlen(l:code_ignore)
                let l:option = ' --ignore-file ' . fnamemodify(l:code_ignore, ':p')
            endif
        endif

        if empty(l:option) && type(g:vim_helpers_grep_ignores) == type([])
            let l:option = join(map(copy(g:zero_vim_grep_ignores), 'printf(" -g \"!%s\"", v:val)'))
        endif

        return l:option
    endfunction

    function! vim_helpers#grep#GrepCode(...) abort
        call call(function('s:Grep'), ['Grep', s:GrepCodeOption()] + a:000)
    endfunction

    function! vim_helpers#grep#LGrepCode(...) abort
        call call(function('s:Grep'), ['LGrep', s:GrepCodeOption()] + a:000)
    endfunction
endif

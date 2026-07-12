if has('nvim') || exists('g:loaded_zero_vim')
    finish
endif

let g:loaded_zero_vim = 1

" Save cpoptions
let s:save_cpo = &cpoptions
set cpoptions&vim

if get(g:, 'zero_path_user_commands', 0)
    command! -bang CopyPath            call zero#path#CopyPath(<bang>0)
    command! -bang CopyFullPath        call zero#path#CopyFullPath(<bang>0)
    command! -bang CopyAbsolutePath    call zero#path#CopyAbsolutePath(<bang>0)
    command!       CopyDirPath         call zero#path#CopyDirPath()
    command!       CopyFullDirPath     call zero#path#CopyFullDirPath()
    command!       CopyAbsoluteDirPath call zero#path#CopyAbsoluteDirPath()
endif

if get(g:, 'zero_path_mappings', 1)
    nnoremap <silent> yc :<C-U>call zero#path#CopyPath(0)<CR>
    nnoremap <silent> yC :<C-U>call zero#path#CopyPath(1)<CR>
    nnoremap <silent> yp :<C-U>call zero#path#CopyFullPath(0)<CR>
    nnoremap <silent> yP :<C-U>call zero#path#CopyFullPath(1)<CR>
    nnoremap <silent> yu :<C-U>call zero#path#CopyAbsolutePath(0)<CR>
    nnoremap <silent> yU :<C-U>call zero#path#CopyAbsolutePath(1)<CR>
    nnoremap <silent> y. :<C-U>call zero#path#CopyDirPath()<CR>
    nnoremap <silent> yd :<C-U>call zero#path#CopyFullDirPath()<CR>
    nnoremap <silent> yD :<C-U>call zero#path#CopyAbsoluteDirPath()<CR>
endif

augroup ZeroVimToggleSetup
    autocmd!
    if v:vim_did_init
        call zero#toggle#Setup()
    else
        autocmd VimEnter * call zero#toggle#Setup()
    endif
augroup END

if get(g:, 'zero_grep_auto_open_quickfix', 0)
    augroup ZeroVimGrepAutoOpenQuickfix
        autocmd!
        autocmd QuickFixCmdPost grep,grepadd call zero#grep#OpenQuickfix()
        autocmd QuickFixCmdPost lgrep,lgrepadd call zero#grep#OpenLocationList()
    augroup END
endif

if get(g:, 'zero_grep_user_commands', 1)
    command! -nargs=* -complete=file_in_path Grep  call zero#grep#Grep(<f-args>)
    command! -nargs=* -complete=file_in_path LGrep call zero#grep#LGrep(<f-args>)
    command! -nargs=*                        BGrep call zero#grep#BGrep(<f-args>)

    command! -nargs=* GrepProject  call zero#grep#GrepProject(<f-args>)
    command! -nargs=* LGrepProject call zero#grep#LGrepProject(<f-args>)

    command! -nargs=* GrepBufferDir  call zero#grep#GrepBufferDir(<f-args>)
    command! -nargs=* LGrepBufferDir call zero#grep#LGrepBufferDir(<f-args>)

    if get(g:, 'zero_grep_extra_user_commands', 0)
        command! -nargs=* -complete=file_in_path        GrepCCword  call zero#grep#Grep('-w', expand('<cword>'), <f-args>)
        command! -nargs=* -complete=file_in_path        GrepCword   call zero#grep#Grep('-F', '-e', expand('<cword>'), <f-args>)
        command! -nargs=* -complete=file_in_path        GrepWord    call zero#grep#Grep('-F', '-e', shellescape(expand('<cWORD>')), <f-args>)
        command! -nargs=* -complete=file_in_path -range GrepVword   call zero#grep#Grep('-F', '-e', shellescape(zero#Vword()), <f-args>)

        command! -nargs=* -complete=file_in_path        LGrepCCword call zero#grep#LGrep('-w', expand('<cword>'), <f-args>)
        command! -nargs=* -complete=file_in_path        LGrepCword  call zero#grep#LGrep('-F', '-e', expand('<cword>'), <f-args>)
        command! -nargs=* -complete=file_in_path        LGrepWord   call zero#grep#LGrep('-F', '-e', shellescape(expand('<cWORD>')), <f-args>)
        command! -nargs=* -complete=file_in_path -range LGrepVword  call zero#grep#LGrep('-F', '-e', shellescape(zero#Vword()), <f-args>)

        command! -nargs=*        GrepProjectCCword call zero#grep#GrepProject('-w', expand('<cword>'), <f-args>)
        command! -nargs=*        GrepProjectCword  call zero#grep#GrepProject('-F', '-e', expand('<cword>'), <f-args>)
        command! -nargs=*        GrepProjectWord   call zero#grep#GrepProject('-F', '-e', shellescape(expand('<cWORD>')), <f-args>)
        command! -nargs=* -range GrepProjectVword  call zero#grep#GrepProject('-F', '-e', shellescape(zero#Vword()), <f-args>)

        command! -nargs=*        LGrepProjectCCword call zero#grep#LGrepProject('-w', expand('<cword>'), <f-args>)
        command! -nargs=*        LGrepProjectCword  call zero#grep#LGrepProject('-F', '-e', expand('<cword>'), <f-args>)
        command! -nargs=*        LGrepProjectWord   call zero#grep#LGrepProject('-F', '-e', shellescape(expand('<cWORD>')), <f-args>)
        command! -nargs=* -range LGrepProjectVword  call zero#grep#LGrepProject('-F', '-e', shellescape(zero#Vword()), <f-args>)

        command! -nargs=*        GrepBufferDirCCword call zero#grep#GrepBufferDir('-w', expand('<cword>'), <f-args>)
        command! -nargs=*        GrepBufferDirCword  call zero#grep#GrepBufferDir('-F', '-e', expand('<cword>'), <f-args>)
        command! -nargs=*        GrepBufferDirWord   call zero#grep#GrepBufferDir('-F', '-e', shellescape(expand('<cWORD>')), <f-args>)
        command! -nargs=* -range GrepBufferDirVword  call zero#grep#GrepBufferDir('-F', '-e', shellescape(zero#Vword()), <f-args>)

        command! -nargs=*        LGrepBufferDirCCword call zero#grep#LGrepBufferDir('-w', expand('<cword>'), <f-args>)
        command! -nargs=*        LGrepBufferDirCword  call zero#grep#LGrepBufferDir('-F', '-e', expand('<cword>'), <f-args>)
        command! -nargs=*        LGrepBufferDirWord   call zero#grep#LGrepBufferDir('-F', '-e', shellescape(expand('<cWORD>')), <f-args>)
        command! -nargs=* -range LGrepBufferDirVword  call zero#grep#LGrepBufferDir('-F', '-e', shellescape(zero#Vword()), <f-args>)
    endif
endif

" Restore cpoptions
let &cpoptions = s:save_cpo
unlet s:save_cpo

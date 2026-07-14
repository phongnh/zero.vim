if !has('vim9script') || has('nvim') || exists('g:loaded_zero_vim')
    finish
endif

vim9script

g:loaded_zero_vim = 1

import autoload 'zero/path.vim' as ZeroPath

if get(g:, 'zero_path_user_commands', 0)
    command! -bang CopyPath            ZeroPath.CopyPath(<bang>0)
    command! -bang CopyFullPath        ZeroPath.CopyFullPath(<bang>0)
    command! -bang CopyAbsolutePath    ZeroPath.CopyAbsolutePath(<bang>0)
    command!       CopyDirPath         ZeroPath.CopyDirPath()
    command!       CopyFullDirPath     ZeroPath.CopyFullDirPath()
    command!       CopyAbsoluteDirPath ZeroPath.CopyAbsoluteDirPath()
endif

if get(g:, 'zero_path_mappings', 1)
    nnoremap <silent> yc <ScriptCmd>call ZeroPath.CopyPath(0)<CR>
    nnoremap <silent> yC <ScriptCmd>call ZeroPath.CopyPath(1)<CR>
    nnoremap <silent> yp <ScriptCmd>call ZeroPath.CopyFullPath(0)<CR>
    nnoremap <silent> yP <ScriptCmd>call ZeroPath.CopyFullPath(1)<CR>
    nnoremap <silent> yu <ScriptCmd>call ZeroPath.CopyAbsolutePath(0)<CR>
    nnoremap <silent> yU <ScriptCmd>call ZeroPath.CopyAbsolutePath(1)<CR>
    nnoremap <silent> y. <ScriptCmd>call ZeroPath.CopyDirPath()<CR>
    nnoremap <silent> yd <ScriptCmd>call ZeroPath.CopyFullDirPath()<CR>
    nnoremap <silent> yD <ScriptCmd>call ZeroPath.CopyAbsoluteDirPath()<CR>
endif

import autoload 'zero/toggle.vim' as ZeroToggle

augroup ZeroVimToggleSetup
    autocmd!
    if v:vim_did_init
        ZeroToggle.Setup()
    else
        autocmd VimEnter * ZeroToggle.Setup()
    endif
augroup END

import autoload 'zero/grep.vim' as ZeroGrep

if get(g:, 'zero_grep_auto_open_quickfix', 0)
    augroup ZeroVimGrepAutoOpenQuickfix
        autocmd!
        autocmd QuickFixCmdPost grep,grepadd ZeroGrep.OpenQuickfix()
        autocmd QuickFixCmdPost lgrep,lgrepadd ZeroGrep.OpenLocationList()
    augroup END
endif

if get(g:, 'zero_grep_user_commands', 1)
    command! -nargs=* -complete=file_in_path Grep           ZeroGrep.Grep(<f-args>)
    command! -nargs=* -complete=file_in_path LGrep          ZeroGrep.LGrep(<f-args>)
    command! -nargs=*                        BGrep          ZeroGrep.BGrep(<f-args>)
    command! -nargs=*                        GrepProject    ZeroGrep.GrepProject(<f-args>)
    command! -nargs=*                        LGrepProject   ZeroGrep.LGrepProject(<f-args>)
    command! -nargs=*                        GrepBufferDir  ZeroGrep.GrepBufferDir(<f-args>)
    command! -nargs=*                        LGrepBufferDir ZeroGrep.LGrepBufferDir(<f-args>)

    command! -nargs=* -range -complete=file_in_path VisualGrep           ZeroGrep.Grep('-F', '-e', shellescape(zero#Vword()), <f-args>)
    command! -nargs=* -range -complete=file_in_path VisualLGrep          ZeroGrep.LGrep('-F', '-e', shellescape(zero#Vword()), <f-args>)
    command! -nargs=* -range                        VisualBGrep          ZeroGrep.BGrep('-F', '-e', shellescape(zero#Vword()), <f-args>)
    command! -nargs=* -range                        VisualGrepProject    ZeroGrep.GrepProject('-F', '-e', shellescape(zero#Vword()), <f-args>)
    command! -nargs=* -range                        VisualLGrepProject   ZeroGrep.LGrepProject('-F', '-e', shellescape(zero#Vword()), <f-args>)
    command! -nargs=* -range                        VisualGrepBufferDir  ZeroGrep.GrepBufferDir('-F', '-e', shellescape(zero#Vword()), <f-args>)
    command! -nargs=* -range                        VisualLGrepBufferDir ZeroGrep.LGrepBufferDir('-F', '-e', shellescape(zero#Vword()), <f-args>)

    if get(g:, 'zero_grep_extra_user_commands', 0)
        command! -nargs=* -complete=file_in_path        GrepCCword  ZeroGrep.Grep('-w', expand('<cword>'), <f-args>)
        command! -nargs=* -complete=file_in_path        GrepCword   ZeroGrep.Grep('-F', '-e', expand('<cword>'), <f-args>)
        command! -nargs=* -complete=file_in_path        GrepWord    ZeroGrep.Grep('-F', '-e', shellescape(expand('<cWORD>')), <f-args>)
        command! -nargs=* -complete=file_in_path -range GrepVword   ZeroGrep.Grep('-F', '-e', shellescape(zero#Vword()), <f-args>)

        command! -nargs=* -complete=file_in_path        LGrepCCword ZeroGrep.LGrep('-w', expand('<cword>'), <f-args>)
        command! -nargs=* -complete=file_in_path        LGrepCword  ZeroGrep.LGrep('-F', '-e', expand('<cword>'), <f-args>)
        command! -nargs=* -complete=file_in_path        LGrepWord   ZeroGrep.LGrep('-F', '-e', shellescape(expand('<cWORD>')), <f-args>)
        command! -nargs=* -complete=file_in_path -range LGrepVword  ZeroGrep.LGrep('-F', '-e', shellescape(zero#Vword()), <f-args>)

        command! -nargs=*        GrepProjectCCword ZeroGrep.GrepProject('-w', expand('<cword>'), <f-args>)
        command! -nargs=*        GrepProjectCword  ZeroGrep.GrepProject('-F', '-e', expand('<cword>'), <f-args>)
        command! -nargs=*        GrepProjectWord   ZeroGrep.GrepProject('-F', '-e', shellescape(expand('<cWORD>')), <f-args>)
        command! -nargs=* -range GrepProjectVword  ZeroGrep.GrepProject('-F', '-e', shellescape(zero#Vword()), <f-args>)

        command! -nargs=*        LGrepProjectCCword ZeroGrep.LGrepProject('-w', expand('<cword>'), <f-args>)
        command! -nargs=*        LGrepProjectCword  ZeroGrep.LGrepProject('-F', '-e', expand('<cword>'), <f-args>)
        command! -nargs=*        LGrepProjectWord   ZeroGrep.LGrepProject('-F', '-e', shellescape(expand('<cWORD>')), <f-args>)
        command! -nargs=* -range LGrepProjectVword  ZeroGrep.LGrepProject('-F', '-e', shellescape(zero#Vword()), <f-args>)

        command! -nargs=*        GrepBufferDirCCword ZeroGrep.GrepBufferDir('-w', expand('<cword>'), <f-args>)
        command! -nargs=*        GrepBufferDirCword  ZeroGrep.GrepBufferDir('-F', '-e', expand('<cword>'), <f-args>)
        command! -nargs=*        GrepBufferDirWord   ZeroGrep.GrepBufferDir('-F', '-e', shellescape(expand('<cWORD>')), <f-args>)
        command! -nargs=* -range GrepBufferDirVword  ZeroGrep.GrepBufferDir('-F', '-e', shellescape(zero#Vword()), <f-args>)

        command! -nargs=*        LGrepBufferDirCCword ZeroGrep.LGrepBufferDir('-w', expand('<cword>'), <f-args>)
        command! -nargs=*        LGrepBufferDirCword  ZeroGrep.LGrepBufferDir('-F', '-e', expand('<cword>'), <f-args>)
        command! -nargs=*        LGrepBufferDirWord   ZeroGrep.LGrepBufferDir('-F', '-e', shellescape(expand('<cWORD>')), <f-args>)
        command! -nargs=* -range LGrepBufferDirVword  ZeroGrep.LGrepBufferDir('-F', '-e', shellescape(zero#Vword()), <f-args>)
    endif
endif

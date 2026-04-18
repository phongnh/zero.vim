if !has('vim9script') || has('nvim') || exists('g:loaded_zero_path')
    finish
endif

vim9script

g:loaded_zero_path = 1

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

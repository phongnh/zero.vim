vim9script

def Copy(path: string)
    @" = path
    if has('clipboard')
        [@*, @+] = [@", @"]
    endif
    echo 'Copied:' @"
enddef

def ExpandPath(path: string, line_number: bool): string
    var result = expand(path)
    if line_number
        result ..= ':' .. line('.')
    endif
    return result
enddef

def DoCopyPath(path: string, line_number: bool)
    Copy(ExpandPath(path, line_number))
enddef

def DoCopyDirPath(path: string)
    var result = ExpandPath(path, false)
    if result == '.'
        result = fnamemodify(getcwd(), ':t')
    endif
    Copy(result)
enddef

export def CopyPath(line_number: bool)
    DoCopyPath('%:~:.', line_number)
enddef

export def CopyFullPath(line_number: bool)
    DoCopyPath('%:p:~', line_number)
enddef

export def CopyAbsolutePath(line_number: bool)
    DoCopyPath('%:p', line_number)
enddef

export def CopyDirPath()
    DoCopyDirPath('%:p:.:h')
enddef

export def CopyFullDirPath()
    DoCopyDirPath('%:p:~:h')
enddef

export def CopyAbsoluteDirPath()
    DoCopyDirPath('%:p:h')
enddef

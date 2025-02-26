" NOTES:
" - All language regular expressions are ported from https://github.com/jacktasia/dumb-jump/blob/master/dumb-jump.el

let s:placeholder = 'KEYWORD'

let s:definitions = {
      \ 'c++': [
      \   '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \   '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \   '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \ ],
      \ 'python': [
      \   '\s*\bKEYWORD\s*=[^=\n]+',
      \   'def\s*KEYWORD\b\s*\(',
      \   'class\s*KEYWORD\b\s*\(?',
      \ ],
      \ 'ruby': [
      \   '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \   '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \   '(^|\W)define(_singleton|_instance)?_method(\s|[(])\s*:KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])module\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   '(^|\W)alias(_method)?\W+KEYWORD(\W|$)',
      \ ],
      \ 'crystal': [
      \   '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \   '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])module\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])struct\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])alias\s+(\w*::)*KEYWORD($|[^\w|:])',
      \ ],
      \ 'shell': [
      \   'function\s*KEYWORD\s*',
      \   'KEYWORD\(\)\s*\{',
      \   '\bKEYWORD\s*=\s*',
      \ ],
      \ 'dart': [
      \   '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \   'class\s*KEYWORD\s*[\(\{]',
      \ ],
      \ 'fennel': [
      \   '\((local|var)\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(fn\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(macro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \ ],
      \ 'go': [
      \   '\s*\bKEYWORD\s*=[^=\n]+',
      \   '\s*\bKEYWORD\s*:=\s*',
      \   'func\s+\([^\)]*\)\s+KEYWORD\s*\(',
      \   'func\s+KEYWORD\s*\(',
      \   'type\s+KEYWORD\s+struct\s+\{',
      \ ],
      \ 'javascript': [
      \   '(service|factory)\([''\"]KEYWORD[''\"]',
      \   '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \   '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \   'class\s*KEYWORD\s*[\(\{]',
      \   'class\s*KEYWORD\s+extends',
      \   '\s*\bKEYWORD\s*=[^=\n]+',
      \   '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \   'function\s*KEYWORD\s*\(',
      \   '\bKEYWORD\s*:\s*function\s*\(',
      \   '\bKEYWORD\s*=\s*function\s*\(',
      \ ],
      \ 'hcl': [
      \   '(variable|output|module)\s*\"KEYWORD\"\s*\{',
      \   '(data|resource)\s*\"\w+\"\s*\"KEYWORD\"\s*\{',
      \ ],
      \ 'typescript': [
      \   '(service|factory)\([''\"]KEYWORD[''\"]',
      \   '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \   '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \   'class\s*KEYWORD\s*[\(\{]',
      \   'class\s*KEYWORD\s+extends',
      \   'function\s*KEYWORD\s*\(',
      \   '\bKEYWORD\s*:\s*function\s*\(',
      \   '\bKEYWORD\s*=\s*function\s*\(',
      \   '\s*\bKEYWORD\s*=[^=\n]+',
      \   '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \ ],
      \ 'lua': [
      \   '\s*\bKEYWORD\s*=[^=\n]+',
      \   '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \   'function\s*KEYWORD\s*\(',
      \   'function\s*.+[.:]KEYWORD\s*\(',
      \   '\bKEYWORD\s*=\s*function\s*\(',
      \   '\b.+\.KEYWORD\s*=\s*function\s*\(',
      \ ],
      \ 'rust': [
      \   '\blet\s+(\([^=\n]*)?(muts+)?KEYWORD([^=\n]*\))?(:\s*[^=\n]+)?\s*=\s*[^=\n]+',
      \   '\bconst\s+KEYWORD:\s*[^=\n]+\s*=[^=\n]+',
      \   '\bstatic\s+(mut\s+)?KEYWORD:\s*[^=\n]+\s*=[^=\n]+',
      \   '\bfn\s+.+\s*\((.+,\s+)?KEYWORD:\s*[^=\n]+\s*(,\s*.+)*\)',
      \   '(if|while)\s+let\s+([^=\n]+)?(mut\s+)?KEYWORD([^=\n\(]+)?\s*=\s*[^=\n]+',
      \   'struct\s+[^\n{]+[{][^}]*(\s*KEYWORD\s*:\s*[^\n},]+)[^}]*}',
      \   'enum\s+[^\n{]+\s*[{][^}]*\bKEYWORD\b[^}]*}',
      \   '\bfn\s+KEYWORD\s*\(',
      \   '\bmacro_rules!\s+KEYWORD',
      \   'struct\s+KEYWORD\s*[{\(]?',
      \   'trait\s+KEYWORD\s*[{]?',
      \   '\btype\s+KEYWORD([^=\n]+)?\s*=[^=\n]+;',
      \   'impl\s+((\w+::)*\w+\s+for\s+)?(\w+::)*KEYWORD\s+[{]?',
      \   'mod\s+KEYWORD\s*[{]?',
      \ ],
      \ 'elixir': [
      \   '\bdef(p)?\s+KEYWORD\s*[ ,\(]',
      \   '\s*KEYWORD\s*=[^=\n]+',
      \   'defmodule\s+(\w+\.)*KEYWORD\s+',
      \   'defprotocol\s+(\w+\.)*KEYWORD\s+',
      \ ],
      \ 'erlang': [
      \   '^KEYWORD\b\s*\(',
      \   '\s*KEYWORD\s*=[^:=\n]+',
      \   '^-module\(KEYWORD\)',
      \ ],
      \ 'sql': [
      \   '(CREATE|create)\s+(.+?\s+)?(FUNCTION|function|PROCEDURE|procedure)\s+KEYWORD\s*\(',
      \   '(CREATE|create)\s+(.+?\s+)?(TABLE|table)(\s+(IF NOT EXISTS|if not exists))?\s+KEYWORD\b',
      \   '(CREATE|create)\s+(.+?\s+)?(VIEW|view)\s+KEYWORD\b',
      \   '(CREATE|create)\s+(.+?\s+)?(TYPE|type)\s+KEYWORD\b',
      \ ],
      \ 'zig': [
      \   'fn\s+KEYWORD\b',
      \   '(var|const)\s+KEYWORD\b',
      \ ],
      \ 'protobuf': [
      \   'message\s+KEYWORD\s*\{',
      \   'enum\s+KEYWORD\s*\{',
      \ ],
      \ 'c': [
      \   '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \   '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \   '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \ ],
      \ 'cpp': [
      \   '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \   '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \   '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \ ],
      \ 'javascriptreact': [
      \   '(service|factory)\([''\"]KEYWORD[''\"]',
      \   '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \   '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \   'class\s*KEYWORD\s*[\(\{]',
      \   'class\s*KEYWORD\s+extends',
      \   '\s*\bKEYWORD\s*=[^=\n]+',
      \   '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \   'function\s*KEYWORD\s*\(',
      \   '\bKEYWORD\s*:\s*function\s*\(',
      \   '\bKEYWORD\s*=\s*function\s*\(',
      \ ],
      \ 'typescriptreact': [
      \   '(service|factory)\([''\"]KEYWORD[''\"]',
      \   '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \   '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \   'class\s*KEYWORD\s*[\(\{]',
      \   'class\s*KEYWORD\s+extends',
      \   'function\s*KEYWORD\s*\(',
      \   '\bKEYWORD\s*:\s*function\s*\(',
      \   '\bKEYWORD\s*=\s*function\s*\(',
      \   '\s*\bKEYWORD\s*=[^=\n]+',
      \   '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \ ],
      \ }

function! s:Regexes(...) abort
  let ft = get(a:, 1, &filetype !=# '' ? &filetype : &buftype)
  if has_key(s:definitions, ft)
    return s:definitions[ft]
  endif
  return []
endfunction

function! zero#dumb_jump#Cword() abort
  let opts = []
  let keyword = expand('<cword>')
  let patterns = []
  for regex in s:Regexes()
    call add(patterns, '(' . substitute(regex, s:placeholder, keyword, 'g') . ')')
  endfor
  if len(patterns)
    " "call add(patterns, '(\b' . keyword . '\b)')
    call add(opts, '-i')
    call add(opts, shellescape('(' . join(patterns, '|') . ')'))
  else
    call add(opts, shellescape('\b' . keyword . '\b'))
  endif
  return join(opts, ' ')
endfunction

function! zero#dumb_jump#CwordRegex() abort
  let opts = []
  let keyword = expand('<cword>')
  let patterns = []
  for regex in s:Regexes()
    call add(patterns, '-e ' . shellescape(substitute(regex, s:placeholder, keyword, 'g')))
  endfor
  if len(patterns)
    call add(opts, '-i')
    call extend(opts, patterns)
    " "call add(opts, '-e ' . printf('''\b%s\b''', keyword))
  else
    call add(opts, printf('''\b%s\b''', keyword))
  endif
  return join(opts, ' ')
endfunction

function! zero#dumb_jump#RgCword() abort
  return join(zero#filetype#RgFileTypeOpts(), ' ') . ' ' . zero#dumb_jump#Cword()
endfunction

function! zero#dumb_jump#RgCwordRegex() abort
  return join(zero#filetype#RgFileTypeOpts(), ' ') . ' ' . zero#dumb_jump#CwordRegex()
endfunction

function! zero#dumb_jump#GitCword() abort
  return zero#dumb_jump#Cword() . ' ' . join(zero#filetype#GitFileTypeOpts(), ' ')
endfunction

function! zero#dumb_jump#GitCwordRegex() abort
  return zero#dumb_jump#CwordRegex() . ' ' . join(zero#filetype#GitFileTypeOpts(), ' ')
endfunction

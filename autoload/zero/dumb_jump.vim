" NOTES:
" - All language regular expressions are ported from https://github.com/jacktasia/dumb-jump/blob/master/dumb-jump.el

let s:placeholder = 'KEYWORD'

let s:definitions = {
      \ 'elisp': [
      \   '\((defun|cl-defun)\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(defmacro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(defvar\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(defcustom\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(setq\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(KEYWORD\s+',
      \   '\((defun|cl-defun)\s*.+\(?\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \ ],
      \ 'commonlisp': [
      \   '\(defun\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(defparameter\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \ ],
      \ 'racket': [
      \   '\(define\s+\(\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(define\s+KEYWORD\s*\(\s*lambda',
      \   '\(let\s+KEYWORD\s*(\(|\[)*',
      \   '\(define\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '(\(|\[)\s*KEYWORD\s+',
      \   '\(lambda\s+\(?[^()]*\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \   '\(define\s+\([^()]+\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \   '\(struct\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \ ],
      \ 'scheme': [
      \   '\(define\s+\(\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(define\s+KEYWORD\s*\(\s*lambda',
      \   '\(let\s+KEYWORD\s*(\(|\[)*',
      \   '\(define\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '(\(|\[)\s*KEYWORD\s+',
      \   '\(lambda\s+\(?[^()]*\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \   '\(define\s+\([^()]+\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \ ],
      \ 'janet': [
      \   '\((de)?f\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(var\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\((de)fn-?\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(defmacro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \ ],
      \ 'c++': [
      \   '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \   '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \   '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \ ],
      \ 'clojure': [
      \   '\(def.* KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \ ],
      \ 'coffeescript': [
      \   '^\s*KEYWORD\s*[=:].*[-=]>',
      \   '^\s*KEYWORD\s*[:=][^:=-][^>]+$',
      \   '^\s*\bclass\s+KEYWORD',
      \ ],
      \ 'objc': [
      \   '\)\s*KEYWORD(:|\b|\s)',
      \   '\b\*?KEYWORD\s*=[^=\n]+',
      \   '(@interface|@protocol|@implementation)\b\s*KEYWORD\b\s*',
      \   'typedef\b\s+(NS_OPTIONS|NS_ENUM)\b\([^,]+?,\s*KEYWORD\b\s*',
      \ ],
      \ 'swift': [
      \   '(let|var)\s*KEYWORD\s*(=|:)[^=:\n]+',
      \   'func\s+KEYWORD\b\s*(<[^>]*>)?\s*\(',
      \   '(class|struct|protocol|enum)\s+KEYWORD\b\s*?',
      \   '(typealias)\s+KEYWORD\b\s*?=',
      \ ],
      \ 'csharp': [
      \   '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \   '\s*\bKEYWORD\s*=[^=\n)]+',
      \   '(class|interface)\s*KEYWORD\b',
      \ ],
      \ 'java': [
      \   '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \   '\s*\bKEYWORD\s*=[^=\n)]+',
      \   '(class|interface)\s*KEYWORD\b',
      \ ],
      \ 'vala': [
      \   '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \   '\s*\bKEYWORD\s*=[^=\n)]+',
      \   '(class|interface)\s*KEYWORD\b',
      \ ],
      \ 'coq': [
      \   '\s*Variable\s+KEYWORD\b',
      \   '\s*Inductive\s+KEYWORD\b',
      \   '\s*Lemma\s+KEYWORD\b',
      \   '\s*Definition\s+KEYWORD\b',
      \   '\s*Hypothesis\s+KEYWORD\b',
      \   '\s*Theorm\s+KEYWORD\b',
      \   '\s*Fixpoint\s+KEYWORD\b',
      \   '\s*Module\s+KEYWORD\b',
      \   '\s*CoInductive\s+KEYWORD\b',
      \ ],
      \ 'python': [
      \   '\s*\bKEYWORD\s*=[^=\n]+',
      \   'def\s*KEYWORD\b\s*\(',
      \   'class\s*KEYWORD\b\s*\(?',
      \ ],
      \ 'matlab': [
      \   '^\s*\bKEYWORD\s*=[^=\n]+',
      \   '^\s*function\s*[^=]+\s*=\s*KEYWORD\b',
      \   '^\s*classdef\s*KEYWORD\b\s*',
      \ ],
      \ 'nim': [
      \   '(const|let|var)\s*KEYWORD\*?\s*(=|:)[^=:\n]+',
      \   '(proc|func|macro|template)\s*\`?KEYWORD\`?\b\*?\s*\(',
      \   'type\s*KEYWORD\b\*?\s*(\{[^}]+\})?\s*=\s*\w+',
      \ ],
      \ 'nix': [
      \   '\b\s*KEYWORD\s*=[^=;]+',
      \ ],
      \ 'ruby': [
      \   '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \   '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \   '(^|\W)define(_singleton|_instance)?_method(\s|[(])\s*:KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])module\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   '(^|\W)alias(_method)?\W+KEYWORD(\W|$)',
      \ ],
      \ 'groovy': [
      \   '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \   '(^|[^\w.])((private|public)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \ ],
      \ 'crystal': [
      \   '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \   '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])module\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])struct\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   '(^|[^\w.])alias\s+(\w*::)*KEYWORD($|[^\w|:])',
      \ ],
      \ 'scad': [
      \   '\s*\bKEYWORD\s*=[^=\n]+',
      \   'function\s*KEYWORD\s*\(',
      \   'module\s*KEYWORD\s*\(',
      \ ],
      \ 'scala': [
      \   '\bval\s*KEYWORD\s*=[^=\n]+',
      \   '\bvar\s*KEYWORD\s*=[^=\n]+',
      \   '\btype\s*KEYWORD\s*=[^=\n]+',
      \   '\bdef\s*KEYWORD\s*\(',
      \   'class\s*KEYWORD\s*\(?',
      \   'trait\s*KEYWORD\s*\(?',
      \   'object\s*KEYWORD\s*\(?',
      \ ],
      \ 'solidity': [
      \   'function\s*KEYWORD\s*\(',
      \   'modifier\s*KEYWORD\s*\(',
      \   'event\s*KEYWORD\s*\(',
      \   'error\s*KEYWORD\s*\(',
      \   'contract\s*KEYWORD\s*(is|\{)',
      \ ],
      \ 'r': [
      \   '\bKEYWORD\s*=[^=><]',
      \   '\bKEYWORD\s*<-\s*function\b',
      \ ],
      \ 'perl': [
      \   'sub\s*KEYWORD\s*(\{|\()',
      \   'KEYWORD\s*=\s*',
      \ ],
      \ 'tcl': [
      \   'proc\s+KEYWORD\s*\{',
      \   'set\s+KEYWORD',
      \   '(variable|global)\s+KEYWORD',
      \ ],
      \ 'shell': [
      \   'function\s*KEYWORD\s*',
      \   'KEYWORD\(\)\s*\{',
      \   '\bKEYWORD\s*=\s*',
      \ ],
      \ 'php': [
      \   'function\s*KEYWORD\s*\(',
      \   '\*\s@method\s+[^ 	]+\s+KEYWORD\(',
      \   '(\s|->|\$|::)KEYWORD\s*=\s*',
      \   '\*\s@property(-read|-write)?\s+([^ 	]+\s+)&?\$KEYWORD(\s+|$)',
      \   'trait\s*KEYWORD\s*\{',
      \   'interface\s*KEYWORD\s*\{',
      \   'class\s*KEYWORD\s*(extends|implements|\{)',
      \ ],
      \ 'dart': [
      \   '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \   'class\s*KEYWORD\s*[\(\{]',
      \ ],
      \ 'faust': [
      \   '\bKEYWORD(\(.+\))*\s*=',
      \ ],
      \ 'fennel': [
      \   '\((local|var)\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(fn\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\(macro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \ ],
      \ 'fortran': [
      \   '\s*\bKEYWORD\s*=[^=\n]+',
      \   '\b(function|subroutine|FUNCTION|SUBROUTINE)\s+KEYWORD\b\s*\(',
      \   '^\s*(interface|INTERFACE)\s+KEYWORD\b',
      \   '^\s*(module|MODULE)\s+KEYWORD\s*',
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
      \ 'julia': [
      \   '(@noinline|@inline)?\s*function\s*KEYWORD(\{[^\}]*\})?\(',
      \   '(@noinline|@inline)?KEYWORD(\{[^\}]*\})?\([^\)]*\)s*=',
      \   'macro\s*KEYWORD\(',
      \   'const\s+KEYWORD\b',
      \   '(mutable)?\s*struct\s*KEYWORD',
      \   '(type|immutable|abstract)\s*KEYWORD',
      \ ],
      \ 'haskell': [
      \   '^module\s+KEYWORD\s+',
      \   '^\bKEYWORD(?!(\s+::))\s+((.|\s)*?)=\s+',
      \   '^\s*((data(\s+family)?)|(newtype)|(type(\s+family)?))\s+KEYWORD\s+',
      \   '(data|newtype)\s{1,3}(?!KEYWORD\s+)([^=]{1,40})=((\s{0,3}KEYWORD\s+)|([^=]{0,500}?((?<!(-- ))\|\s{0,3}KEYWORD\s+)))',
      \   '(data|newtype)([^=]*)=[^=]*?({([^=}]*?)(\bKEYWORD)\s+::[^=}]+})',
      \   '^class\s+(.+=>\s*)?KEYWORD\s+',
      \ ],
      \ 'ocaml': [
      \   '^\s*(and|type)\s+.*\bKEYWORD\b',
      \   'let\s+KEYWORD\b',
      \   'let\s+rec\s+KEYWORD\b',
      \   '\s*val\s*\bKEYWORD\b\s*',
      \   '^\s*module\s*\bKEYWORD\b',
      \   '^\s*module\s*type\s*\bKEYWORD\b',
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
      \ 'scss': [
      \   '@mixin\sKEYWORD\b\s*\(',
      \   '@function\sKEYWORD\b\s*\(',
      \   'KEYWORD\s*:\s*',
      \ ],
      \ 'sml': [
      \   '\s*(data)?type\s+.*\bKEYWORD\b',
      \   '\s*val\s+\bKEYWORD\b',
      \   '\s*fun\s+\bKEYWORD\b.*\s*=',
      \   '\s*(structure|signature|functor)\s+\bKEYWORD\b',
      \ ],
      \ 'sql': [
      \   '(CREATE|create)\s+(.+?\s+)?(FUNCTION|function|PROCEDURE|procedure)\s+KEYWORD\s*\(',
      \   '(CREATE|create)\s+(.+?\s+)?(TABLE|table)(\s+(IF NOT EXISTS|if not exists))?\s+KEYWORD\b',
      \   '(CREATE|create)\s+(.+?\s+)?(VIEW|view)\s+KEYWORD\b',
      \   '(CREATE|create)\s+(.+?\s+)?(TYPE|type)\s+KEYWORD\b',
      \ ],
      \ 'systemverilog': [
      \   '\s*class\s+\bKEYWORD\b',
      \   '\s*task\s+\bKEYWORD\b',
      \   '\s*\bKEYWORD\b\s*=',
      \   'function\s[^\s]+\s*\bKEYWORD\b',
      \   '^\s*[^\s]*\s*[^\s]+\s+\bKEYWORD\b',
      \ ],
      \ 'vhdl': [
      \   '\s*type\s+\bKEYWORD\b',
      \   '\s*constant\s+\bKEYWORD\b',
      \   'function\s*\"?KEYWORD\"?\s*\(',
      \ ],
      \ 'tex': [
      \   '\\.*newcommand\*?\s*\{\s*(\\)KEYWORD\s*}',
      \   '\\.*newcommand\*?\s*(\\)KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   '\\(s)etlength\s*\{\s*(\\)KEYWORD\s*}',
      \   '\\newcounter\{\s*KEYWORD\s*}',
      \   '\\.*newenvironment\s*\{\s*KEYWORD\s*}',
      \ ],
      \ 'pascal': [
      \   '\bfunction\s+KEYWORD\b',
      \   '\bprocedure\s+KEYWORD\b',
      \ ],
      \ 'fsharp': [
      \   'let\s+KEYWORD\b.*\=',
      \   'member(\b.+\.|\s+)KEYWORD\b.*\=',
      \   'type\s+KEYWORD\b.*\=',
      \ ],
      \ 'kotlin': [
      \   'fun\s*(<[^>]*>)?\s*KEYWORD\s*\(',
      \   '(val|var)\s*KEYWORD\b',
      \   '(class|interface)\s*KEYWORD\b',
      \ ],
      \ 'zig': [
      \   'fn\s+KEYWORD\b',
      \   '(var|const)\s+KEYWORD\b',
      \ ],
      \ 'protobuf': [
      \   'message\s+KEYWORD\s*\{',
      \   'enum\s+KEYWORD\s*\{',
      \ ],
      \ 'apex': [
      \   '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \   '\s*\bKEYWORD\s*=[^=\n)]+',
      \   '(class|interface)\s*KEYWORD\b',
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

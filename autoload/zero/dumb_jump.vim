" NOTES:
" - All language regular expressions are ported from https://github.com/jacktasia/dumb-jump/blob/master/dumb-jump.el

let s:definitions = {
      \ 'elisp': {
      \   'function': [
      \     '\((defun|cl-defun)\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     '\(defmacro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   ],
      \   'variable': [
      \     '\(defvar\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     '\(defcustom\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     '\(setq\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     '\(KEYWORD\s+',
      \     '\((defun|cl-defun)\s*.+\(?\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \   ],
      \ },
      \ 'commonlisp': {
      \   'function': [
      \     '\(defun\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   ],
      \   'variable': [
      \     '\(defparameter\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   ],
      \ },
      \ 'racket': {
      \   'function': [
      \     '\(define\s+\(\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     '\(define\s+KEYWORD\s*\(\s*lambda',
      \     '\(let\s+KEYWORD\s*(\(|\[)*',
      \   ],
      \   'variable': [
      \     '\(define\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     '(\(|\[)\s*KEYWORD\s+',
      \     '\(lambda\s+\(?[^()]*\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \     '\(define\s+\([^()]+\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \   ],
      \   'type': [
      \     '\(struct\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   ],
      \ },
      \ 'scheme': {
      \   'function': [
      \     '\(define\s+\(\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     '\(define\s+KEYWORD\s*\(\s*lambda',
      \     '\(let\s+KEYWORD\s*(\(|\[)*',
      \   ],
      \   'variable': [
      \     '\(define\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     '(\(|\[)\s*KEYWORD\s+',
      \     '\(lambda\s+\(?[^()]*\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \     '\(define\s+\([^()]+\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \   ],
      \ },
      \ 'janet': {
      \   'variable': [
      \     '\((de)?f\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     '\(var\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   ],
      \   'function': [
      \     '\((de)fn-?\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     '\(defmacro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   ],
      \ },
      \ 'c++': {
      \   'function': [
      \     '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \   ],
      \   'variable': [
      \     '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \   ],
      \   'type': [
      \     '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \   ],
      \ },
      \ 'clojure': {
      \   'variable': [
      \     '\(def.* KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   ],
      \ },
      \ 'coffeescript': {
      \   'function': [
      \     '^\s*KEYWORD\s*[=:].*[-=]>',
      \   ],
      \   'variable': [
      \     '^\s*KEYWORD\s*[:=][^:=-][^>]+$',
      \   ],
      \   'class': [
      \     '^\s*\bclass\s+KEYWORD',
      \   ],
      \ },
      \ 'objc': {
      \   'function': [
      \     '\)\s*KEYWORD(:|\b|\s)',
      \   ],
      \   'variable': [
      \     '\b\*?KEYWORD\s*=[^=\n]+',
      \   ],
      \   'type': [
      \     '(@interface|@protocol|@implementation)\b\s*KEYWORD\b\s*',
      \     'typedef\b\s+(NS_OPTIONS|NS_ENUM)\b\([^,]+?,\s*KEYWORD\b\s*',
      \   ],
      \ },
      \ 'swift': {
      \   'variable': [
      \     '(let|var)\s*KEYWORD\s*(=|:)[^=:\n]+',
      \   ],
      \   'function': [
      \     'func\s+KEYWORD\b\s*(<[^>]*>)?\s*\(',
      \   ],
      \   'type': [
      \     '(class|struct|protocol|enum)\s+KEYWORD\b\s*?',
      \     '(typealias)\s+KEYWORD\b\s*?=',
      \   ],
      \ },
      \ 'csharp': {
      \   'function': [
      \     '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \   ],
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n)]+',
      \   ],
      \   'type': [
      \     '(class|interface)\s*KEYWORD\b',
      \   ],
      \ },
      \ 'java': {
      \   'function': [
      \     '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \   ],
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n)]+',
      \   ],
      \   'type': [
      \     '(class|interface)\s*KEYWORD\b',
      \   ],
      \ },
      \ 'vala': {
      \   'function': [
      \     '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \   ],
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n)]+',
      \   ],
      \   'type': [
      \     '(class|interface)\s*KEYWORD\b',
      \   ],
      \ },
      \ 'coq': {
      \   'function': [
      \     '\s*Variable\s+KEYWORD\b',
      \     '\s*Inductive\s+KEYWORD\b',
      \     '\s*Lemma\s+KEYWORD\b',
      \     '\s*Definition\s+KEYWORD\b',
      \     '\s*Hypothesis\s+KEYWORD\b',
      \     '\s*Theorm\s+KEYWORD\b',
      \     '\s*Fixpoint\s+KEYWORD\b',
      \     '\s*Module\s+KEYWORD\b',
      \     '\s*CoInductive\s+KEYWORD\b',
      \   ],
      \ },
      \ 'python': {
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n]+',
      \   ],
      \   'function': [
      \     'def\s*KEYWORD\b\s*\(',
      \   ],
      \   'type': [
      \     'class\s*KEYWORD\b\s*\(?',
      \   ],
      \ },
      \ 'matlab': {
      \   'variable': [
      \     '^\s*\bKEYWORD\s*=[^=\n]+',
      \   ],
      \   'function': [
      \     '^\s*function\s*[^=]+\s*=\s*KEYWORD\b',
      \   ],
      \   'type': [
      \     '^\s*classdef\s*KEYWORD\b\s*',
      \   ],
      \ },
      \ 'nim': {
      \   'variable': [
      \     '(const|let|var)\s*KEYWORD\*?\s*(=|:)[^=:\n]+',
      \   ],
      \   'function': [
      \     '(proc|func|macro|template)\s*\`?KEYWORD\`?\b\*?\s*\(',
      \   ],
      \   'type': [
      \     'type\s*KEYWORD\b\*?\s*(\{[^}]+\})?\s*=\s*\w+',
      \   ],
      \ },
      \ 'nix': {
      \   'variable': [
      \     '\b\s*KEYWORD\s*=[^=;]+',
      \   ],
      \ },
      \ 'ruby': {
      \   'variable': [
      \     '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \   ],
      \   'function': [
      \     '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \     '(^|\W)define(_singleton|_instance)?_method(\s|[(])\s*:KEYWORD($|[^\w|:])',
      \     '(^|\W)alias(_method)?\W+KEYWORD(\W|$)',
      \   ],
      \   'type': [
      \     '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     '(^|[^\w.])module\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   ],
      \ },
      \ 'groovy': {
      \   'variable': [
      \     '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \   ],
      \   'function': [
      \     '(^|[^\w.])((private|public)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \   ],
      \   'type': [
      \     '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   ],
      \ },
      \ 'crystal': {
      \   'variable': [
      \     '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \   ],
      \   'function': [
      \     '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \   ],
      \   'type': [
      \     '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     '(^|[^\w.])module\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     '(^|[^\w.])struct\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     '(^|[^\w.])alias\s+(\w*::)*KEYWORD($|[^\w|:])',
      \   ],
      \ },
      \ 'scad': {
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n]+',
      \   ],
      \   'function': [
      \     'function\s*KEYWORD\s*\(',
      \   ],
      \   'module': [
      \     'module\s*KEYWORD\s*\(',
      \   ],
      \ },
      \ 'scala': {
      \   'variable': [
      \     '\bval\s*KEYWORD\s*=[^=\n]+',
      \     '\bvar\s*KEYWORD\s*=[^=\n]+',
      \     '\btype\s*KEYWORD\s*=[^=\n]+',
      \   ],
      \   'function': [
      \     '\bdef\s*KEYWORD\s*\(',
      \   ],
      \   'type': [
      \     'class\s*KEYWORD\s*\(?',
      \     'trait\s*KEYWORD\s*\(?',
      \     'object\s*KEYWORD\s*\(?',
      \   ],
      \ },
      \ 'solidity': {
      \   'function': [
      \     'function\s*KEYWORD\s*\(',
      \   ],
      \   'modifier': [
      \     'modifier\s*KEYWORD\s*\(',
      \   ],
      \   'event': [
      \     'event\s*KEYWORD\s*\(',
      \   ],
      \   'error': [
      \     'error\s*KEYWORD\s*\(',
      \   ],
      \   'contract': [
      \     'contract\s*KEYWORD\s*(is|\{)',
      \   ],
      \ },
      \ 'r': {
      \   'variable': [
      \     '\bKEYWORD\s*=[^=><]',
      \   ],
      \   'function': [
      \     '\bKEYWORD\s*<-\s*function\b',
      \   ],
      \ },
      \ 'perl': {
      \   'function': [
      \     'sub\s*KEYWORD\s*(\{|\()',
      \   ],
      \   'variable': [
      \     'KEYWORD\s*=\s*',
      \   ],
      \ },
      \ 'tcl': {
      \   'function': [
      \     'proc\s+KEYWORD\s*\{',
      \   ],
      \   'variable': [
      \     'set\s+KEYWORD',
      \     '(variable|global)\s+KEYWORD',
      \   ],
      \ },
      \ 'shell': {
      \   'function': [
      \     'function\s*KEYWORD\s*',
      \     'KEYWORD\(\)\s*\{',
      \   ],
      \   'variable': [
      \     '\bKEYWORD\s*=\s*',
      \   ],
      \ },
      \ 'php': {
      \   'function': [
      \     'function\s*KEYWORD\s*\(',
      \     '\*\s@method\s+[^ 	]+\s+KEYWORD\(',
      \   ],
      \   'variable': [
      \     '(\s|->|\$|::)KEYWORD\s*=\s*',
      \     '\*\s@property(-read|-write)?\s+([^ 	]+\s+)&?\$KEYWORD(\s+|$)',
      \   ],
      \   'trait': [
      \     'trait\s*KEYWORD\s*\{',
      \   ],
      \   'interface': [
      \     'interface\s*KEYWORD\s*\{',
      \   ],
      \   'class': [
      \     'class\s*KEYWORD\s*(extends|implements|\{)',
      \   ],
      \ },
      \ 'dart': {
      \   'function': [
      \     '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'class\s*KEYWORD\s*[\(\{]',
      \   ],
      \ },
      \ 'faust': {
      \   'function': [
      \     '\bKEYWORD(\(.+\))*\s*=',
      \   ],
      \ },
      \ 'fennel': {
      \   'variable': [
      \     '\((local|var)\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   ],
      \   'function': [
      \     '\(fn\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     '\(macro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   ],
      \ },
      \ 'fortran': {
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n]+',
      \   ],
      \   'function': [
      \     '\b(function|subroutine|FUNCTION|SUBROUTINE)\s+KEYWORD\b\s*\(',
      \     '^\s*(interface|INTERFACE)\s+KEYWORD\b',
      \   ],
      \   'type': [
      \     '^\s*(module|MODULE)\s+KEYWORD\s*',
      \   ],
      \ },
      \ 'go': {
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n]+',
      \     '\s*\bKEYWORD\s*:=\s*',
      \   ],
      \   'function': [
      \     'func\s+\([^\)]*\)\s+KEYWORD\s*\(',
      \     'func\s+KEYWORD\s*\(',
      \   ],
      \   'type': [
      \     'type\s+KEYWORD\s+struct\s+\{',
      \   ],
      \ },
      \ 'javascript': {
      \   'function': [
      \     '(service|factory)\([''\"]KEYWORD[''\"]',
      \     '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \     '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'class\s*KEYWORD\s*[\(\{]',
      \     'class\s*KEYWORD\s+extends',
      \     'function\s*KEYWORD\s*\(',
      \     '\bKEYWORD\s*:\s*function\s*\(',
      \     '\bKEYWORD\s*=\s*function\s*\(',
      \   ],
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n]+',
      \     '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \   ],
      \ },
      \ 'hcl': {
      \   'block': [
      \     '(variable|output|module)\s*\"KEYWORD\"\s*\{',
      \     '(data|resource)\s*\"\w+\"\s*\"KEYWORD\"\s*\{',
      \   ],
      \ },
      \ 'typescript': {
      \   'function': [
      \     '(service|factory)\([''\"]KEYWORD[''\"]',
      \     '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \     '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'class\s*KEYWORD\s*[\(\{]',
      \     'class\s*KEYWORD\s+extends',
      \     'function\s*KEYWORD\s*\(',
      \     '\bKEYWORD\s*:\s*function\s*\(',
      \     '\bKEYWORD\s*=\s*function\s*\(',
      \   ],
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n]+',
      \     '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \   ],
      \ },
      \ 'julia': {
      \   'function': [
      \     '(@noinline|@inline)?\s*function\s*KEYWORD(\{[^\}]*\})?\(',
      \     '(@noinline|@inline)?KEYWORD(\{[^\}]*\})?\([^\)]*\)s*=',
      \     'macro\s*KEYWORD\(',
      \   ],
      \   'variable': [
      \     'const\s+KEYWORD\b',
      \   ],
      \   'type': [
      \     '(mutable)?\s*struct\s*KEYWORD',
      \     '(type|immutable|abstract)\s*KEYWORD',
      \   ],
      \ },
      \ 'haskell': {
      \   'module': [
      \     '^module\s+KEYWORD\s+',
      \   ],
      \   'top level function': [
      \     '^\bKEYWORD(?!(\s+::))\s+((.|\s)*?)=\s+',
      \   ],
      \   'type-like': [
      \     '^\s*((data(\s+family)?)|(newtype)|(type(\s+family)?))\s+KEYWORD\s+',
      \   ],
      \   '(data)type constructor 1': [
      \     '(data|newtype)\s{1,3}(?!KEYWORD\s+)([^=]{1,40})=((\s{0,3}KEYWORD\s+)|([^=]{0,500}?((?<!(-- ))\|\s{0,3}KEYWORD\s+)))',
      \   ],
      \   'data/newtype record field': [
      \     '(data|newtype)([^=]*)=[^=]*?({([^=}]*?)(\bKEYWORD)\s+::[^=}]+})',
      \   ],
      \   'typeclass': [
      \     '^class\s+(.+=>\s*)?KEYWORD\s+',
      \   ],
      \ },
      \ 'ocaml': {
      \   'type': [
      \     '^\s*(and|type)\s+.*\bKEYWORD\b',
      \   ],
      \   'variable': [
      \     'let\s+KEYWORD\b',
      \     'let\s+rec\s+KEYWORD\b',
      \     '\s*val\s*\bKEYWORD\b\s*',
      \   ],
      \   'module': [
      \     '^\s*module\s*\bKEYWORD\b',
      \     '^\s*module\s*type\s*\bKEYWORD\b',
      \   ],
      \ },
      \ 'lua': {
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n]+',
      \     '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \   ],
      \   'function': [
      \     'function\s*KEYWORD\s*\(',
      \     'function\s*.+[.:]KEYWORD\s*\(',
      \     '\bKEYWORD\s*=\s*function\s*\(',
      \     '\b.+\.KEYWORD\s*=\s*function\s*\(',
      \   ],
      \ },
      \ 'rust': {
      \   'variable': [
      \     '\blet\s+(\([^=\n]*)?(muts+)?KEYWORD([^=\n]*\))?(:\s*[^=\n]+)?\s*=\s*[^=\n]+',
      \     '\bconst\s+KEYWORD:\s*[^=\n]+\s*=[^=\n]+',
      \     '\bstatic\s+(mut\s+)?KEYWORD:\s*[^=\n]+\s*=[^=\n]+',
      \     '\bfn\s+.+\s*\((.+,\s+)?KEYWORD:\s*[^=\n]+\s*(,\s*.+)*\)',
      \     '(if|while)\s+let\s+([^=\n]+)?(mut\s+)?KEYWORD([^=\n\(]+)?\s*=\s*[^=\n]+',
      \     'struct\s+[^\n{]+[{][^}]*(\s*KEYWORD\s*:\s*[^\n},]+)[^}]*}',
      \     'enum\s+[^\n{]+\s*[{][^}]*\bKEYWORD\b[^}]*}',
      \   ],
      \   'function': [
      \     '\bfn\s+KEYWORD\s*\(',
      \     '\bmacro_rules!\s+KEYWORD',
      \   ],
      \   'type': [
      \     'struct\s+KEYWORD\s*[{\(]?',
      \     'trait\s+KEYWORD\s*[{]?',
      \     '\btype\s+KEYWORD([^=\n]+)?\s*=[^=\n]+;',
      \     'impl\s+((\w+::)*\w+\s+for\s+)?(\w+::)*KEYWORD\s+[{]?',
      \     'mod\s+KEYWORD\s*[{]?',
      \   ],
      \ },
      \ 'elixir': {
      \   'function': [
      \     '\bdef(p)?\s+KEYWORD\s*[ ,\(]',
      \   ],
      \   'variable': [
      \     '\s*KEYWORD\s*=[^=\n]+',
      \   ],
      \   'module': [
      \     'defmodule\s+(\w+\.)*KEYWORD\s+',
      \     'defprotocol\s+(\w+\.)*KEYWORD\s+',
      \   ],
      \ },
      \ 'erlang': {
      \   'function': [
      \     '^KEYWORD\b\s*\(',
      \   ],
      \   'variable': [
      \     '\s*KEYWORD\s*=[^:=\n]+',
      \   ],
      \   'module': [
      \     '^-module\(KEYWORD\)',
      \   ],
      \ },
      \ 'scss': {
      \   'function': [
      \     '@mixin\sKEYWORD\b\s*\(',
      \     '@function\sKEYWORD\b\s*\(',
      \   ],
      \   'variable': [
      \     'KEYWORD\s*:\s*',
      \   ],
      \ },
      \ 'sml': {
      \   'type': [
      \     '\s*(data)?type\s+.*\bKEYWORD\b',
      \   ],
      \   'variable': [
      \     '\s*val\s+\bKEYWORD\b',
      \   ],
      \   'function': [
      \     '\s*fun\s+\bKEYWORD\b.*\s*=',
      \   ],
      \   'module': [
      \     '\s*(structure|signature|functor)\s+\bKEYWORD\b',
      \   ],
      \ },
      \ 'sql': {
      \   'function': [
      \     '(CREATE|create)\s+(.+?\s+)?(FUNCTION|function|PROCEDURE|procedure)\s+KEYWORD\s*\(',
      \   ],
      \   'table': [
      \     '(CREATE|create)\s+(.+?\s+)?(TABLE|table)(\s+(IF NOT EXISTS|if not exists))?\s+KEYWORD\b',
      \   ],
      \   'view': [
      \     '(CREATE|create)\s+(.+?\s+)?(VIEW|view)\s+KEYWORD\b',
      \   ],
      \   'type': [
      \     '(CREATE|create)\s+(.+?\s+)?(TYPE|type)\s+KEYWORD\b',
      \   ],
      \ },
      \ 'systemverilog': {
      \   'type': [
      \     '\s*class\s+\bKEYWORD\b',
      \     '\s*task\s+\bKEYWORD\b',
      \     '\s*\bKEYWORD\b\s*=',
      \   ],
      \   'function': [
      \     'function\s[^\s]+\s*\bKEYWORD\b',
      \     '^\s*[^\s]*\s*[^\s]+\s+\bKEYWORD\b',
      \   ],
      \ },
      \ 'vhdl': {
      \   'type': [
      \     '\s*type\s+\bKEYWORD\b',
      \     '\s*constant\s+\bKEYWORD\b',
      \   ],
      \   'function': [
      \     'function\s*\"?KEYWORD\"?\s*\(',
      \   ],
      \ },
      \ 'tex': {
      \   'command': [
      \     '\\.*newcommand\*?\s*\{\s*(\\)KEYWORD\s*}',
      \     '\\.*newcommand\*?\s*(\\)KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \   ],
      \   'length': [
      \     '\\(s)etlength\s*\{\s*(\\)KEYWORD\s*}',
      \   ],
      \   'counter': [
      \     '\\newcounter\{\s*KEYWORD\s*}',
      \   ],
      \   'environment': [
      \     '\\.*newenvironment\s*\{\s*KEYWORD\s*}',
      \   ],
      \ },
      \ 'pascal': {
      \   'function': [
      \     '\bfunction\s+KEYWORD\b',
      \     '\bprocedure\s+KEYWORD\b',
      \   ],
      \ },
      \ 'fsharp': {
      \   'variable': [
      \     'let\s+KEYWORD\b.*\=',
      \   ],
      \   'interface': [
      \     'member(\b.+\.|\s+)KEYWORD\b.*\=',
      \   ],
      \   'type': [
      \     'type\s+KEYWORD\b.*\=',
      \   ],
      \ },
      \ 'kotlin': {
      \   'function': [
      \     'fun\s*(<[^>]*>)?\s*KEYWORD\s*\(',
      \   ],
      \   'variable': [
      \     '(val|var)\s*KEYWORD\b',
      \   ],
      \   'type': [
      \     '(class|interface)\s*KEYWORD\b',
      \   ],
      \ },
      \ 'zig': {
      \   'function': [
      \     'fn\s+KEYWORD\b',
      \   ],
      \   'variable': [
      \     '(var|const)\s+KEYWORD\b',
      \   ],
      \ },
      \ 'protobuf': {
      \   'message': [
      \     'message\s+KEYWORD\s*\{',
      \   ],
      \   'enum': [
      \     'enum\s+KEYWORD\s*\{',
      \   ],
      \ },
      \ 'apex': {
      \   'function': [
      \     '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \   ],
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n)]+',
      \   ],
      \   'type': [
      \     '(class|interface)\s*KEYWORD\b',
      \   ],
      \ },
      \ 'c': {
      \   'function': [
      \     '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \   ],
      \   'variable': [
      \     '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \   ],
      \   'type': [
      \     '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \   ],
      \ },
      \ 'cpp': {
      \   'function': [
      \     '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \   ],
      \   'variable': [
      \     '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \   ],
      \   'type': [
      \     '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \   ],
      \ },
      \ 'javascriptreact': {
      \   'function': [
      \     '(service|factory)\([''\"]KEYWORD[''\"]',
      \     '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \     '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'class\s*KEYWORD\s*[\(\{]',
      \     'class\s*KEYWORD\s+extends',
      \     'function\s*KEYWORD\s*\(',
      \     '\bKEYWORD\s*:\s*function\s*\(',
      \     '\bKEYWORD\s*=\s*function\s*\(',
      \   ],
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n]+',
      \     '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \   ],
      \ },
      \ 'typescriptreact': {
      \   'function': [
      \     '(service|factory)\([''\"]KEYWORD[''\"]',
      \     '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \     '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'class\s*KEYWORD\s*[\(\{]',
      \     'class\s*KEYWORD\s+extends',
      \     'function\s*KEYWORD\s*\(',
      \     '\bKEYWORD\s*:\s*function\s*\(',
      \     '\bKEYWORD\s*=\s*function\s*\(',
      \   ],
      \   'variable': [
      \     '\s*\bKEYWORD\s*=[^=\n]+',
      \     '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \   ],
      \ },
      \ }

function! zero#dumb_jump#get(...) abort
  let ft = get(a:, 1, &filetype !=# '' ? &filetype : &buftype)
  if has_key(s:definitions, ft)
    let result = []
    for [type, regexes] in items(s:definitions[ft])
      call extend(result, regexes)
    endfor
    return result
  endif
  return []
endfunction

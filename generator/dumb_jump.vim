" NOTES:
" - All language regular expressions are ported from https://github.com/jacktasia/dumb-jump/blob/master/dumb-jump.el

let s:tools = {
      \ 'elisp': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'commonlisp': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'racket': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'scheme': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'janet': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'c++': ['ag', 'rg', 'git-grep'],
      \ 'clojure': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'coffeescript': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'objc': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'swift': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'csharp': ['ag', 'rg', 'grep', 'git-grep'],
      \ 'java': ['ag', 'rg', 'grep', 'git-grep'],
      \ 'vala': ['ag', 'rg', 'grep', 'git-grep'],
      \ 'coq': ['ag', 'rg', 'git-grep'],
      \ 'python': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'matlab': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'nim': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'nix': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'ruby': ['ag', 'rg', 'git-grep'],
      \ 'groovy': ['ag', 'rg', 'git-grep'],
      \ 'crystal': ['ag', 'rg', 'git-grep'],
      \ 'scad': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'scala': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'solidity': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'r': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'perl': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'tcl': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'shell': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'php': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'dart': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'faust': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'fennel': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'fortran': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'go': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'javascript': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'hcl': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'typescript': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'julia': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'haskell': ['ag'],
      \ 'ocaml': ['ag', 'rg'],
      \ 'lua': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'rust': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'elixir': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'erlang': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'scss': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'sml': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'sql': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'systemverilog': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'vhdl': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'tex': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'pascal': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'fsharp': ['ag', 'grep', 'git-grep'],
      \ 'kotlin': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'zig': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'protobuf': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'apex': ['ag', 'rg', 'grep', 'git-grep'],
      \ 'c': ['ag', 'rg', 'git-grep'],
      \ 'cpp': ['ag', 'rg', 'git-grep'],
      \ 'javascriptreact': ['ag', 'grep', 'rg', 'git-grep'],
      \ 'typescriptreact': ['ag', 'grep', 'rg', 'git-grep'],
      \ }

let s:rules = {
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
      \ }

let s:definitions = {
      \ 'elisp': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\((defun|cl-defun)\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\((defun|cl-defun)\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(defmacro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(defmacro\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(defvar\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(defvar\b\s*JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(defcustom\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(defcustom\b\s*JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(setq\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(setq\b\s*JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(KEYWORD\s+',
      \     'regex': '\(JJJ\s+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\((defun|cl-defun)\s*.+\(?\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \     'regex': '\((defun|cl-defun)\s*.+\(?\s*JJJ\j\s*\)?',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'commonlisp': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(defun\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(defun\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(defparameter\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(defparameter\b\s*JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'racket': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(define\s+\(\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(define\s+\(\s*JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(define\s+KEYWORD\s*\(\s*lambda',
      \     'regex': '\(define\s+JJJ\s*\(\s*lambda',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(let\s+KEYWORD\s*(\(|\[)*',
      \     'regex': '\(let\s+JJJ\s*(\(|\[)*',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(define\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(define\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(\(|\[)\s*KEYWORD\s+',
      \     'regex': '(\(|\[)\s*JJJ\s+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(lambda\s+\(?[^()]*\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \     'regex': '\(lambda\s+\(?[^()]*\s*JJJ\j\s*\)?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(define\s+\([^()]+\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \     'regex': '\(define\s+\([^()]+\s*JJJ\j\s*\)?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\(struct\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(struct\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'scheme': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(define\s+\(\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(define\s+\(\s*JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(define\s+KEYWORD\s*\(\s*lambda',
      \     'regex': '\(define\s+JJJ\s*\(\s*lambda',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(let\s+KEYWORD\s*(\(|\[)*',
      \     'regex': '\(let\s+JJJ\s*(\(|\[)*',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(define\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(define\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(\(|\[)\s*KEYWORD\s+',
      \     'regex': '(\(|\[)\s*JJJ\s+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(lambda\s+\(?[^()]*\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \     'regex': '\(lambda\s+\(?[^()]*\s*JJJ\j\s*\)?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(define\s+\([^()]+\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \     'regex': '\(define\s+\([^()]+\s*JJJ\j\s*\)?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'janet': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\((de)?f\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\((de)?f\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(var\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(var\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\((de)fn-?\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\((de)fn-?\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(defmacro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(defmacro\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'c++': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \     'regex': '\bJJJ(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+JJJ(\)|\s)*\(',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \     'regex': '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+JJJ\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+JJJ\b',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \     'regex': '\b(class|struct|enum|union)\b\s*JJJ\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*JJJ\b\s*;',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'clojure': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(def.* KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(def.* JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'coffeescript': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*KEYWORD\s*[=:].*[-=]>',
      \     'regex': '^\s*JJJ\s*[=:].*[-=]>',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '^\s*KEYWORD\s*[:=][^:=-][^>]+$',
      \     'regex': '^\s*JJJ\s*[:=][^:=-][^>]+$',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'class',
      \     'pcre_regex': '^\s*\bclass\s+KEYWORD',
      \     'regex': '^\s*\bclass\s+JJJ',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'objc': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\)\s*KEYWORD(:|\b|\s)',
      \     'regex': '\)\s*JJJ(:|\b|\s)',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\b\*?KEYWORD\s*=[^=\n]+',
      \     'regex': '\b\*?JJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(@interface|@protocol|@implementation)\b\s*KEYWORD\b\s*',
      \     'regex': '(@interface|@protocol|@implementation)\b\s*JJJ\b\s*',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'typedef\b\s+(NS_OPTIONS|NS_ENUM)\b\([^,]+?,\s*KEYWORD\b\s*',
      \     'regex': 'typedef\b\s+(NS_OPTIONS|NS_ENUM)\b\([^,]+?,\s*JJJ\b\s*',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'swift': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(let|var)\s*KEYWORD\s*(=|:)[^=:\n]+',
      \     'regex': '(let|var)\s*JJJ\s*(=|:)[^=:\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'func\s+KEYWORD\b\s*(<[^>]*>)?\s*\(',
      \     'regex': 'func\s+JJJ\b\s*(<[^>]*>)?\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(class|struct|protocol|enum)\s+KEYWORD\b\s*?',
      \     'regex': '(class|struct|protocol|enum)\s+JJJ\b\s*?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(typealias)\s+KEYWORD\b\s*?=',
      \     'regex': '(typealias)\s+JJJ\b\s*?=',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'csharp': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \     'regex': '^\s*(?:[\w\[\]]+\s+){1,3}JJJ\s*\(',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n)]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n)]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(class|interface)\s*KEYWORD\b',
      \     'regex': '(class|interface)\s*JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'java': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \     'regex': '^\s*(?:[\w\[\]]+\s+){1,3}JJJ\s*\(',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n)]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n)]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(class|interface)\s*KEYWORD\b',
      \     'regex': '(class|interface)\s*JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'vala': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \     'regex': '^\s*(?:[\w\[\]]+\s+){1,3}JJJ\s*\(',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n)]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n)]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(class|interface)\s*KEYWORD\b',
      \     'regex': '(class|interface)\s*JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'coq': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Variable\s+KEYWORD\b',
      \     'regex': '\s*Variable\s+JJJ\b',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Inductive\s+KEYWORD\b',
      \     'regex': '\s*Inductive\s+JJJ\b',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Lemma\s+KEYWORD\b',
      \     'regex': '\s*Lemma\s+JJJ\b',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Definition\s+KEYWORD\b',
      \     'regex': '\s*Definition\s+JJJ\b',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Hypothesis\s+KEYWORD\b',
      \     'regex': '\s*Hypothesis\s+JJJ\b',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Theorm\s+KEYWORD\b',
      \     'regex': '\s*Theorm\s+JJJ\b',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Fixpoint\s+KEYWORD\b',
      \     'regex': '\s*Fixpoint\s+JJJ\b',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Module\s+KEYWORD\b',
      \     'regex': '\s*Module\s+JJJ\b',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*CoInductive\s+KEYWORD\b',
      \     'regex': '\s*CoInductive\s+JJJ\b',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'python': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'def\s*KEYWORD\b\s*\(',
      \     'regex': 'def\s*JJJ\b\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'class\s*KEYWORD\b\s*\(?',
      \     'regex': 'class\s*JJJ\b\s*\(?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'matlab': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '^\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '^\s*\bJJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*function\s*[^=]+\s*=\s*KEYWORD\b',
      \     'regex': '^\s*function\s*[^=]+\s*=\s*JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '^\s*classdef\s*KEYWORD\b\s*',
      \     'regex': '^\s*classdef\s*JJJ\b\s*',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'nim': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(const|let|var)\s*KEYWORD\*?\s*(=|:)[^=:\n]+',
      \     'regex': '(const|let|var)\s*JJJ\*?\s*(=|:)[^=:\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(proc|func|macro|template)\s*\`?KEYWORD\`?\b\*?\s*\(',
      \     'regex': '(proc|func|macro|template)\s*\`?JJJ\`?\b\*?\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'type\s*KEYWORD\b\*?\s*(\{[^}]+\})?\s*=\s*\w+',
      \     'regex': 'type\s*JJJ\b\*?\s*(\{[^}]+\})?\s*=\s*\w+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'nix': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\b\s*KEYWORD\s*=[^=;]+',
      \     'regex': '\b\s*JJJ\s*=[^=;]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'ruby': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \     'regex': '^\s*((\w+[.])*\w+,\s*)*JJJ(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*JJJ($|[^\w|:])',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(^|\W)define(_singleton|_instance)?_method(\s|[(])\s*:KEYWORD($|[^\w|:])',
      \     'regex': '(^|\W)define(_singleton|_instance)?_method(\s|[(])\s*:JJJ($|[^\w|:])',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])class\s+(\w*::)*JJJ($|[^\w|:])',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])module\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])module\s+(\w*::)*JJJ($|[^\w|:])',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(^|\W)alias(_method)?\W+KEYWORD(\W|$)',
      \     'regex': '(^|\W)alias(_method)?\W+JJJ(\W|$)',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'groovy': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \     'regex': '^\s*((\w+[.])*\w+,\s*)*JJJ(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(^|[^\w.])((private|public)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])((private|public)\s+)?def\s+(\w+(::|[.]))*JJJ($|[^\w|:])',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])class\s+(\w*::)*JJJ($|[^\w|:])',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'crystal': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \     'regex': '^\s*((\w+[.])*\w+,\s*)*JJJ(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*JJJ($|[^\w|:])',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])class\s+(\w*::)*JJJ($|[^\w|:])',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])module\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])module\s+(\w*::)*JJJ($|[^\w|:])',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])struct\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])struct\s+(\w*::)*JJJ($|[^\w|:])',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])alias\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])alias\s+(\w*::)*JJJ($|[^\w|:])',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'scad': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': 'module\s*KEYWORD\s*\(',
      \     'regex': 'module\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'scala': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bval\s*KEYWORD\s*=[^=\n]+',
      \     'regex': '\bval\s*JJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bvar\s*KEYWORD\s*=[^=\n]+',
      \     'regex': '\bvar\s*JJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\btype\s*KEYWORD\s*=[^=\n]+',
      \     'regex': '\btype\s*JJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bdef\s*KEYWORD\s*\(',
      \     'regex': '\bdef\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'class\s*KEYWORD\s*\(?',
      \     'regex': 'class\s*JJJ\s*\(?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'trait\s*KEYWORD\s*\(?',
      \     'regex': 'trait\s*JJJ\s*\(?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'object\s*KEYWORD\s*\(?',
      \     'regex': 'object\s*JJJ\s*\(?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'solidity': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'modifier',
      \     'pcre_regex': 'modifier\s*KEYWORD\s*\(',
      \     'regex': 'modifier\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'event',
      \     'pcre_regex': 'event\s*KEYWORD\s*\(',
      \     'regex': 'event\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'error',
      \     'pcre_regex': 'error\s*KEYWORD\s*\(',
      \     'regex': 'error\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'contract',
      \     'pcre_regex': 'contract\s*KEYWORD\s*(is|\{)',
      \     'regex': 'contract\s*JJJ\s*(is|\{)',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'r': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bKEYWORD\s*=[^=><]',
      \     'regex': '\bJJJ\s*=[^=><]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*<-\s*function\b',
      \     'regex': '\bJJJ\s*<-\s*function\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'perl': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'sub\s*KEYWORD\s*(\{|\()',
      \     'regex': 'sub\s*JJJ\s*(\{|\()',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'KEYWORD\s*=\s*',
      \     'regex': 'JJJ\s*=\s*',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'tcl': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'proc\s+KEYWORD\s*\{',
      \     'regex': 'proc\s+JJJ\s*\{',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'set\s+KEYWORD',
      \     'regex': 'set\s+JJJ',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(variable|global)\s+KEYWORD',
      \     'regex': '(variable|global)\s+JJJ',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'shell': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*',
      \     'regex': 'function\s*JJJ\s*',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'KEYWORD\(\)\s*\{',
      \     'regex': 'JJJ\(\)\s*\{',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bKEYWORD\s*=\s*',
      \     'regex': '\bJJJ\s*=\s*',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'php': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\*\s@method\s+[^ 	]+\s+KEYWORD\(',
      \     'regex': '\*\s@method\s+[^ 	]+\s+JJJ\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(\s|->|\$|::)KEYWORD\s*=\s*',
      \     'regex': '(\s|->|\$|::)JJJ\s*=\s*',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\*\s@property(-read|-write)?\s+([^ 	]+\s+)&?\$KEYWORD(\s+|$)',
      \     'regex': '\*\s@property(-read|-write)?\s+([^ 	]+\s+)&?\$JJJ(\s+|$)',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'trait',
      \     'pcre_regex': 'trait\s*KEYWORD\s*\{',
      \     'regex': 'trait\s*JJJ\s*\{',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'interface',
      \     'pcre_regex': 'interface\s*KEYWORD\s*\{',
      \     'regex': 'interface\s*JJJ\s*\{',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'class',
      \     'pcre_regex': 'class\s*KEYWORD\s*(extends|implements|\{)',
      \     'regex': 'class\s*JJJ\s*(extends|implements|\{)',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'dart': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'regex': '\bJJJ\s*\([^()]*\)\s*[{]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s*[\(\{]',
      \     'regex': 'class\s*JJJ\s*[\(\{]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'faust': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD(\(.+\))*\s*=',
      \     'regex': '\bJJJ(\(.+\))*\s*=',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'fennel': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\((local|var)\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\((local|var)\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(fn\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(fn\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(macro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(macro\s+JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'fortran': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\b(function|subroutine|FUNCTION|SUBROUTINE)\s+KEYWORD\b\s*\(',
      \     'regex': '\b(function|subroutine|FUNCTION|SUBROUTINE)\s+JJJ\b\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*(interface|INTERFACE)\s+KEYWORD\b',
      \     'regex': '^\s*(interface|INTERFACE)\s+JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '^\s*(module|MODULE)\s+KEYWORD\s*',
      \     'regex': '^\s*(module|MODULE)\s+JJJ\s*',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'go': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*:=\s*',
      \     'regex': '\s*\bJJJ\s*:=\s*',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'func\s+\([^\)]*\)\s+KEYWORD\s*\(',
      \     'regex': 'func\s+\([^\)]*\)\s+JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'func\s+KEYWORD\s*\(',
      \     'regex': 'func\s+JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'type\s+KEYWORD\s+struct\s+\{',
      \     'regex': 'type\s+JJJ\s+struct\s+\{',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'javascript': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(service|factory)\([''\"]KEYWORD[''\"]',
      \     'regex': '(service|factory)\([''\"]JJJ[''\"]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \     'regex': '\bJJJ\s*[=:]\s*\([^\)]*\)\s+=>',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'regex': '\bJJJ\s*\([^()]*\)\s*[{]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s*[\(\{]',
      \     'regex': 'class\s*JJJ\s*[\(\{]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s+extends',
      \     'regex': 'class\s*JJJ\s+extends',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \     'regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*:\s*function\s*\(',
      \     'regex': '\bJJJ\s*:\s*function\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*=\s*function\s*\(',
      \     'regex': '\bJJJ\s*=\s*function\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'hcl': [
      \   {
      \     'type': 'block',
      \     'pcre_regex': '(variable|output|module)\s*\"KEYWORD\"\s*\{',
      \     'regex': '(variable|output|module)\s*\"JJJ\"\s*\{',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'block',
      \     'pcre_regex': '(data|resource)\s*\"\w+\"\s*\"KEYWORD\"\s*\{',
      \     'regex': '(data|resource)\s*\"\w+\"\s*\"JJJ\"\s*\{',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'typescript': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(service|factory)\([''\"]KEYWORD[''\"]',
      \     'regex': '(service|factory)\([''\"]JJJ[''\"]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \     'regex': '\bJJJ\s*[=:]\s*\([^\)]*\)\s+=>',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'regex': '\bJJJ\s*\([^()]*\)\s*[{]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s*[\(\{]',
      \     'regex': 'class\s*JJJ\s*[\(\{]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s+extends',
      \     'regex': 'class\s*JJJ\s+extends',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*:\s*function\s*\(',
      \     'regex': '\bJJJ\s*:\s*function\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*=\s*function\s*\(',
      \     'regex': '\bJJJ\s*=\s*function\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \     'regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'julia': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(@noinline|@inline)?\s*function\s*KEYWORD(\{[^\}]*\})?\(',
      \     'regex': '(@noinline|@inline)?\s*function\s*JJJ(\{[^\}]*\})?\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(@noinline|@inline)?KEYWORD(\{[^\}]*\})?\([^\)]*\)s*=',
      \     'regex': '(@noinline|@inline)?JJJ(\{[^\}]*\})?\([^\)]*\)s*=',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'macro\s*KEYWORD\(',
      \     'regex': 'macro\s*JJJ\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'const\s+KEYWORD\b',
      \     'regex': 'const\s+JJJ\b',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(mutable)?\s*struct\s*KEYWORD',
      \     'regex': '(mutable)?\s*struct\s*JJJ',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(type|immutable|abstract)\s*KEYWORD',
      \     'regex': '(type|immutable|abstract)\s*JJJ',
      \     'supports': ['ag', 'rg'],
      \   },
      \ ],
      \ 'haskell': [
      \   {
      \     'type': 'module',
      \     'pcre_regex': '^module\s+KEYWORD\s+',
      \     'regex': '^module\s+JJJ\s+',
      \     'supports': ['ag'],
      \   },
      \   {
      \     'type': 'top level function',
      \     'pcre_regex': '^\bKEYWORD(?!(\s+::))\s+((.|\s)*?)=\s+',
      \     'regex': '^\bJJJ(?!(\s+::))\s+((.|\s)*?)=\s+',
      \     'supports': ['ag'],
      \   },
      \   {
      \     'type': 'type-like',
      \     'pcre_regex': '^\s*((data(\s+family)?)|(newtype)|(type(\s+family)?))\s+KEYWORD\s+',
      \     'regex': '^\s*((data(\s+family)?)|(newtype)|(type(\s+family)?))\s+JJJ\s+',
      \     'supports': ['ag'],
      \   },
      \   {
      \     'type': '(data)type constructor 1',
      \     'pcre_regex': '(data|newtype)\s{1,3}(?!KEYWORD\s+)([^=]{1,40})=((\s{0,3}KEYWORD\s+)|([^=]{0,500}?((?<!(-- ))\|\s{0,3}KEYWORD\s+)))',
      \     'regex': '(data|newtype)\s{1,3}(?!JJJ\s+)([^=]{1,40})=((\s{0,3}JJJ\s+)|([^=]{0,500}?((?<!(-- ))\|\s{0,3}JJJ\s+)))',
      \     'supports': ['ag'],
      \   },
      \   {
      \     'type': 'data/newtype record field',
      \     'pcre_regex': '(data|newtype)([^=]*)=[^=]*?({([^=}]*?)(\bKEYWORD)\s+::[^=}]+})',
      \     'regex': '(data|newtype)([^=]*)=[^=]*?({([^=}]*?)(\bJJJ)\s+::[^=}]+})',
      \     'supports': ['ag'],
      \   },
      \   {
      \     'type': 'typeclass',
      \     'pcre_regex': '^class\s+(.+=>\s*)?KEYWORD\s+',
      \     'regex': '^class\s+(.+=>\s*)?JJJ\s+',
      \     'supports': ['ag'],
      \   },
      \ ],
      \ 'ocaml': [
      \   {
      \     'type': 'type',
      \     'pcre_regex': '^\s*(and|type)\s+.*\bKEYWORD\b',
      \     'regex': '^\s*(and|type)\s+.*\bJJJ\b',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'let\s+KEYWORD\b',
      \     'regex': 'let\s+JJJ\b',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'let\s+rec\s+KEYWORD\b',
      \     'regex': 'let\s+rec\s+JJJ\b',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*val\s*\bKEYWORD\b\s*',
      \     'regex': '\s*val\s*\bJJJ\b\s*',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': '^\s*module\s*\bKEYWORD\b',
      \     'regex': '^\s*module\s*\bJJJ\b',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': '^\s*module\s*type\s*\bKEYWORD\b',
      \     'regex': '^\s*module\s*type\s*\bJJJ\b',
      \     'supports': ['ag', 'rg'],
      \   },
      \ ],
      \ 'lua': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \     'regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*.+[.:]KEYWORD\s*\(',
      \     'regex': 'function\s*.+[.:]JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*=\s*function\s*\(',
      \     'regex': '\bJJJ\s*=\s*function\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\b.+\.KEYWORD\s*=\s*function\s*\(',
      \     'regex': '\b.+\.JJJ\s*=\s*function\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'rust': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\blet\s+(\([^=\n]*)?(muts+)?KEYWORD([^=\n]*\))?(:\s*[^=\n]+)?\s*=\s*[^=\n]+',
      \     'regex': '\blet\s+(\([^=\n]*)?(muts+)?JJJ([^=\n]*\))?(:\s*[^=\n]+)?\s*=\s*[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bconst\s+KEYWORD:\s*[^=\n]+\s*=[^=\n]+',
      \     'regex': '\bconst\s+JJJ:\s*[^=\n]+\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bstatic\s+(mut\s+)?KEYWORD:\s*[^=\n]+\s*=[^=\n]+',
      \     'regex': '\bstatic\s+(mut\s+)?JJJ:\s*[^=\n]+\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bfn\s+.+\s*\((.+,\s+)?KEYWORD:\s*[^=\n]+\s*(,\s*.+)*\)',
      \     'regex': '\bfn\s+.+\s*\((.+,\s+)?JJJ:\s*[^=\n]+\s*(,\s*.+)*\)',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(if|while)\s+let\s+([^=\n]+)?(mut\s+)?KEYWORD([^=\n\(]+)?\s*=\s*[^=\n]+',
      \     'regex': '(if|while)\s+let\s+([^=\n]+)?(mut\s+)?JJJ([^=\n\(]+)?\s*=\s*[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'struct\s+[^\n{]+[{][^}]*(\s*KEYWORD\s*:\s*[^\n},]+)[^}]*}',
      \     'regex': 'struct\s+[^\n{]+[{][^}]*(\s*JJJ\s*:\s*[^\n},]+)[^}]*}',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'enum\s+[^\n{]+\s*[{][^}]*\bKEYWORD\b[^}]*}',
      \     'regex': 'enum\s+[^\n{]+\s*[{][^}]*\bJJJ\b[^}]*}',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bfn\s+KEYWORD\s*\(',
      \     'regex': '\bfn\s+JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bmacro_rules!\s+KEYWORD',
      \     'regex': '\bmacro_rules!\s+JJJ',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'struct\s+KEYWORD\s*[{\(]?',
      \     'regex': 'struct\s+JJJ\s*[{\(]?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'trait\s+KEYWORD\s*[{]?',
      \     'regex': 'trait\s+JJJ\s*[{]?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\btype\s+KEYWORD([^=\n]+)?\s*=[^=\n]+;',
      \     'regex': '\btype\s+JJJ([^=\n]+)?\s*=[^=\n]+;',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'impl\s+((\w+::)*\w+\s+for\s+)?(\w+::)*KEYWORD\s+[{]?',
      \     'regex': 'impl\s+((\w+::)*\w+\s+for\s+)?(\w+::)*JJJ\s+[{]?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'mod\s+KEYWORD\s*[{]?',
      \     'regex': 'mod\s+JJJ\s*[{]?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'elixir': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bdef(p)?\s+KEYWORD\s*[ ,\(]',
      \     'regex': '\bdef(p)?\s+JJJ\s*[ ,\(]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*KEYWORD\s*=[^=\n]+',
      \     'regex': '\s*JJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': 'defmodule\s+(\w+\.)*KEYWORD\s+',
      \     'regex': 'defmodule\s+(\w+\.)*JJJ\s+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': 'defprotocol\s+(\w+\.)*KEYWORD\s+',
      \     'regex': 'defprotocol\s+(\w+\.)*JJJ\s+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'erlang': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^KEYWORD\b\s*\(',
      \     'regex': '^JJJ\b\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*KEYWORD\s*=[^:=\n]+',
      \     'regex': '\s*JJJ\s*=[^:=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': '^-module\(KEYWORD\)',
      \     'regex': '^-module\(JJJ\)',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'scss': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '@mixin\sKEYWORD\b\s*\(',
      \     'regex': '@mixin\sJJJ\b\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '@function\sKEYWORD\b\s*\(',
      \     'regex': '@function\sJJJ\b\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'KEYWORD\s*:\s*',
      \     'regex': 'JJJ\s*:\s*',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'sml': [
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\s*(data)?type\s+.*\bKEYWORD\b',
      \     'regex': '\s*(data)?type\s+.*\bJJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*val\s+\bKEYWORD\b',
      \     'regex': '\s*val\s+\bJJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*fun\s+\bKEYWORD\b.*\s*=',
      \     'regex': '\s*fun\s+\bJJJ\b.*\s*=',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': '\s*(structure|signature|functor)\s+\bKEYWORD\b',
      \     'regex': '\s*(structure|signature|functor)\s+\bJJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'sql': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(CREATE|create)\s+(.+?\s+)?(FUNCTION|function|PROCEDURE|procedure)\s+KEYWORD\s*\(',
      \     'regex': '(CREATE|create)\s+(.+?\s+)?(FUNCTION|function|PROCEDURE|procedure)\s+JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'table',
      \     'pcre_regex': '(CREATE|create)\s+(.+?\s+)?(TABLE|table)(\s+(IF NOT EXISTS|if not exists))?\s+KEYWORD\b',
      \     'regex': '(CREATE|create)\s+(.+?\s+)?(TABLE|table)(\s+(IF NOT EXISTS|if not exists))?\s+JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'view',
      \     'pcre_regex': '(CREATE|create)\s+(.+?\s+)?(VIEW|view)\s+KEYWORD\b',
      \     'regex': '(CREATE|create)\s+(.+?\s+)?(VIEW|view)\s+JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(CREATE|create)\s+(.+?\s+)?(TYPE|type)\s+KEYWORD\b',
      \     'regex': '(CREATE|create)\s+(.+?\s+)?(TYPE|type)\s+JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'systemverilog': [
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\s*class\s+\bKEYWORD\b',
      \     'regex': '\s*class\s+\bJJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\s*task\s+\bKEYWORD\b',
      \     'regex': '\s*task\s+\bJJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\s*\bKEYWORD\b\s*=',
      \     'regex': '\s*\bJJJ\b\s*=',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s[^\s]+\s*\bKEYWORD\b',
      \     'regex': 'function\s[^\s]+\s*\bJJJ\b',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*[^\s]*\s*[^\s]+\s+\bKEYWORD\b',
      \     'regex': '^\s*[^\s]*\s*[^\s]+\s+\bJJJ\b',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'vhdl': [
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\s*type\s+\bKEYWORD\b',
      \     'regex': '\s*type\s+\bJJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\s*constant\s+\bKEYWORD\b',
      \     'regex': '\s*constant\s+\bJJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*\"?KEYWORD\"?\s*\(',
      \     'regex': 'function\s*\"?JJJ\"?\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'tex': [
      \   {
      \     'type': 'command',
      \     'pcre_regex': '\\.*newcommand\*?\s*\{\s*(\\)KEYWORD\s*}',
      \     'regex': '\\.*newcommand\*?\s*\{\s*(\\)JJJ\s*}',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'command',
      \     'pcre_regex': '\\.*newcommand\*?\s*(\\)KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\\.*newcommand\*?\s*(\\)JJJ\j',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'length',
      \     'pcre_regex': '\\(s)etlength\s*\{\s*(\\)KEYWORD\s*}',
      \     'regex': '\\(s)etlength\s*\{\s*(\\)JJJ\s*}',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'counter',
      \     'pcre_regex': '\\newcounter\{\s*KEYWORD\s*}',
      \     'regex': '\\newcounter\{\s*JJJ\s*}',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'environment',
      \     'pcre_regex': '\\.*newenvironment\s*\{\s*KEYWORD\s*}',
      \     'regex': '\\.*newenvironment\s*\{\s*JJJ\s*}',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'pascal': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bfunction\s+KEYWORD\b',
      \     'regex': '\bfunction\s+JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bprocedure\s+KEYWORD\b',
      \     'regex': '\bprocedure\s+JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'fsharp': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'let\s+KEYWORD\b.*\=',
      \     'regex': 'let\s+JJJ\b.*\=',
      \     'supports': ['ag', 'grep', 'git-grep'],
      \   },
      \   {
      \     'type': 'interface',
      \     'pcre_regex': 'member(\b.+\.|\s+)KEYWORD\b.*\=',
      \     'regex': 'member(\b.+\.|\s+)JJJ\b.*\=',
      \     'supports': ['ag', 'grep', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'type\s+KEYWORD\b.*\=',
      \     'regex': 'type\s+JJJ\b.*\=',
      \     'supports': ['ag', 'grep', 'git-grep'],
      \   },
      \ ],
      \ 'kotlin': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'fun\s*(<[^>]*>)?\s*KEYWORD\s*\(',
      \     'regex': 'fun\s*(<[^>]*>)?\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(val|var)\s*KEYWORD\b',
      \     'regex': '(val|var)\s*JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(class|interface)\s*KEYWORD\b',
      \     'regex': '(class|interface)\s*JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'zig': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'fn\s+KEYWORD\b',
      \     'regex': 'fn\s+JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(var|const)\s+KEYWORD\b',
      \     'regex': '(var|const)\s+JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'protobuf': [
      \   {
      \     'type': 'message',
      \     'pcre_regex': 'message\s+KEYWORD\s*\{',
      \     'regex': 'message\s+JJJ\s*\{',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'enum',
      \     'pcre_regex': 'enum\s+KEYWORD\s*\{',
      \     'regex': 'enum\s+JJJ\s*\{',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'apex': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \     'regex': '^\s*(?:[\w\[\]]+\s+){1,3}JJJ\s*\(',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n)]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n)]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(class|interface)\s*KEYWORD\b',
      \     'regex': '(class|interface)\s*JJJ\b',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'c': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \     'regex': '\bJJJ(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+JJJ(\)|\s)*\(',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \     'regex': '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+JJJ\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+JJJ\b',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \     'regex': '\b(class|struct|enum|union)\b\s*JJJ\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*JJJ\b\s*;',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'cpp': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \     'regex': '\bJJJ(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+JJJ(\)|\s)*\(',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \     'regex': '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+JJJ\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+JJJ\b',
      \     'supports': ['ag', 'rg'],
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \     'regex': '\b(class|struct|enum|union)\b\s*JJJ\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*JJJ\b\s*;',
      \     'supports': ['ag', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'javascriptreact': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(service|factory)\([''\"]KEYWORD[''\"]',
      \     'regex': '(service|factory)\([''\"]JJJ[''\"]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \     'regex': '\bJJJ\s*[=:]\s*\([^\)]*\)\s+=>',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'regex': '\bJJJ\s*\([^()]*\)\s*[{]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s*[\(\{]',
      \     'regex': 'class\s*JJJ\s*[\(\{]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s+extends',
      \     'regex': 'class\s*JJJ\s+extends',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \     'regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*:\s*function\s*\(',
      \     'regex': '\bJJJ\s*:\s*function\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*=\s*function\s*\(',
      \     'regex': '\bJJJ\s*=\s*function\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ 'typescriptreact': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(service|factory)\([''\"]KEYWORD[''\"]',
      \     'regex': '(service|factory)\([''\"]JJJ[''\"]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \     'regex': '\bJJJ\s*[=:]\s*\([^\)]*\)\s+=>',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'regex': '\bJJJ\s*\([^()]*\)\s*[{]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s*[\(\{]',
      \     'regex': 'class\s*JJJ\s*[\(\{]',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s+extends',
      \     'regex': 'class\s*JJJ\s+extends',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*:\s*function\s*\(',
      \     'regex': '\bJJJ\s*:\s*function\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*=\s*function\s*\(',
      \     'regex': '\bJJJ\s*=\s*function\s*\(',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \     'regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
      \     'supports': ['ag', 'grep', 'rg', 'git-grep'],
      \   },
      \ ],
      \ }

function! zero#dumb_jump#get(...) abort
  let ft = get(a:, 1, &filetype !=# '' ? &filetype : &buftype)
  if has_key(s:definitions, ft)
    return s:definitions[ft]
  endif
  return []
endfunction

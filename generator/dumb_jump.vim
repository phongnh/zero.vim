" NOTES:
" - All language regular expressions are ported from https://github.com/jacktasia/dumb-jump/blob/master/dumb-jump.el

let s:definitions = {
      \ 'elisp': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\((defun|cl-defun)\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\((defun|cl-defun)\s+JJJ\j',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(defmacro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(defmacro\s+JJJ\j',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(defvar\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(defvar\b\s*JJJ\j',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(defcustom\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(defcustom\b\s*JJJ\j',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(setq\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(setq\b\s*JJJ\j',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(KEYWORD\s+',
      \     'regex': '\(JJJ\s+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\((defun|cl-defun)\s*.+\(?\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \     'regex': '\((defun|cl-defun)\s*.+\(?\s*JJJ\j\s*\)?',
      \   },
      \ ],
      \ 'commonlisp': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(defun\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(defun\s+JJJ\j',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(defparameter\b\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(defparameter\b\s*JJJ\j',
      \   },
      \ ],
      \ 'racket': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(define\s+\(\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(define\s+\(\s*JJJ\j',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(define\s+KEYWORD\s*\(\s*lambda',
      \     'regex': '\(define\s+JJJ\s*\(\s*lambda',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(let\s+KEYWORD\s*(\(|\[)*',
      \     'regex': '\(let\s+JJJ\s*(\(|\[)*',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(define\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(define\s+JJJ\j',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(\(|\[)\s*KEYWORD\s+',
      \     'regex': '(\(|\[)\s*JJJ\s+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(lambda\s+\(?[^()]*\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \     'regex': '\(lambda\s+\(?[^()]*\s*JJJ\j\s*\)?',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(define\s+\([^()]+\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \     'regex': '\(define\s+\([^()]+\s*JJJ\j\s*\)?',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\(struct\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(struct\s+JJJ\j',
      \   },
      \ ],
      \ 'scheme': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(define\s+\(\s*KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(define\s+\(\s*JJJ\j',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(define\s+KEYWORD\s*\(\s*lambda',
      \     'regex': '\(define\s+JJJ\s*\(\s*lambda',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(let\s+KEYWORD\s*(\(|\[)*',
      \     'regex': '\(let\s+JJJ\s*(\(|\[)*',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(define\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(define\s+JJJ\j',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(\(|\[)\s*KEYWORD\s+',
      \     'regex': '(\(|\[)\s*JJJ\s+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(lambda\s+\(?[^()]*\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \     'regex': '\(lambda\s+\(?[^()]*\s*JJJ\j\s*\)?',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(define\s+\([^()]+\s*KEYWORD($|[^a-zA-Z0-9\?\*-])\s*\)?',
      \     'regex': '\(define\s+\([^()]+\s*JJJ\j\s*\)?',
      \   },
      \ ],
      \ 'janet': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\((de)?f\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\((de)?f\s+JJJ\j',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(var\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(var\s+JJJ\j',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\((de)fn-?\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\((de)fn-?\s+JJJ\j',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(defmacro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(defmacro\s+JJJ\j',
      \   },
      \ ],
      \ 'c++': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \     'regex': '\bJJJ(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+JJJ(\)|\s)*\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \     'regex': '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+JJJ\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+JJJ\b',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \     'regex': '\b(class|struct|enum|union)\b\s*JJJ\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*JJJ\b\s*;',
      \   },
      \ ],
      \ 'clojure': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\(def.* KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(def.* JJJ\j',
      \   },
      \ ],
      \ 'coffeescript': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*KEYWORD\s*[=:].*[-=]>',
      \     'regex': '^\s*JJJ\s*[=:].*[-=]>',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '^\s*KEYWORD\s*[:=][^:=-][^>]+$',
      \     'regex': '^\s*JJJ\s*[:=][^:=-][^>]+$',
      \   },
      \   {
      \     'type': 'class',
      \     'pcre_regex': '^\s*\bclass\s+KEYWORD',
      \     'regex': '^\s*\bclass\s+JJJ',
      \   },
      \ ],
      \ 'objc': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\)\s*KEYWORD(:|\b|\s)',
      \     'regex': '\)\s*JJJ(:|\b|\s)',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\b\*?KEYWORD\s*=[^=\n]+',
      \     'regex': '\b\*?JJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(@interface|@protocol|@implementation)\b\s*KEYWORD\b\s*',
      \     'regex': '(@interface|@protocol|@implementation)\b\s*JJJ\b\s*',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'typedef\b\s+(NS_OPTIONS|NS_ENUM)\b\([^,]+?,\s*KEYWORD\b\s*',
      \     'regex': 'typedef\b\s+(NS_OPTIONS|NS_ENUM)\b\([^,]+?,\s*JJJ\b\s*',
      \   },
      \ ],
      \ 'swift': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(let|var)\s*KEYWORD\s*(=|:)[^=:\n]+',
      \     'regex': '(let|var)\s*JJJ\s*(=|:)[^=:\n]+',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'func\s+KEYWORD\b\s*(<[^>]*>)?\s*\(',
      \     'regex': 'func\s+JJJ\b\s*(<[^>]*>)?\s*\(',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(class|struct|protocol|enum)\s+KEYWORD\b\s*?',
      \     'regex': '(class|struct|protocol|enum)\s+JJJ\b\s*?',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(typealias)\s+KEYWORD\b\s*?=',
      \     'regex': '(typealias)\s+JJJ\b\s*?=',
      \   },
      \ ],
      \ 'csharp': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \     'regex': '^\s*(?:[\w\[\]]+\s+){1,3}JJJ\s*\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n)]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n)]+',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(class|interface)\s*KEYWORD\b',
      \     'regex': '(class|interface)\s*JJJ\b',
      \   },
      \ ],
      \ 'java': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \     'regex': '^\s*(?:[\w\[\]]+\s+){1,3}JJJ\s*\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n)]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n)]+',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(class|interface)\s*KEYWORD\b',
      \     'regex': '(class|interface)\s*JJJ\b',
      \   },
      \ ],
      \ 'vala': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \     'regex': '^\s*(?:[\w\[\]]+\s+){1,3}JJJ\s*\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n)]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n)]+',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(class|interface)\s*KEYWORD\b',
      \     'regex': '(class|interface)\s*JJJ\b',
      \   },
      \ ],
      \ 'coq': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Variable\s+KEYWORD\b',
      \     'regex': '\s*Variable\s+JJJ\b',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Inductive\s+KEYWORD\b',
      \     'regex': '\s*Inductive\s+JJJ\b',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Lemma\s+KEYWORD\b',
      \     'regex': '\s*Lemma\s+JJJ\b',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Definition\s+KEYWORD\b',
      \     'regex': '\s*Definition\s+JJJ\b',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Hypothesis\s+KEYWORD\b',
      \     'regex': '\s*Hypothesis\s+JJJ\b',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Theorm\s+KEYWORD\b',
      \     'regex': '\s*Theorm\s+JJJ\b',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Fixpoint\s+KEYWORD\b',
      \     'regex': '\s*Fixpoint\s+JJJ\b',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*Module\s+KEYWORD\b',
      \     'regex': '\s*Module\s+JJJ\b',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*CoInductive\s+KEYWORD\b',
      \     'regex': '\s*CoInductive\s+JJJ\b',
      \   },
      \ ],
      \ 'python': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'def\s*KEYWORD\b\s*\(',
      \     'regex': 'def\s*JJJ\b\s*\(',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'class\s*KEYWORD\b\s*\(?',
      \     'regex': 'class\s*JJJ\b\s*\(?',
      \   },
      \ ],
      \ 'matlab': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '^\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '^\s*\bJJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*function\s*[^=]+\s*=\s*KEYWORD\b',
      \     'regex': '^\s*function\s*[^=]+\s*=\s*JJJ\b',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '^\s*classdef\s*KEYWORD\b\s*',
      \     'regex': '^\s*classdef\s*JJJ\b\s*',
      \   },
      \ ],
      \ 'nim': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(const|let|var)\s*KEYWORD\*?\s*(=|:)[^=:\n]+',
      \     'regex': '(const|let|var)\s*JJJ\*?\s*(=|:)[^=:\n]+',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(proc|func|macro|template)\s*\`?KEYWORD\`?\b\*?\s*\(',
      \     'regex': '(proc|func|macro|template)\s*\`?JJJ\`?\b\*?\s*\(',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'type\s*KEYWORD\b\*?\s*(\{[^}]+\})?\s*=\s*\w+',
      \     'regex': 'type\s*JJJ\b\*?\s*(\{[^}]+\})?\s*=\s*\w+',
      \   },
      \ ],
      \ 'nix': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\b\s*KEYWORD\s*=[^=;]+',
      \     'regex': '\b\s*JJJ\s*=[^=;]+',
      \   },
      \ ],
      \ 'ruby': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \     'regex': '^\s*((\w+[.])*\w+,\s*)*JJJ(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*JJJ($|[^\w|:])',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(^|\W)define(_singleton|_instance)?_method(\s|[(])\s*:KEYWORD($|[^\w|:])',
      \     'regex': '(^|\W)define(_singleton|_instance)?_method(\s|[(])\s*:JJJ($|[^\w|:])',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])class\s+(\w*::)*JJJ($|[^\w|:])',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])module\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])module\s+(\w*::)*JJJ($|[^\w|:])',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(^|\W)alias(_method)?\W+KEYWORD(\W|$)',
      \     'regex': '(^|\W)alias(_method)?\W+JJJ(\W|$)',
      \   },
      \ ],
      \ 'groovy': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \     'regex': '^\s*((\w+[.])*\w+,\s*)*JJJ(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(^|[^\w.])((private|public)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])((private|public)\s+)?def\s+(\w+(::|[.]))*JJJ($|[^\w|:])',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])class\s+(\w*::)*JJJ($|[^\w|:])',
      \   },
      \ ],
      \ 'crystal': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '^\s*((\w+[.])*\w+,\s*)*KEYWORD(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \     'regex': '^\s*((\w+[.])*\w+,\s*)*JJJ(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*JJJ($|[^\w|:])',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])class\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])class\s+(\w*::)*JJJ($|[^\w|:])',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])module\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])module\s+(\w*::)*JJJ($|[^\w|:])',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])struct\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])struct\s+(\w*::)*JJJ($|[^\w|:])',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(^|[^\w.])alias\s+(\w*::)*KEYWORD($|[^\w|:])',
      \     'regex': '(^|[^\w.])alias\s+(\w*::)*JJJ($|[^\w|:])',
      \   },
      \ ],
      \ 'scad': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': 'module\s*KEYWORD\s*\(',
      \     'regex': 'module\s*JJJ\s*\(',
      \   },
      \ ],
      \ 'scala': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bval\s*KEYWORD\s*=[^=\n]+',
      \     'regex': '\bval\s*JJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bvar\s*KEYWORD\s*=[^=\n]+',
      \     'regex': '\bvar\s*JJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\btype\s*KEYWORD\s*=[^=\n]+',
      \     'regex': '\btype\s*JJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bdef\s*KEYWORD\s*\(',
      \     'regex': '\bdef\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'class\s*KEYWORD\s*\(?',
      \     'regex': 'class\s*JJJ\s*\(?',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'trait\s*KEYWORD\s*\(?',
      \     'regex': 'trait\s*JJJ\s*\(?',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'object\s*KEYWORD\s*\(?',
      \     'regex': 'object\s*JJJ\s*\(?',
      \   },
      \ ],
      \ 'solidity': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'modifier',
      \     'pcre_regex': 'modifier\s*KEYWORD\s*\(',
      \     'regex': 'modifier\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'event',
      \     'pcre_regex': 'event\s*KEYWORD\s*\(',
      \     'regex': 'event\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'error',
      \     'pcre_regex': 'error\s*KEYWORD\s*\(',
      \     'regex': 'error\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'contract',
      \     'pcre_regex': 'contract\s*KEYWORD\s*(is|\{)',
      \     'regex': 'contract\s*JJJ\s*(is|\{)',
      \   },
      \ ],
      \ 'r': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bKEYWORD\s*=[^=><]',
      \     'regex': '\bJJJ\s*=[^=><]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*<-\s*function\b',
      \     'regex': '\bJJJ\s*<-\s*function\b',
      \   },
      \ ],
      \ 'perl': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'sub\s*KEYWORD\s*(\{|\()',
      \     'regex': 'sub\s*JJJ\s*(\{|\()',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'KEYWORD\s*=\s*',
      \     'regex': 'JJJ\s*=\s*',
      \   },
      \ ],
      \ 'tcl': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'proc\s+KEYWORD\s*\{',
      \     'regex': 'proc\s+JJJ\s*\{',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'set\s+KEYWORD',
      \     'regex': 'set\s+JJJ',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(variable|global)\s+KEYWORD',
      \     'regex': '(variable|global)\s+JJJ',
      \   },
      \ ],
      \ 'shell': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*',
      \     'regex': 'function\s*JJJ\s*',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'KEYWORD\(\)\s*\{',
      \     'regex': 'JJJ\(\)\s*\{',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bKEYWORD\s*=\s*',
      \     'regex': '\bJJJ\s*=\s*',
      \   },
      \ ],
      \ 'php': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\*\s@method\s+[^ 	]+\s+KEYWORD\(',
      \     'regex': '\*\s@method\s+[^ 	]+\s+JJJ\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(\s|->|\$|::)KEYWORD\s*=\s*',
      \     'regex': '(\s|->|\$|::)JJJ\s*=\s*',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\*\s@property(-read|-write)?\s+([^ 	]+\s+)&?\$KEYWORD(\s+|$)',
      \     'regex': '\*\s@property(-read|-write)?\s+([^ 	]+\s+)&?\$JJJ(\s+|$)',
      \   },
      \   {
      \     'type': 'trait',
      \     'pcre_regex': 'trait\s*KEYWORD\s*\{',
      \     'regex': 'trait\s*JJJ\s*\{',
      \   },
      \   {
      \     'type': 'interface',
      \     'pcre_regex': 'interface\s*KEYWORD\s*\{',
      \     'regex': 'interface\s*JJJ\s*\{',
      \   },
      \   {
      \     'type': 'class',
      \     'pcre_regex': 'class\s*KEYWORD\s*(extends|implements|\{)',
      \     'regex': 'class\s*JJJ\s*(extends|implements|\{)',
      \   },
      \ ],
      \ 'dart': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'regex': '\bJJJ\s*\([^()]*\)\s*[{]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s*[\(\{]',
      \     'regex': 'class\s*JJJ\s*[\(\{]',
      \   },
      \ ],
      \ 'faust': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD(\(.+\))*\s*=',
      \     'regex': '\bJJJ(\(.+\))*\s*=',
      \   },
      \ ],
      \ 'fennel': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\((local|var)\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\((local|var)\s+JJJ\j',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(fn\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(fn\s+JJJ\j',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\(macro\s+KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\(macro\s+JJJ\j',
      \   },
      \ ],
      \ 'fortran': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\b(function|subroutine|FUNCTION|SUBROUTINE)\s+KEYWORD\b\s*\(',
      \     'regex': '\b(function|subroutine|FUNCTION|SUBROUTINE)\s+JJJ\b\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*(interface|INTERFACE)\s+KEYWORD\b',
      \     'regex': '^\s*(interface|INTERFACE)\s+JJJ\b',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '^\s*(module|MODULE)\s+KEYWORD\s*',
      \     'regex': '^\s*(module|MODULE)\s+JJJ\s*',
      \   },
      \ ],
      \ 'go': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*:=\s*',
      \     'regex': '\s*\bJJJ\s*:=\s*',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'func\s+\([^\)]*\)\s+KEYWORD\s*\(',
      \     'regex': 'func\s+\([^\)]*\)\s+JJJ\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'func\s+KEYWORD\s*\(',
      \     'regex': 'func\s+JJJ\s*\(',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'type\s+KEYWORD\s+struct\s+\{',
      \     'regex': 'type\s+JJJ\s+struct\s+\{',
      \   },
      \ ],
      \ 'javascript': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(service|factory)\([''\"]KEYWORD[''\"]',
      \     'regex': '(service|factory)\([''\"]JJJ[''\"]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \     'regex': '\bJJJ\s*[=:]\s*\([^\)]*\)\s+=>',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'regex': '\bJJJ\s*\([^()]*\)\s*[{]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s*[\(\{]',
      \     'regex': 'class\s*JJJ\s*[\(\{]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s+extends',
      \     'regex': 'class\s*JJJ\s+extends',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \     'regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*:\s*function\s*\(',
      \     'regex': '\bJJJ\s*:\s*function\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*=\s*function\s*\(',
      \     'regex': '\bJJJ\s*=\s*function\s*\(',
      \   },
      \ ],
      \ 'hcl': [
      \   {
      \     'type': 'block',
      \     'pcre_regex': '(variable|output|module)\s*\"KEYWORD\"\s*\{',
      \     'regex': '(variable|output|module)\s*\"JJJ\"\s*\{',
      \   },
      \   {
      \     'type': 'block',
      \     'pcre_regex': '(data|resource)\s*\"\w+\"\s*\"KEYWORD\"\s*\{',
      \     'regex': '(data|resource)\s*\"\w+\"\s*\"JJJ\"\s*\{',
      \   },
      \ ],
      \ 'typescript': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(service|factory)\([''\"]KEYWORD[''\"]',
      \     'regex': '(service|factory)\([''\"]JJJ[''\"]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \     'regex': '\bJJJ\s*[=:]\s*\([^\)]*\)\s+=>',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'regex': '\bJJJ\s*\([^()]*\)\s*[{]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s*[\(\{]',
      \     'regex': 'class\s*JJJ\s*[\(\{]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s+extends',
      \     'regex': 'class\s*JJJ\s+extends',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*:\s*function\s*\(',
      \     'regex': '\bJJJ\s*:\s*function\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*=\s*function\s*\(',
      \     'regex': '\bJJJ\s*=\s*function\s*\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \     'regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
      \   },
      \ ],
      \ 'julia': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(@noinline|@inline)?\s*function\s*KEYWORD(\{[^\}]*\})?\(',
      \     'regex': '(@noinline|@inline)?\s*function\s*JJJ(\{[^\}]*\})?\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(@noinline|@inline)?KEYWORD(\{[^\}]*\})?\([^\)]*\)s*=',
      \     'regex': '(@noinline|@inline)?JJJ(\{[^\}]*\})?\([^\)]*\)s*=',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'macro\s*KEYWORD\(',
      \     'regex': 'macro\s*JJJ\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'const\s+KEYWORD\b',
      \     'regex': 'const\s+JJJ\b',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(mutable)?\s*struct\s*KEYWORD',
      \     'regex': '(mutable)?\s*struct\s*JJJ',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(type|immutable|abstract)\s*KEYWORD',
      \     'regex': '(type|immutable|abstract)\s*JJJ',
      \   },
      \ ],
      \ 'haskell': [
      \   {
      \     'type': 'module',
      \     'pcre_regex': '^module\s+KEYWORD\s+',
      \     'regex': '^module\s+JJJ\s+',
      \   },
      \   {
      \     'type': 'top level function',
      \     'pcre_regex': '^\bKEYWORD(?!(\s+::))\s+((.|\s)*?)=\s+',
      \     'regex': '^\bJJJ(?!(\s+::))\s+((.|\s)*?)=\s+',
      \   },
      \   {
      \     'type': 'type-like',
      \     'pcre_regex': '^\s*((data(\s+family)?)|(newtype)|(type(\s+family)?))\s+KEYWORD\s+',
      \     'regex': '^\s*((data(\s+family)?)|(newtype)|(type(\s+family)?))\s+JJJ\s+',
      \   },
      \   {
      \     'type': '(data)type constructor 1',
      \     'pcre_regex': '(data|newtype)\s{1,3}(?!KEYWORD\s+)([^=]{1,40})=((\s{0,3}KEYWORD\s+)|([^=]{0,500}?((?<!(-- ))\|\s{0,3}KEYWORD\s+)))',
      \     'regex': '(data|newtype)\s{1,3}(?!JJJ\s+)([^=]{1,40})=((\s{0,3}JJJ\s+)|([^=]{0,500}?((?<!(-- ))\|\s{0,3}JJJ\s+)))',
      \   },
      \   {
      \     'type': 'data/newtype record field',
      \     'pcre_regex': '(data|newtype)([^=]*)=[^=]*?({([^=}]*?)(\bKEYWORD)\s+::[^=}]+})',
      \     'regex': '(data|newtype)([^=]*)=[^=]*?({([^=}]*?)(\bJJJ)\s+::[^=}]+})',
      \   },
      \   {
      \     'type': 'typeclass',
      \     'pcre_regex': '^class\s+(.+=>\s*)?KEYWORD\s+',
      \     'regex': '^class\s+(.+=>\s*)?JJJ\s+',
      \   },
      \ ],
      \ 'ocaml': [
      \   {
      \     'type': 'type',
      \     'pcre_regex': '^\s*(and|type)\s+.*\bKEYWORD\b',
      \     'regex': '^\s*(and|type)\s+.*\bJJJ\b',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'let\s+KEYWORD\b',
      \     'regex': 'let\s+JJJ\b',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'let\s+rec\s+KEYWORD\b',
      \     'regex': 'let\s+rec\s+JJJ\b',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*val\s*\bKEYWORD\b\s*',
      \     'regex': '\s*val\s*\bJJJ\b\s*',
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': '^\s*module\s*\bKEYWORD\b',
      \     'regex': '^\s*module\s*\bJJJ\b',
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': '^\s*module\s*type\s*\bKEYWORD\b',
      \     'regex': '^\s*module\s*type\s*\bJJJ\b',
      \   },
      \ ],
      \ 'lua': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \     'regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*.+[.:]KEYWORD\s*\(',
      \     'regex': 'function\s*.+[.:]JJJ\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*=\s*function\s*\(',
      \     'regex': '\bJJJ\s*=\s*function\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\b.+\.KEYWORD\s*=\s*function\s*\(',
      \     'regex': '\b.+\.JJJ\s*=\s*function\s*\(',
      \   },
      \ ],
      \ 'rust': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\blet\s+(\([^=\n]*)?(muts+)?KEYWORD([^=\n]*\))?(:\s*[^=\n]+)?\s*=\s*[^=\n]+',
      \     'regex': '\blet\s+(\([^=\n]*)?(muts+)?JJJ([^=\n]*\))?(:\s*[^=\n]+)?\s*=\s*[^=\n]+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bconst\s+KEYWORD:\s*[^=\n]+\s*=[^=\n]+',
      \     'regex': '\bconst\s+JJJ:\s*[^=\n]+\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bstatic\s+(mut\s+)?KEYWORD:\s*[^=\n]+\s*=[^=\n]+',
      \     'regex': '\bstatic\s+(mut\s+)?JJJ:\s*[^=\n]+\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bfn\s+.+\s*\((.+,\s+)?KEYWORD:\s*[^=\n]+\s*(,\s*.+)*\)',
      \     'regex': '\bfn\s+.+\s*\((.+,\s+)?JJJ:\s*[^=\n]+\s*(,\s*.+)*\)',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(if|while)\s+let\s+([^=\n]+)?(mut\s+)?KEYWORD([^=\n\(]+)?\s*=\s*[^=\n]+',
      \     'regex': '(if|while)\s+let\s+([^=\n]+)?(mut\s+)?JJJ([^=\n\(]+)?\s*=\s*[^=\n]+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'struct\s+[^\n{]+[{][^}]*(\s*KEYWORD\s*:\s*[^\n},]+)[^}]*}',
      \     'regex': 'struct\s+[^\n{]+[{][^}]*(\s*JJJ\s*:\s*[^\n},]+)[^}]*}',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'enum\s+[^\n{]+\s*[{][^}]*\bKEYWORD\b[^}]*}',
      \     'regex': 'enum\s+[^\n{]+\s*[{][^}]*\bJJJ\b[^}]*}',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bfn\s+KEYWORD\s*\(',
      \     'regex': '\bfn\s+JJJ\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bmacro_rules!\s+KEYWORD',
      \     'regex': '\bmacro_rules!\s+JJJ',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'struct\s+KEYWORD\s*[{\(]?',
      \     'regex': 'struct\s+JJJ\s*[{\(]?',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'trait\s+KEYWORD\s*[{]?',
      \     'regex': 'trait\s+JJJ\s*[{]?',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\btype\s+KEYWORD([^=\n]+)?\s*=[^=\n]+;',
      \     'regex': '\btype\s+JJJ([^=\n]+)?\s*=[^=\n]+;',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'impl\s+((\w+::)*\w+\s+for\s+)?(\w+::)*KEYWORD\s+[{]?',
      \     'regex': 'impl\s+((\w+::)*\w+\s+for\s+)?(\w+::)*JJJ\s+[{]?',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'mod\s+KEYWORD\s*[{]?',
      \     'regex': 'mod\s+JJJ\s*[{]?',
      \   },
      \ ],
      \ 'elixir': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bdef(p)?\s+KEYWORD\s*[ ,\(]',
      \     'regex': '\bdef(p)?\s+JJJ\s*[ ,\(]',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*KEYWORD\s*=[^=\n]+',
      \     'regex': '\s*JJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': 'defmodule\s+(\w+\.)*KEYWORD\s+',
      \     'regex': 'defmodule\s+(\w+\.)*JJJ\s+',
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': 'defprotocol\s+(\w+\.)*KEYWORD\s+',
      \     'regex': 'defprotocol\s+(\w+\.)*JJJ\s+',
      \   },
      \ ],
      \ 'erlang': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^KEYWORD\b\s*\(',
      \     'regex': '^JJJ\b\s*\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*KEYWORD\s*=[^:=\n]+',
      \     'regex': '\s*JJJ\s*=[^:=\n]+',
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': '^-module\(KEYWORD\)',
      \     'regex': '^-module\(JJJ\)',
      \   },
      \ ],
      \ 'scss': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '@mixin\sKEYWORD\b\s*\(',
      \     'regex': '@mixin\sJJJ\b\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '@function\sKEYWORD\b\s*\(',
      \     'regex': '@function\sJJJ\b\s*\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'KEYWORD\s*:\s*',
      \     'regex': 'JJJ\s*:\s*',
      \   },
      \ ],
      \ 'sml': [
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\s*(data)?type\s+.*\bKEYWORD\b',
      \     'regex': '\s*(data)?type\s+.*\bJJJ\b',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*val\s+\bKEYWORD\b',
      \     'regex': '\s*val\s+\bJJJ\b',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\s*fun\s+\bKEYWORD\b.*\s*=',
      \     'regex': '\s*fun\s+\bJJJ\b.*\s*=',
      \   },
      \   {
      \     'type': 'module',
      \     'pcre_regex': '\s*(structure|signature|functor)\s+\bKEYWORD\b',
      \     'regex': '\s*(structure|signature|functor)\s+\bJJJ\b',
      \   },
      \ ],
      \ 'sql': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(CREATE|create)\s+(.+?\s+)?(FUNCTION|function|PROCEDURE|procedure)\s+KEYWORD\s*\(',
      \     'regex': '(CREATE|create)\s+(.+?\s+)?(FUNCTION|function|PROCEDURE|procedure)\s+JJJ\s*\(',
      \   },
      \   {
      \     'type': 'table',
      \     'pcre_regex': '(CREATE|create)\s+(.+?\s+)?(TABLE|table)(\s+(IF NOT EXISTS|if not exists))?\s+KEYWORD\b',
      \     'regex': '(CREATE|create)\s+(.+?\s+)?(TABLE|table)(\s+(IF NOT EXISTS|if not exists))?\s+JJJ\b',
      \   },
      \   {
      \     'type': 'view',
      \     'pcre_regex': '(CREATE|create)\s+(.+?\s+)?(VIEW|view)\s+KEYWORD\b',
      \     'regex': '(CREATE|create)\s+(.+?\s+)?(VIEW|view)\s+JJJ\b',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(CREATE|create)\s+(.+?\s+)?(TYPE|type)\s+KEYWORD\b',
      \     'regex': '(CREATE|create)\s+(.+?\s+)?(TYPE|type)\s+JJJ\b',
      \   },
      \ ],
      \ 'systemverilog': [
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\s*class\s+\bKEYWORD\b',
      \     'regex': '\s*class\s+\bJJJ\b',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\s*task\s+\bKEYWORD\b',
      \     'regex': '\s*task\s+\bJJJ\b',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\s*\bKEYWORD\b\s*=',
      \     'regex': '\s*\bJJJ\b\s*=',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s[^\s]+\s*\bKEYWORD\b',
      \     'regex': 'function\s[^\s]+\s*\bJJJ\b',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*[^\s]*\s*[^\s]+\s+\bKEYWORD\b',
      \     'regex': '^\s*[^\s]*\s*[^\s]+\s+\bJJJ\b',
      \   },
      \ ],
      \ 'vhdl': [
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\s*type\s+\bKEYWORD\b',
      \     'regex': '\s*type\s+\bJJJ\b',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\s*constant\s+\bKEYWORD\b',
      \     'regex': '\s*constant\s+\bJJJ\b',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*\"?KEYWORD\"?\s*\(',
      \     'regex': 'function\s*\"?JJJ\"?\s*\(',
      \   },
      \ ],
      \ 'tex': [
      \   {
      \     'type': 'command',
      \     'pcre_regex': '\\.*newcommand\*?\s*\{\s*(\\)KEYWORD\s*}',
      \     'regex': '\\.*newcommand\*?\s*\{\s*(\\)JJJ\s*}',
      \   },
      \   {
      \     'type': 'command',
      \     'pcre_regex': '\\.*newcommand\*?\s*(\\)KEYWORD($|[^a-zA-Z0-9\?\*-])',
      \     'regex': '\\.*newcommand\*?\s*(\\)JJJ\j',
      \   },
      \   {
      \     'type': 'length',
      \     'pcre_regex': '\\(s)etlength\s*\{\s*(\\)KEYWORD\s*}',
      \     'regex': '\\(s)etlength\s*\{\s*(\\)JJJ\s*}',
      \   },
      \   {
      \     'type': 'counter',
      \     'pcre_regex': '\\newcounter\{\s*KEYWORD\s*}',
      \     'regex': '\\newcounter\{\s*JJJ\s*}',
      \   },
      \   {
      \     'type': 'environment',
      \     'pcre_regex': '\\.*newenvironment\s*\{\s*KEYWORD\s*}',
      \     'regex': '\\.*newenvironment\s*\{\s*JJJ\s*}',
      \   },
      \ ],
      \ 'pascal': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bfunction\s+KEYWORD\b',
      \     'regex': '\bfunction\s+JJJ\b',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bprocedure\s+KEYWORD\b',
      \     'regex': '\bprocedure\s+JJJ\b',
      \   },
      \ ],
      \ 'fsharp': [
      \   {
      \     'type': 'variable',
      \     'pcre_regex': 'let\s+KEYWORD\b.*\=',
      \     'regex': 'let\s+JJJ\b.*\=',
      \   },
      \   {
      \     'type': 'interface',
      \     'pcre_regex': 'member(\b.+\.|\s+)KEYWORD\b.*\=',
      \     'regex': 'member(\b.+\.|\s+)JJJ\b.*\=',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': 'type\s+KEYWORD\b.*\=',
      \     'regex': 'type\s+JJJ\b.*\=',
      \   },
      \ ],
      \ 'kotlin': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'fun\s*(<[^>]*>)?\s*KEYWORD\s*\(',
      \     'regex': 'fun\s*(<[^>]*>)?\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(val|var)\s*KEYWORD\b',
      \     'regex': '(val|var)\s*JJJ\b',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(class|interface)\s*KEYWORD\b',
      \     'regex': '(class|interface)\s*JJJ\b',
      \   },
      \ ],
      \ 'zig': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'fn\s+KEYWORD\b',
      \     'regex': 'fn\s+JJJ\b',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '(var|const)\s+KEYWORD\b',
      \     'regex': '(var|const)\s+JJJ\b',
      \   },
      \ ],
      \ 'protobuf': [
      \   {
      \     'type': 'message',
      \     'pcre_regex': 'message\s+KEYWORD\s*\{',
      \     'regex': 'message\s+JJJ\s*\{',
      \   },
      \   {
      \     'type': 'enum',
      \     'pcre_regex': 'enum\s+KEYWORD\s*\{',
      \     'regex': 'enum\s+JJJ\s*\{',
      \   },
      \ ],
      \ 'apex': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '^\s*(?:[\w\[\]]+\s+){1,3}KEYWORD\s*\(',
      \     'regex': '^\s*(?:[\w\[\]]+\s+){1,3}JJJ\s*\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n)]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n)]+',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '(class|interface)\s*KEYWORD\b',
      \     'regex': '(class|interface)\s*JJJ\b',
      \   },
      \ ],
      \ 'c': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \     'regex': '\bJJJ(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+JJJ(\)|\s)*\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \     'regex': '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+JJJ\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+JJJ\b',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \     'regex': '\b(class|struct|enum|union)\b\s*JJJ\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*JJJ\b\s*;',
      \   },
      \ ],
      \ 'cpp': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+KEYWORD(\)|\s)*\(',
      \     'regex': '\bJJJ(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+JJJ(\)|\s)*\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+KEYWORD\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+KEYWORD\b',
      \     'regex': '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+JJJ\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+JJJ\b',
      \   },
      \   {
      \     'type': 'type',
      \     'pcre_regex': '\b(class|struct|enum|union)\b\s*KEYWORD\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*KEYWORD\b\s*;',
      \     'regex': '\b(class|struct|enum|union)\b\s*JJJ\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*JJJ\b\s*;',
      \   },
      \ ],
      \ 'javascriptreact': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(service|factory)\([''\"]KEYWORD[''\"]',
      \     'regex': '(service|factory)\([''\"]JJJ[''\"]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \     'regex': '\bJJJ\s*[=:]\s*\([^\)]*\)\s+=>',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'regex': '\bJJJ\s*\([^()]*\)\s*[{]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s*[\(\{]',
      \     'regex': 'class\s*JJJ\s*[\(\{]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s+extends',
      \     'regex': 'class\s*JJJ\s+extends',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \     'regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*:\s*function\s*\(',
      \     'regex': '\bJJJ\s*:\s*function\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*=\s*function\s*\(',
      \     'regex': '\bJJJ\s*=\s*function\s*\(',
      \   },
      \ ],
      \ 'typescriptreact': [
      \   {
      \     'type': 'function',
      \     'pcre_regex': '(service|factory)\([''\"]KEYWORD[''\"]',
      \     'regex': '(service|factory)\([''\"]JJJ[''\"]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*[=:]\s*\([^\)]*\)\s+=>',
      \     'regex': '\bJJJ\s*[=:]\s*\([^\)]*\)\s+=>',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*\([^()]*\)\s*[{]',
      \     'regex': '\bJJJ\s*\([^()]*\)\s*[{]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s*[\(\{]',
      \     'regex': 'class\s*JJJ\s*[\(\{]',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'class\s*KEYWORD\s+extends',
      \     'regex': 'class\s*JJJ\s+extends',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': 'function\s*KEYWORD\s*\(',
      \     'regex': 'function\s*JJJ\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*:\s*function\s*\(',
      \     'regex': '\bJJJ\s*:\s*function\s*\(',
      \   },
      \   {
      \     'type': 'function',
      \     'pcre_regex': '\bKEYWORD\s*=\s*function\s*\(',
      \     'regex': '\bJJJ\s*=\s*function\s*\(',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\s*\bKEYWORD\s*=[^=\n]+',
      \     'regex': '\s*\bJJJ\s*=[^=\n]+',
      \   },
      \   {
      \     'type': 'variable',
      \     'pcre_regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bKEYWORD\b\s*,?\s*\)?',
      \     'regex': '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
      \   },
      \ ],
      \ }

" map any-language to concrete internal s:definitions[language]
let s:filetypes_proxy = {
      \ 'javascriptreact': 'javascript',
      \ 'c': 'cpp',
      \ }

function! s:add_definition(lang, definition) abort
  if !has_key(s:definitions, a:lang)
    let s:definitions[a:lang] = []
  endif

  call add(s:definitions[a:lang], a:definition)
endfunction

function! lang_map#find_definitions(language) abort
  if !lang_map#lang_exists(a:language)
    return
  endif

  return s:definitions[a:language]
endfunction

function! lang_map#definitions() abort
  return s:definitions
endfunction

function! lang_map#lang_exists(language) abort
  return has_key(s:definitions, a:language)
endfunction

function! lang_map#get_language_from_filetype(ft) abort
  if has_key(s:filetypes_proxy, a:ft)
    let maybe_lan = s:filetypes_proxy[a:ft]
  else
    let maybe_lan = a:ft
  endif

  if lang_map#lang_exists(maybe_lan)
    return maybe_lan
  else
    return 0
  endif
endfunction

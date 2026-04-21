vim9script

# NOTES:
# - All language regular expressions are ported from https://github.com/jacktasia/dumb-jump/blob/master/dumb-jump.el

const PLACEHOLDER = 'JJJ'

const DEFINITIONS = {
    'c++': [
        '\bJJJ(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+JJJ(\)|\s)*\(',
        '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+JJJ\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+JJJ\b',
        '\b(class|struct|enum|union)\b\s*JJJ\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*JJJ\b\s*;',
    ],
    'clojure': [
        '\(def.* JJJ($|[^a-zA-Z0-9\?\*-])',
    ],
    'coffeescript': [
        '^\s*JJJ\s*[=:].*[-=]>',
        '^\s*JJJ\s*[:=][^:=-][^>]+$',
        '^\s*\bclass\s+JJJ',
    ],
    'objc': [
        '\)\s*JJJ(:|\b|\s)',
        '\b\*?JJJ\s*=[^=\n]+',
        '(@interface|@protocol|@implementation)\b\s*JJJ\b\s*',
        'typedef\b\s+(NS_OPTIONS|NS_ENUM)\b\([^,]+?,\s*JJJ\b\s*',
    ],
    'swift': [
        '(let|var)\s*JJJ\s*(=|:)[^=:\n]+',
        'func\s+JJJ\b\s*(<[^>]*>)?\s*\(',
        '(class|struct|protocol|enum)\s+JJJ\b\s*?',
        '(typealias)\s+JJJ\b\s*?=',
    ],
    'csharp': [
        '^\s*(?:[\w\[\]]+\s+){1,3}JJJ\s*\(',
        '\s*\bJJJ\s*=[^=\n)]+',
        '\bforeach\s*\(\s*[\w\[\]<>,\.?]+\s+JJJ\s+in\b',
        '(class|interface)\s*JJJ\b',
    ],
    'java': [
        '^\s*(?:[\w\[\]]+\s+){1,3}JJJ\s*\(',
        '\s*\bJJJ\s*=[^=\n)]+',
        '(class|interface)\s*JJJ\b',
        '\benum\s+JJJ\b',
        '@interface\s+JJJ\b',
        '(public|protected|private|static)[^(]+JJJ\s*\(',
    ],
    'vala': [
        '^\s*(?:[\w\[\]]+\s+){1,3}JJJ\s*\(',
        '\s*\bJJJ\s*=[^=\n)]+',
        '(class|interface)\s*JJJ\b',
    ],
    'python': [
        '\s*\bJJJ\b(\s*:[^=\n]+)?\s*=[^=\n]+',
        '\s*\bJJJ\b(\s*:[^=]+)?\s*=[^=]+',
        'def\s*JJJ\b\s*\(',
        'class\s*JJJ\b\s*\(?',
        'async\s+def\s*JJJ\b\s*\(',
        '^\s*JJJ\s*=\s*lambda\b',
    ],
    'nim': [
        '(const|let|var)\s*JJJ\*?\s*(=|:)[^=:\n]+',
        '(proc|func|macro|template)\s*\`?JJJ\`?\b\*?\s*\(',
        'type\s*JJJ\b\*?\s*(\{[^}]+\})?\s*=\s*\w+',
    ],
    'nix': [
        '\b\s*JJJ\s*=[^=;]+',
    ],
    'org': [
        '^\s*#\+[nN][aA][mM][eE]:\s*JJJ($|[^a-zA-Z0-9\?\*-])',
        '^\s*#\+[cC][aA][lL][lL]:\s*JJJ($|[^a-zA-Z0-9\?\*-])',
        '^\*+\s+JJJ($|[^a-zA-Z0-9\?\*-])',
        '^\s*:CUSTOM_ID:\s*JJJ($|[^a-zA-Z0-9\?\*-])',
    ],
    'ruby': [
        '^\s*((\w+[.])*\w+,\s*)*JJJ(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
        '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*JJJ($|[^\w|:])',
        '(^|\W)define(_singleton|_instance)?_method(\s|[(])\s*:JJJ($|[^\w|:])',
        '(^|[^\w.])class\s+(\w*::)*JJJ($|[^\w|:])',
        '(^|[^\w.])module\s+(\w*::)*JJJ($|[^\w|:])',
        '(^|\W)alias(_method)?\W+JJJ(\W|$)',
    ],
    'groovy': [
        '^\s*((\w+[.])*\w+,\s*)*JJJ(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
        '(^|[^\w.])((private|public)\s+)?def\s+(\w+(::|[.]))*JJJ($|[^\w|:])',
        '(^|[^\w.])class\s+(\w*::)*JJJ($|[^\w|:])',
    ],
    'crystal': [
        '^\s*((\w+[.])*\w+,\s*)*JJJ(,\s*(\w+[.])*\w+)*\s*=([^=>~]|$)',
        '(^|[^\w.])((private|public|protected)\s+)?def\s+(\w+(::|[.]))*JJJ($|[^\w|:])',
        '(^|[^\w.])class\s+(\w*::)*JJJ($|[^\w|:])',
        '(^|[^\w.])module\s+(\w*::)*JJJ($|[^\w|:])',
        '(^|[^\w.])struct\s+(\w*::)*JJJ($|[^\w|:])',
        '(^|[^\w.])alias\s+(\w*::)*JJJ($|[^\w|:])',
    ],
    'scala': [
        '\bval\s*JJJ\s*=[^=\n]+',
        '\bvar\s*JJJ\s*=[^=\n]+',
        '\btype\s*JJJ\s*=[^=\n]+',
        '\bdef\s*JJJ\s*\(',
        'class\s*JJJ\s*\(?',
        'trait\s*JJJ\s*\(?',
        'object\s*JJJ\s*\(?',
    ],
    'solidity': [
        'function\s*JJJ\s*\(',
        'modifier\s*JJJ\s*\(',
        'event\s*JJJ\s*\(',
        'error\s*JJJ\s*\(',
        'contract\s*JJJ\s*(is|\{)',
        'struct\s*JJJ\s*\{',
    ],
    'r': [
        '\bJJJ\s*=[^=><]',
        '\bJJJ\s*<-\s*function\b',
    ],
    'perl': [
        'sub\s*JJJ\s*(\{|\()',
        'JJJ\s*=\s*',
    ],
    'shell': [
        'function\s*JJJ\s*',
        'JJJ\(\)\s*\{',
        '\bJJJ\s*=\s*',
    ],
    'php': [
        'function\s*JJJ\s*\(',
        '\*\s@method\s+[^ 	]+\s+JJJ\(',
        '(\s|->|\$|::)JJJ\s*=\s*',
        '\*\s@property(-read|-write)?\s+([^ 	]+\s+)&?\$JJJ(\s+|$)',
        'trait\s*JJJ\s*\{',
        'interface\s*JJJ\s*(extends|\{)',
        'class\s*JJJ\s*(extends|implements|\{)',
        '\benum\s+JJJ\b\s*(:\s*(int|string))?\s*(implements[^{]+)?\{',
        '^\s*case\s+JJJ\s*(;|=)',
        '\babstract\s+class\s+JJJ\s*(extends|implements|\{)',
        '\bfinal\s+(readonly\s+)?class\s+JJJ\s*(extends|implements|\{)',
        '\breadonly\s+(final\s+)?class\s+JJJ\s*(extends|implements|\{)',
        '(final\s+)?(public|protected|private)?\s*const\s+JJJ\s*=',
        '^const\s+JJJ\s*=',
        '^\s*define\s*\(\s*[''\"]JJJ[''\"]',
        '(public|protected|private)\s+(static\s+)?(readonly\s+)?\??[A-Za-z_][A-Za-z0-9_\\|&]*\s+\$JJJ\s*(;|=|,)',
        '(public|protected|private)?\s*static\s+\$JJJ\s*(;|=)',
        '\bnamespace\s+([A-Za-z_][A-Za-z0-9_]*\\)*JJJ\s*[;{]',
        '\buse\s+([A-Za-z_][A-Za-z0-9_]*\\)*JJJ\s*(;|,|\s+as\s+)',
    ],
    'dart': [
        '\bJJJ\s*\([^()]*\)\s*[{]',
        'class\s*JJJ\s*[\(\{]',
    ],
    'fennel': [
        '\((local|var)\s+JJJ($|[^a-zA-Z0-9\?\*-])',
        '\(fn\s+JJJ($|[^a-zA-Z0-9\?\*-])',
        '\(macro\s+JJJ($|[^a-zA-Z0-9\?\*-])',
    ],
    'go': [
        '\s*\bJJJ\s*=[^=\n]+',
        '\s*\bJJJ\s*:=\s*',
        'func\s+\([^\)]*\)\s+JJJ\s*\(',
        'func\s+JJJ\s*\(',
        'type\s+JJJ\s+struct\s+\{',
        'type\s+JJJ(\[[^]]+\])?\s+interface\s*\{',
        'type\s+JJJ(\[[^]]+\])?\s+',
    ],
    'javascript': [
        '(service|factory)\([''\"]JJJ[''\"]',
        '\bJJJ\s*[=:]\s*\([^\)]*\)\s+=>',
        '\bJJJ\s*\([^()]*\)\s*[{]',
        'class\s*JJJ\s*[\(\{]',
        'class\s*JJJ\s+extends',
        '\s*\bJJJ\s*=[^=\n]+',
        '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
        'function\s*JJJ\s*\(',
        '\bJJJ\s*:\s*function\s*\(',
        '\bJJJ\s*=\s*function\s*\(',
    ],
    'hcl': [
        '(variable|output|module)\s*\"JJJ\"\s*\{',
        '(data|resource)\s*\"\w+\"\s*\"JJJ\"\s*\{',
    ],
    'typescript': [
        '(service|factory)\([''\"]JJJ[''\"]',
        '\bJJJ\s*[=:]\s*\([^\)]*\)\s+=>',
        '\bJJJ\s*\([^()]*\)\s*[{]',
        'class\s*JJJ(\s*<[^>]*>)?\s*[\(\{]',
        'class\s*JJJ(\s*<[^>]*>)?\s+extends',
        'class\s*JJJ(\s*<[^>]*>)?\s*[\(\{]',
        'class\s*JJJ(\s*<[^>]*>)?\s+extends',
        '(export\s+)?interface\s+JJJ\b',
        '(export\s+)?type\s+JJJ\b',
        '(export\s+)?enum\s+JJJ\b',
        '(declare\s+)?namespace\s+JJJ\b',
        '(export\s+)?module\s+JJJ\b',
        'function\s*JJJ\s*\(',
        '\bJJJ\s*:\s*function\s*\(',
        '\bJJJ\s*=\s*function\s*\(',
        '\s*\bJJJ\s*=[^=\n]+',
        '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
    ],
    'haskell': [
        '^module\s+JJJ\s+',
        '^\bJJJ(?!(\s+::))\s+((.|\s)*?)=\s+',
        '^\s*((data(\s+family)?)|(newtype)|(type(\s+family)?))\s+JJJ\s+',
        '(data|newtype)\s{1,3}(?!JJJ\s+)([^=]{1,40})=((\s{0,3}JJJ\s+)|([^=]{0,500}?((?<!(-- ))\|\s{0,3}JJJ\s+)))',
        '(data|newtype)([^=]*)=[^=]*?({([^=}]*?)(\bJJJ)\s+::[^=}]+})',
        '^class\s+(.+=>\s*)?JJJ\s+',
    ],
    'ocaml': [
        '^\s*(and|type)\s+.*\bJJJ\b',
        'let\s+JJJ\b',
        'let\s+rec\s+JJJ\b',
        '\s*val\s*\bJJJ\b\s*',
        '^\s*module\s*\bJJJ\b',
        '^\s*module\s*type\s*\bJJJ\b',
    ],
    'lua': [
        '\s*\bJJJ\s*=[^=\n]+',
        '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
        'function\s*JJJ\s*\(',
        'function\s*.+[.:]JJJ\s*\(',
        '\bJJJ\s*=\s*function\s*\(',
        '\b.+\.JJJ\s*=\s*function\s*\(',
    ],
    'rust': [
        '\blet\s+(\([^=\n]*)?(mut\s+)?JJJ([^=\n]*\))?(:\s*[^=\n]+)?\s*=\s*[^=\n]+',
        '\bconst\s+JJJ:\s*[^=\n]+\s*=[^=\n]+',
        '\bstatic\s+(mut\s+)?JJJ:\s*[^=\n]+\s*=[^=\n]+',
        '\bfn\s+.+\s*\((.+,\s+)?JJJ:\s*[^=\n]+\s*(,\s*.+)*\)',
        '(if|while)\s+let\s+([^=\n]+)?(mut\s+)?JJJ([^=\n\(]+)?\s*=\s*[^=\n]+',
        'struct\s+[^\n{]+[{][^}]*(\s*JJJ\s*:\s*[^\n},]+)[^}]*}',
        'enum\s+[^\n{]+\s*[{][^}]*\bJJJ\b[^}]*}',
        '\bfn\s+JJJ\s*\(',
        '\bmacro_rules!\s+JJJ',
        'struct\s+JJJ\s*[{\(]?',
        'trait\s+JJJ\s*[{]?',
        '\btype\s+JJJ([^=\n]+)?\s*=[^=\n]+;',
        'impl\s+((\w+::)*\w+\s+for\s+)?(\w+::)*JJJ\s+[{]?',
        'mod\s+JJJ\s*[{]?',
        '\benum\s+JJJ\b\s*[{]?',
    ],
    'elixir': [
        '\bdef(p)?\s+JJJ\s*[ ,\(]',
        '\s*JJJ\s*=[^=\n]+',
        'defmodule\s+(\w+\.)*JJJ\s+',
        'defprotocol\s+(\w+\.)*JJJ\s+',
    ],
    'erlang': [
        '^JJJ\b\s*\(',
        '\s*JJJ\s*=[^:=\n]+',
        '^-module\(JJJ\)',
    ],
    'scss': [
        '@mixin\sJJJ\b\s*\(',
        '@function\sJJJ\b\s*\(',
        'JJJ\s*:\s*',
    ],
    'sql': [
        '(CREATE|create)\s+(.+?\s+)?(FUNCTION|function|PROCEDURE|procedure)\s+JJJ\s*\(',
        '(CREATE|create)\s+(.+?\s+)?(TABLE|table)(\s+(IF NOT EXISTS|if not exists))?\s+JJJ\b',
        '(CREATE|create)\s+(.+?\s+)?(VIEW|view)\s+JJJ\b',
        '(CREATE|create)\s+(.+?\s+)?(TYPE|type)\s+JJJ\b',
    ],
    'tex': [
        '\\.*newcommand\*?\s*\{\s*(\\)JJJ\s*}',
        '\\.*newcommand\*?\s*(\\)JJJ($|[^a-zA-Z0-9\?\*-])',
        '\\(s)etlength\s*\{\s*(\\)JJJ\s*}',
        '\\newcounter\{\s*JJJ\s*}',
        '\\.*newenvironment\s*\{\s*JJJ\s*}',
    ],
    'fsharp': [
        'let\s+JJJ\b.*\=',
        'member(\b.+\.|\s+)JJJ\b.*\=',
        'type\s+JJJ\b.*\=',
    ],
    'kotlin': [
        'fun\s*(<[^>]*>)?\s*JJJ\s*\(',
        '(val|var)\s*JJJ\b',
        '(class|interface)\s*JJJ\b',
    ],
    'zig': [
        'fn\s+JJJ\b',
        '(var|const)\s+JJJ\b',
    ],
    'protobuf': [
        'message\s+JJJ\s*\{',
        'enum\s+JJJ\s*\{',
    ],
    'c': [
        '\bJJJ(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+JJJ(\)|\s)*\(',
        '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+JJJ\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+JJJ\b',
        '\b(class|struct|enum|union)\b\s*JJJ\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*JJJ\b\s*;',
    ],
    'cpp': [
        '\bJJJ(\s|\))*\((\w|[,&*.<>:]|\s)*(\))\s*(const|->|\{|$)|typedef\s+(\w|[(*]|\s)+JJJ(\)|\s)*\(',
        '\b(?!(class\b|struct\b|return\b|else\b|delete\b))(\w+|[,>])([*&]|\s)+JJJ\s*(\[(\d|\s)*\])*\s*([=,(){;]|:\s*\d)|#define\s+JJJ\b',
        '\b(class|struct|enum|union)\b\s*JJJ\b\s*(final\s*)?(:((\s*\w+\s*::)*\s*\w*\s*<?(\s*\w+\s*::)*\w+>?\s*,*)+)?((\{|$))|}\s*JJJ\b\s*;',
    ],
    'cs': [
        '^\s*(?:[\w\[\]]+\s+){1,3}JJJ\s*\(',
        '\s*\bJJJ\s*=[^=\n)]+',
        '\bforeach\s*\(\s*[\w\[\]<>,\.?]+\s+JJJ\s+in\b',
        '(class|interface)\s*JJJ\b',
    ],
    'javascriptreact': [
        '(service|factory)\([''\"]JJJ[''\"]',
        '\bJJJ\s*[=:]\s*\([^\)]*\)\s+=>',
        '\bJJJ\s*\([^()]*\)\s*[{]',
        'class\s*JJJ\s*[\(\{]',
        'class\s*JJJ\s+extends',
        '\s*\bJJJ\s*=[^=\n]+',
        '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
        'function\s*JJJ\s*\(',
        '\bJJJ\s*:\s*function\s*\(',
        '\bJJJ\s*=\s*function\s*\(',
    ],
    'typescriptreact': [
        '(service|factory)\([''\"]JJJ[''\"]',
        '\bJJJ\s*[=:]\s*\([^\)]*\)\s+=>',
        '\bJJJ\s*\([^()]*\)\s*[{]',
        'class\s*JJJ(\s*<[^>]*>)?\s*[\(\{]',
        'class\s*JJJ(\s*<[^>]*>)?\s+extends',
        'class\s*JJJ(\s*<[^>]*>)?\s*[\(\{]',
        'class\s*JJJ(\s*<[^>]*>)?\s+extends',
        '(export\s+)?interface\s+JJJ\b',
        '(export\s+)?type\s+JJJ\b',
        '(export\s+)?enum\s+JJJ\b',
        '(declare\s+)?namespace\s+JJJ\b',
        '(export\s+)?module\s+JJJ\b',
        'function\s*JJJ\s*\(',
        '\bJJJ\s*:\s*function\s*\(',
        '\bJJJ\s*=\s*function\s*\(',
        '\s*\bJJJ\s*=[^=\n]+',
        '\bfunction\b[^\(]*\(\s*[^\)]*\bJJJ\b\s*,?\s*\)?',
    ],
    'sh': [
        'function\s*JJJ\s*',
        'JJJ\(\)\s*\{',
        '\bJJJ\s*=\s*',
    ],
    'zsh': [
        'function\s*JJJ\s*',
        'JJJ\(\)\s*\{',
        '\bJJJ\s*=\s*',
    ],
}

def Definitions(...opts: list<any>): list<string>
    var ft = get(opts, 1, '')
    ft = empty(ft) ? (&filetype !=# '' ? &filetype : &buftype) : ft
    return get(DEFINITIONS, ft, [])
enddef

def BuildPatterns(...opts: list<any>): list<string>
    const definitions = Definitions(opts)
    const keyword = expand('<cword>')
    return mapnew(definitions, (_k, v) => substitute(v, PLACEHOLDER, keyword, 'g'))
enddef

export def Patterns(...opts: list<any>): list<string>
    return BuildPatterns(opts)
enddef

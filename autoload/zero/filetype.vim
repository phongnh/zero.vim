" rg --type-list
let s:rg_filetypes = {
      \ 'ada': ['*.adb', '*.ads'],
      \ 'agda': ['*.agda', '*.lagda'],
      \ 'aidl': ['*.aidl'],
      \ 'alire': ['alire.toml'],
      \ 'amake': ['*.bp', '*.mk'],
      \ 'asciidoc': ['*.adoc', '*.asc', '*.asciidoc'],
      \ 'asm': ['*.S', '*.asm', '*.s'],
      \ 'asp': ['*.ascx', '*.ascx.cs', '*.ascx.vb', '*.asp', '*.aspx', '*.aspx.cs', '*.aspx.vb'],
      \ 'ats': ['*.ats', '*.dats', '*.hats', '*.sats'],
      \ 'avro': ['*.avdl', '*.avpr', '*.avsc'],
      \ 'awk': ['*.awk'],
      \ 'bat': ['*.bat'],
      \ 'batch': ['*.bat'],
      \ 'bazel': ['*.BUILD', '*.bazel', '*.bazelrc', '*.bzl', 'BUILD', 'MODULE.bazel', 'WORKSPACE', 'WORKSPACE.bazel'],
      \ 'bitbake': ['*.bb', '*.bbappend', '*.bbclass', '*.conf', '*.inc'],
      \ 'brotli': ['*.br'],
      \ 'buildstream': ['*.bst'],
      \ 'bzip2': ['*.bz2', '*.tbz2'],
      \ 'c': ['*.[chH]', '*.[chH].in', '*.cats'],
      \ 'cabal': ['*.cabal'],
      \ 'candid': ['*.did'],
      \ 'carp': ['*.carp'],
      \ 'cbor': ['*.cbor'],
      \ 'ceylon': ['*.ceylon'],
      \ 'clojure': ['*.clj', '*.cljc', '*.cljs', '*.cljx'],
      \ 'cmake': ['*.cmake', 'CMakeLists.txt'],
      \ 'cmd': ['*.bat', '*.cmd'],
      \ 'cml': ['*.cml'],
      \ 'coffeescript': ['*.coffee'],
      \ 'config': ['*.cfg', '*.conf', '*.config', '*.ini'],
      \ 'coq': ['*.v'],
      \ 'cpp': ['*.[ChH]', '*.[ChH].in', '*.[ch]pp', '*.[ch]pp.in', '*.[ch]xx', '*.[ch]xx.in', '*.cc', '*.cc.in', '*.hh', '*.hh.in', '*.inl'],
      \ 'creole': ['*.creole'],
      \ 'crystal': ['*.cr', '*.ecr', 'Projectfile', 'shard.yml'],
      \ 'cs': ['*.cs'],
      \ 'csharp': ['*.cs'],
      \ 'cshtml': ['*.cshtml'],
      \ 'csproj': ['*.csproj'],
      \ 'css': ['*.css', '*.scss'],
      \ 'csv': ['*.csv'],
      \ 'cuda': ['*.cu', '*.cuh'],
      \ 'cython': ['*.pxd', '*.pxi', '*.pyx'],
      \ 'd': ['*.d'],
      \ 'dart': ['*.dart'],
      \ 'devicetree': ['*.dts', '*.dtsi'],
      \ 'dhall': ['*.dhall'],
      \ 'diff': ['*.diff', '*.patch'],
      \ 'dita': ['*.dita', '*.ditamap', '*.ditaval'],
      \ 'docker': ['*Dockerfile*'],
      \ 'dockercompose': ['docker-compose.*.yml', 'docker-compose.yml'],
      \ 'dts': ['*.dts', '*.dtsi'],
      \ 'dvc': ['*.dvc', 'Dvcfile'],
      \ 'ebuild': ['*.ebuild', '*.eclass'],
      \ 'edn': ['*.edn'],
      \ 'elisp': ['*.el'],
      \ 'elixir': ['*.eex', '*.ex', '*.exs', '*.heex', '*.leex', '*.livemd'],
      \ 'elm': ['*.elm'],
      \ 'erb': ['*.erb'],
      \ 'erlang': ['*.erl', '*.hrl'],
      \ 'fennel': ['*.fnl'],
      \ 'fidl': ['*.fidl'],
      \ 'fish': ['*.fish'],
      \ 'flatbuffers': ['*.fbs'],
      \ 'fortran': ['*.F', '*.F77', '*.F90', '*.F95', '*.f', '*.f77', '*.f90', '*.f95', '*.pfo'],
      \ 'fsharp': ['*.fs', '*.fsi', '*.fsx'],
      \ 'fut': ['*.fut'],
      \ 'gap': ['*.g', '*.gap', '*.gd', '*.gi', '*.tst'],
      \ 'gn': ['*.gn', '*.gni'],
      \ 'go': ['*.go'],
      \ 'gprbuild': ['*.gpr'],
      \ 'gradle': ['*.gradle', '*.gradle.kts', 'gradle-wrapper.*', 'gradle.properties', 'gradlew', 'gradlew.bat'],
      \ 'graphql': ['*.graphql', '*.graphqls'],
      \ 'groovy': ['*.gradle', '*.groovy'],
      \ 'gzip': ['*.gz', '*.tgz'],
      \ 'h': ['*.h', '*.hh', '*.hpp'],
      \ 'haml': ['*.haml'],
      \ 'hare': ['*.ha'],
      \ 'haskell': ['*.c2hs', '*.cpphs', '*.hs', '*.hsc', '*.lhs'],
      \ 'hbs': ['*.hbs'],
      \ 'hs': ['*.hs', '*.lhs'],
      \ 'html': ['*.ejs', '*.htm', '*.html'],
      \ 'hy': ['*.hy'],
      \ 'idris': ['*.idr', '*.lidr'],
      \ 'images': ['*.jpeg', '*.jpg', '*.png', '*.svg', '*.ico', '*.bmp', '*.gif'],
      \ 'janet': ['*.janet'],
      \ 'java': ['*.java', '*.jsp', '*.jspx', '*.properties'],
      \ 'jinja': ['*.j2', '*.jinja', '*.jinja2'],
      \ 'jl': ['*.jl'],
      \ 'js': ['*.cjs', '*.js', '*.jsx', '*.mjs', '*.vue'],
      \ 'json': ['*.json', '*.sarif', 'composer.lock'],
      \ 'jsonl': ['*.jsonl'],
      \ 'julia': ['*.jl'],
      \ 'jupyter': ['*.ipynb', '*.jpynb'],
      \ 'k': ['*.k'],
      \ 'kotlin': ['*.kt', '*.kts'],
      \ 'lean': ['*.lean'],
      \ 'less': ['*.less'],
      \ 'license': ['*[.-]LICEN[CS]E*', 'AGPL-*[0-9]*', 'APACHE-*[0-9]*', 'BSD-*[0-9]*', 'CC-BY-*', 'COPYING', 'COPYING[.-]*', 'COPYRIGHT', 'COPYRIGHT[.-]*', 'EULA', 'EULA[.-]*', 'GFDL-*[0-9]*', 'GNU-*[0-9]*', 'GPL-*[0-9]*', 'LGPL-*[0-9]*', 'LICEN[CS]E', 'LICEN[CS]E[.-]*', 'MIT-*[0-9]*', 'MPL-*[0-9]*', 'NOTICE', 'NOTICE[.-]*', 'OFL-*[0-9]*', 'PATENTS', 'PATENTS[.-]*', 'UNLICEN[CS]E', 'UNLICEN[CS]E[.-]*', 'agpl[.-]*', 'gpl[.-]*', 'lgpl[.-]*', 'licen[cs]e', 'licen[cs]e.*'],
      \ 'lilypond': ['*.ily', '*.ly'],
      \ 'lisp': ['*.el', '*.jl', '*.lisp', '*.lsp', '*.sc', '*.scm'],
      \ 'lock': ['*.lock', 'package-lock.json'],
      \ 'log': ['*.log'],
      \ 'lua': ['*.lua'],
      \ 'lz4': ['*.lz4'],
      \ 'lzma': ['*.lzma'],
      \ 'm4': ['*.ac', '*.m4'],
      \ 'make': ['*.mak', '*.mk', '[Gg][Nn][Uu]makefile', '[Gg][Nn][Uu]makefile.am', '[Gg][Nn][Uu]makefile.in', '[Mm]akefile', '[Mm]akefile.am', '[Mm]akefile.in'],
      \ 'mako': ['*.mako', '*.mao'],
      \ 'man': ['*.[0-9][cEFMmpSx]', '*.[0-9lnpx]'],
      \ 'markdown': ['*.markdown', '*.md', '*.mdown', '*.mdwn', '*.mdx', '*.mkd', '*.mkdn'],
      \ 'matlab': ['*.m'],
      \ 'md': ['*.markdown', '*.md', '*.mdown', '*.mdwn', '*.mdx', '*.mkd', '*.mkdn'],
      \ 'meson': ['meson.build', 'meson.options', 'meson_options.txt'],
      \ 'minified': ['*.min.css', '*.min.html', '*.min.js'],
      \ 'mint': ['*.mint'],
      \ 'mk': ['mkfile'],
      \ 'ml': ['*.ml'],
      \ 'motoko': ['*.mo'],
      \ 'msbuild': ['*.csproj', '*.fsproj', '*.proj', '*.props', '*.sln', '*.targets', '*.vcxproj'],
      \ 'nim': ['*.nim', '*.nimble', '*.nimf', '*.nims'],
      \ 'nix': ['*.nix'],
      \ 'objc': ['*.h', '*.m'],
      \ 'objcpp': ['*.h', '*.mm'],
      \ 'ocaml': ['*.ml', '*.mli', '*.mll', '*.mly'],
      \ 'org': ['*.org', '*.org_archive'],
      \ 'pants': ['BUILD'],
      \ 'pascal': ['*.dpr', '*.inc', '*.lpr', '*.pas', '*.pp'],
      \ 'pdf': ['*.pdf'],
      \ 'perl': ['*.PL', '*.perl', '*.pl', '*.plh', '*.plx', '*.pm', '*.t'],
      \ 'php': ['*.php', '*.php3', '*.php4', '*.php5', '*.php7', '*.php8', '*.pht', '*.phtml'],
      \ 'po': ['*.po'],
      \ 'pod': ['*.pod'],
      \ 'postscript': ['*.eps', '*.ps'],
      \ 'prolog': ['*.P', '*.pl', '*.pro', '*.prolog'],
      \ 'protobuf': ['*.proto'],
      \ 'ps': ['*.cdxml', '*.ps1', '*.ps1xml', '*.psd1', '*.psm1'],
      \ 'puppet': ['*.epp', '*.erb', '*.pp', '*.rb'],
      \ 'purs': ['*.purs'],
      \ 'py': ['*.py', '*.pyi'],
      \ 'python': ['*.py', '*.pyi'],
      \ 'qmake': ['*.prf', '*.pri', '*.pro'],
      \ 'qml': ['*.qml'],
      \ 'r': ['*.R', '*.Rmd', '*.Rnw', '*.r'],
      \ 'racket': ['*.rkt'],
      \ 'rails': ['*.rb', '*.ru', '*.yaml', '*.yml', '*.erb', '*.haml', '*.coffee', '*.inky-haml', '*.hamlc'],
      \ 'raku': ['*.p6', '*.pl6', '*.pm6', '*.raku', '*.rakudoc', '*.rakumod', '*.rakutest'],
      \ 'rdoc': ['*.rdoc'],
      \ 'readme': ['*README', 'README*'],
      \ 'reasonml': ['*.re', '*.rei'],
      \ 'red': ['*.r', '*.red', '*.reds'],
      \ 'rescript': ['*.res', '*.resi'],
      \ 'robot': ['*.robot'],
      \ 'rst': ['*.rst'],
      \ 'ruby': ['*.gemspec', '*.rb', '*.rbw', '.irbrc', 'Gemfile', 'Rakefile', 'config.ru'],
      \ 'rust': ['*.rs'],
      \ 'sass': ['*.sass', '*.scss'],
      \ 'scala': ['*.sbt', '*.scala'],
      \ 'sh': ['*.bash', '*.bashrc', '*.csh', '*.cshrc', '*.ksh', '*.kshrc', '*.sh', '*.tcsh', '*.zsh', '.bash_login', '.bash_logout', '.bash_profile', '.bashrc', '.cshrc', '.kshrc', '.login', '.logout', '.profile', '.tcshrc', '.zlogin', '.zlogout', '.zprofile', '.zshenv', '.zshrc', 'bash_login', 'bash_logout', 'bash_profile', 'bashrc', 'profile', 'zlogin', 'zlogout', 'zprofile', 'zshenv', 'zshrc'],
      \ 'slim': ['*.skim', '*.slim', '*.slime'],
      \ 'smarty': ['*.tpl'],
      \ 'sml': ['*.sig', '*.sml'],
      \ 'solidity': ['*.sol'],
      \ 'soy': ['*.soy'],
      \ 'spark': ['*.spark'],
      \ 'spec': ['*.spec'],
      \ 'sql': ['*.psql', '*.sql'],
      \ 'stylus': ['*.styl'],
      \ 'sv': ['*.h', '*.sv', '*.svh', '*.v', '*.vg'],
      \ 'svelte': ['*.svelte'],
      \ 'svg': ['*.svg'],
      \ 'swift': ['*.swift'],
      \ 'swig': ['*.def', '*.i'],
      \ 'systemd': ['*.automount', '*.conf', '*.device', '*.link', '*.mount', '*.path', '*.scope', '*.service', '*.slice', '*.socket', '*.swap', '*.target', '*.timer'],
      \ 'taskpaper': ['*.taskpaper'],
      \ 'tcl': ['*.tcl'],
      \ 'tex': ['*.bib', '*.cls', '*.dtx', '*.ins', '*.ltx', '*.sty', '*.tex'],
      \ 'texinfo': ['*.texi'],
      \ 'textile': ['*.textile'],
      \ 'tf': ['*.auto.tfvars', '*.auto.tfvars.json', '*.terraform.lock.hcl', '*.terraformrc', '*.tf', '*.tf.json', '*.tfrc', 'terraform.rc', 'terraform.tfvars', 'terraform.tfvars.json'],
      \ 'thrift': ['*.thrift'],
      \ 'toml': ['*.toml', 'Cargo.lock'],
      \ 'ts': ['*.cts', '*.mts', '*.ts', '*.tsx'],
      \ 'twig': ['*.twig'],
      \ 'txt': ['*.txt'],
      \ 'typescript': ['*.cts', '*.mts', '*.ts', '*.tsx'],
      \ 'typoscript': ['*.ts', '*.typoscript'],
      \ 'usd': ['*.usd', '*.usda', '*.usdc'],
      \ 'v': ['*.v', '*.vsh'],
      \ 'vala': ['*.vala'],
      \ 'vb': ['*.vb'],
      \ 'vcl': ['*.vcl'],
      \ 'verilog': ['*.sv', '*.svh', '*.v', '*.vh'],
      \ 'vhdl': ['*.vhd', '*.vhdl'],
      \ 'vim': ['*.vim', '.gvimrc', '.vimrc', '_gvimrc', '_vimrc', 'gvimrc', 'vimrc'],
      \ 'vimscript': ['*.vim', '.gvimrc', '.vimrc', '_gvimrc', '_vimrc', 'gvimrc', 'vimrc'],
      \ 'vue': ['*.vue'],
      \ 'webidl': ['*.idl', '*.webidl', '*.widl'],
      \ 'wgsl': ['*.wgsl'],
      \ 'wiki': ['*.mediawiki', '*.wiki'],
      \ 'xml': ['*.dtd', '*.rng', '*.sch', '*.xhtml', '*.xjb', '*.xml', '*.xml.dist', '*.xsd', '*.xsl', '*.xslt'],
      \ 'xz': ['*.txz', '*.xz'],
      \ 'yacc': ['*.y'],
      \ 'yaml': ['*.yaml', '*.yml'],
      \ 'yang': ['*.yang'],
      \ 'z': ['*.Z'],
      \ 'zig': ['*.zig'],
      \ 'zsh': ['*.zsh', '.zlogin', '.zlogout', '.zprofile', '.zshenv', '.zshrc', 'zlogin', 'zlogout', 'zprofile', 'zshenv', 'zshrc'],
      \ 'zstd': ['*.zst', '*.zstd'],
      \ }

" Map vim filetype to rg filetype
" - key: vim filetype 
" - value: rg filetype
let s:rg_filetype_mappings = {
      \ 'python':          'py',
      \ 'javascript':      'js',
      \ 'javascriptreact': 'js',
      \ 'typescript':      'ts',
      \ 'typescriptreact': 'ts',
      \ }

function! zero#filetype#RgFileTypeOpts(...) abort
  let opts = []
  let ft = get(a:, 1, &filetype !=# '' ? &filetype : &buftype)
  let ft = get(s:rg_filetype_mappings, ft, ft)
  if strlen(ft) && has_key(s:rg_filetypes, ft)
    call add(opts, '-t ' . ft)
  else
    let ext = expand('%:e')
    if strlen(ext)
      call add(opts, '-g ' . shellescape(printf('*.{%s}', ext)))
    endif
  endif
  return opts
endfunction

function! s:RgOpts(keyword) abort
  let opts = zero#filetype#RgFileTypeOpts()
  call add(opts, shellescape(a:keyword))
  return join(opts, ' ')
endfunction

function! zero#filetype#RgCCword() abort
  return s:RgOpts(zero#CCword())
endfunction

function! zero#filetype#RgCword() abort
  return s:RgOpts(zero#Cword())
endfunction

function! zero#filetype#RgWord() abort
  return s:RgOpts(zero#Word())
endfunction

function! zero#filetype#RgVword() abort
  return s:RgOpts(zero#Vword())
endfunction

function! zero#filetype#GitFileTypeOpts(...) abort
  let opts = []
  let ft = get(a:, 1, &filetype !=# '' ? &filetype : &buftype)
  let ft = get(s:rg_filetype_mappings, ft, ft)
  if strlen(ft) && has_key(s:rg_filetypes, ft)
    call add(opts, '--')
    for ext in s:rg_filetypes[ft]
      call add(opts, shellescape(ext))
    endfor
  else
    let ext = expand('%:e')
    if strlen(ext)
      call add(opts, '--')
      call add(opts, shellescape(printf('*.{%s}', ext)))
    endif
  endif
  return opts
endfunction

function! s:GitOpts(keyword) abort
  let opts = [shellescape(a:keyword)]
  call extend(opts, zero#filetype#GitFileTypeOpts())
  return join(opts, ' ')
endfunction

function! zero#filetype#GitCCword() abort
  return s:GitOpts(zero#CCword())
endfunction

function! zero#filetype#GitCword() abort
  return s:GitOpts(zero#Cword())
endfunction

function! zero#filetype#GitWord() abort
  return s:GitOpts(zero#Word())
endfunction

function! zero#filetype#GitVword() abort
  return s:GitOpts(zero#Vword())
endfunction

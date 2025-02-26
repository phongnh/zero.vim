" rg --type-list
let s:rg_filetypes = {
      \ 'c': ['*.[chH]', '*.[chH].in', '*.cats'],
      \ 'cmake': ['*.cmake', 'CMakeLists.txt'],
      \ 'config': ['*.cfg', '*.conf', '*.config', '*.ini'],
      \ 'cpp': ['*.[ChH]', '*.[ChH].in', '*.[ch]pp', '*.[ch]pp.in', '*.[ch]xx', '*.[ch]xx.in', '*.cc', '*.cc.in', '*.hh', '*.hh.in', '*.inl'],
      \ 'crystal': ['*.cr', '*.ecr', 'Projectfile', 'shard.yml'],
      \ 'css': ['*.css', '*.scss'],
      \ 'csv': ['*.csv'],
      \ 'dart': ['*.dart'],
      \ 'diff': ['*.diff', '*.patch'],
      \ 'docker': ['*Dockerfile*'],
      \ 'dockercompose': ['docker-compose.*.yml', 'docker-compose.yml'],
      \ 'elixir': ['*.eex', '*.ex', '*.exs', '*.heex', '*.leex', '*.livemd'],
      \ 'elm': ['*.elm'],
      \ 'erb': ['*.erb'],
      \ 'erlang': ['*.erl', '*.hrl'],
      \ 'fennel': ['*.fnl'],
      \ 'fish': ['*.fish'],
      \ 'go': ['*.go'],
      \ 'graphql': ['*.graphql', '*.graphqls'],
      \ 'h': ['*.h', '*.hh', '*.hpp'],
      \ 'haml': ['*.haml'],
      \ 'html': ['*.ejs', '*.htm', '*.html'],
      \ 'js': ['*.cjs', '*.js', '*.jsx', '*.mjs', '*.vue'],
      \ 'json': ['*.json', '*.sarif', 'composer.lock'],
      \ 'jsonl': ['*.jsonl'],
      \ 'jupyter': ['*.ipynb', '*.jpynb'],
      \ 'log': ['*.log'],
      \ 'lua': ['*.lua'],
      \ 'make': ['*.mak', '*.mk', '[Gg][Nn][Uu]makefile', '[Gg][Nn][Uu]makefile.am', '[Gg][Nn][Uu]makefile.in', '[Mm]akefile', '[Mm]akefile.am', '[Mm]akefile.in'],
      \ 'man': ['*.[0-9][cEFMmpSx]', '*.[0-9lnpx]'],
      \ 'markdown': ['*.markdown', '*.md', '*.mdown', '*.mdwn', '*.mdx', '*.mkd', '*.mkdn'],
      \ 'md': ['*.markdown', '*.md', '*.mdown', '*.mdwn', '*.mdx', '*.mkd', '*.mkdn'],
      \ 'pod': ['*.pod'],
      \ 'protobuf': ['*.proto'],
      \ 'py': ['*.py', '*.pyi'],
      \ 'python': ['*.py', '*.pyi'],
      \ 'rdoc': ['*.rdoc'],
      \ 'readme': ['*README', 'README*'],
      \ 'ruby': ['*.gemspec', '*.rb', '*.rbw', '.irbrc', 'Gemfile', 'Rakefile', 'config.ru'],
      \ 'rust': ['*.rs'],
      \ 'sass': ['*.sass', '*.scss'],
      \ 'sh': ['*.bash', '*.bashrc', '*.csh', '*.cshrc', '*.ksh', '*.kshrc', '*.sh', '*.tcsh', '*.zsh', '.bash_login', '.bash_logout', '.bash_profile', '.bashrc', '.cshrc', '.kshrc', '.login', '.logout', '.profile', '.tcshrc', '.zlogin', '.zlogout', '.zprofile', '.zshenv', '.zshrc', 'bash_login', 'bash_logout', 'bash_profile', 'bashrc', 'profile', 'zlogin', 'zlogout', 'zprofile', 'zshenv', 'zshrc'],
      \ 'slim': ['*.skim', '*.slim', '*.slime'],
      \ 'sql': ['*.psql', '*.sql'],
      \ 'svelte': ['*.svelte'],
      \ 'svg': ['*.svg'],
      \ 'tf': ['*.auto.tfvars', '*.auto.tfvars.json', '*.terraform.lock.hcl', '*.terraformrc', '*.tf', '*.tf.json', '*.tfrc', 'terraform.rc', 'terraform.tfvars', 'terraform.tfvars.json'],
      \ 'toml': ['*.toml', 'Cargo.lock'],
      \ 'ts': ['*.cts', '*.mts', '*.ts', '*.tsx'],
      \ 'txt': ['*.txt'],
      \ 'typescript': ['*.cts', '*.mts', '*.ts', '*.tsx'],
      \ 'v': ['*.v', '*.vsh'],
      \ 'vim': ['*.vim', '.gvimrc', '.vimrc', '_gvimrc', '_vimrc', 'gvimrc', 'vimrc'],
      \ 'vimscript': ['*.vim', '.gvimrc', '.vimrc', '_gvimrc', '_vimrc', 'gvimrc', 'vimrc'],
      \ 'vue': ['*.vue'],
      \ 'xml': ['*.dtd', '*.rng', '*.sch', '*.xhtml', '*.xjb', '*.xml', '*.xml.dist', '*.xsd', '*.xsl', '*.xslt'],
      \ 'yacc': ['*.y'],
      \ 'yaml': ['*.yaml', '*.yml'],
      \ 'zig': ['*.zig'],
      \ 'zsh': ['*.zsh', '.zlogin', '.zlogout', '.zprofile', '.zshenv', '.zshrc', 'zlogin', 'zlogout', 'zprofile', 'zshenv', 'zshrc'],
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

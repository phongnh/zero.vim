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
            \ 'groovy': ['*.gradle', '*.groovy'],
            \ 'h': ['*.h', '*.hh', '*.hpp'],
            \ 'haml': ['*.haml'],
            \ 'html': ['*.ejs', '*.htm', '*.html'],
            \ 'js': ['*.cjs', '*.js', '*.jsx', '*.mjs', '*.vue'],
            \ 'json': ['*.json', '*.sarif', 'composer.lock'],
            \ 'jsonl': ['*.jsonl'],
            \ 'jupyter': ['*.ipynb', '*.jpynb'],
            \ 'log': ['*.log'],
            \ 'lua': ['*.lua'],
            \ 'make': ['*.mak', '*.mk', 'Makefile.*', '[Gg][Nn][Uu]makefile', '[Gg][Nn][Uu]makefile.am', '[Gg][Nn][Uu]makefile.in', '[Mm]akefile', '[Mm]akefile.am', '[Mm]akefile.in'],
            \ 'man': ['*.[0-9][cEFMmpSx]', '*.[0-9lnpx]'],
            \ 'markdown': ['*.markdown', '*.md', '*.mdown', '*.mdwn', '*.mdx', '*.mkd', '*.mkdn'],
            \ 'md': ['*.markdown', '*.md', '*.mdown', '*.mdwn', '*.mdx', '*.mkd', '*.mkdn'],
            \ 'pod': ['*.pod'],
            \ 'protobuf': ['*.proto'],
            \ 'py': ['*.py', '*.pyi'],
            \ 'python': ['*.py', '*.pyi'],
            \ 'rdoc': ['*.rdoc'],
            \ 'readme': ['*README', 'README*'],
            \ 'ruby': ['*.gemspec', '*.rake', '*.rb', '*.rbw', '.irbrc', 'Gemfile', 'Rakefile', 'config.ru'],
            \ 'rust': ['*.rs'],
            \ 'sass': ['*.sass', '*.scss'],
            \ 'sh': ['*.bash', '*.bashrc', '*.csh', '*.cshrc', '*.env', '*.ksh', '*.kshrc', '*.sh', '*.tcsh', '*.zsh', '.bash_login', '.bash_logout', '.bash_profile', '.bashrc', '.cshrc', '.env', '.kshrc', '.login', '.logout', '.profile', '.tcshrc', '.zlogin', '.zlogout', '.zprofile', '.zshenv', '.zshrc', 'bash_login', 'bash_logout', 'bash_profile', 'bashrc', 'profile', 'zlogin', 'zlogout', 'zprofile', 'zshenv', 'zshrc'],
            \ 'slim': ['*.skim', '*.slim', '*.slime'],
            \ 'sql': ['*.psql', '*.sql'],
            \ 'svelte': ['*.svelte', '*.svelte.ts'],
            \ 'svg': ['*.svg'],
            \ 'tf': ['*.terraform.lock.hcl', '*.terraformrc', '*.tf', '*.tf.json', '*.tfrc', '*.tfvars', '*.tfvars.json', 'terraform.rc'],
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
    let l:opts = []
    let l:ft = get(a:, 1, &filetype !=# '' ? &filetype : &buftype)
    let l:ft = get(s:rg_filetype_mappings, l:ft, l:ft)
    if strlen(l:ft) && has_key(s:rg_filetypes, l:ft)
        call add(l:opts, '-t ' .. l:ft)
    else
        let l:ext = expand('%:e')
        if strlen(l:ext)
            call add(l:opts, '-g ' .. shellescape(printf('*.{%s}', l:ext)))
        endif
    endif
    return l:opts
endfunction

function! s:RgOpts(keyword) abort
    let l:opts = zero#filetype#RgFileTypeOpts()
    call add(l:opts, shellescape(a:keyword))
    return join(l:opts, ' ')
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
    let l:opts = []
    let l:ft = get(a:, 1, &filetype !=# '' ? &filetype : &buftype)
    let l:ft = get(s:rg_filetype_mappings, l:ft, l:ft)
    if strlen(l:ft) && has_key(s:rg_filetypes, l:ft)
        call add(l:opts, '--')
        for l:ext in s:rg_filetypes[l:ft]
            call add(l:opts, shellescape(l:ext))
        endfor
    else
        let l:ext = expand('%:e')
        if strlen(l:ext)
            call add(l:opts, '--')
            call add(l:opts, shellescape(printf('*.{%s}', l:ext)))
        endif
    endif
    return l:opts
endfunction

function! s:GitOpts(keyword) abort
    let l:opts = [shellescape(a:keyword)]
    call extend(l:opts, zero#filetype#GitFileTypeOpts())
    return join(l:opts, ' ')
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

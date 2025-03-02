if exists('+omnifunc') && &omnifunc ==# 'syntaxcomplete#Complete'
    setlocal omnifunc=
endif

command! -buffer ConvertRubyHashSyntax :%s/:\([^ ]*\)\(\s*\)=>/\1:/gc

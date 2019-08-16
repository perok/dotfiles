" Autowrap text when over tw.
setlocal formatoptions+=t
setlocal spell
" TODO move this to syntax/tex.vim. Does noe need au
" fix for spell in tex
autocmd FileType plaintex,tex,latex syntax spell toplevel
" syn sync maxlines=2000
" syn sync minlines=500

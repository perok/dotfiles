" Based on http://dougblack.io/words/a-good-vimrc.html
" Other tips from https://github.com/euclio/vimrc/blob/master/vimrc

" TODO {{{
    " https://github.com/mbbill/undotree
    " Base16 theme .XResources, ranger, vim, zsh?
    " nerdcomment
    " fzf
    " XDG variables not set
" }}}

" Core {{{
" Use utf-8 everywhere
if !has('nvim')
    set encoding=utf8
else
    " Allow the neovim Python plugin to work inside a virtualenv, by manually
    " specifying the path to python2. This variable must be set before any calls to
    " `has('python')`.
    let g:python_host_prog='/usr/bin/python2'
endif

" Leader shortcuts
let g:mapleader=","       " leader is comma
" }}}

" Plugins {{{
"auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('$HOME/.config/nvim/plugged')

" Syntax checking
Plug 'benekastah/neomake'
augroup plugin_neomake
    autocmd!
    autocmd bufwritepost * Neomake
augroup END

" The Silver searcher
Plug 'rking/ag.vim'
Plug 'kien/ctrlp.vim'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

" Git plugins
Plug 'airblade/vim-gitgutter'   " Show line status in gutter
Plug 'tpope/vim-fugitive'

Plug 'scrooloose/nerdtree' ", { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'bling/vim-airline'

" Colorschemes
Plug 'morhetz/gruvbox'

" Clojure/script/ plugins
Plug 'tpope/vim-salve' " Leiningen
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" Multiple file types
Plug 'kovisoft/paredit', { 'for': ['clojure', 'scheme'] }
Plug 'junegunn/rainbow_parentheses.vim'
" Activation based on file type
augroup plugin_rainbow_lisp
    autocmd!
    autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END

" Plug 'airodactyl/neovim-ranger'
" nnoremap <f9> :tabe %:p:h<cr>
call plug#end()
" }}}

" Plugin settings {{{
"   Ctrl-p settings {{{
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""' " Use silver searcher

" ,b is buffer
nnoremap <leader>b :CtrlPBuffer<CR>
"   }}}

"   Nerdtree {{{
" Start automatically if no files are specified
"if exists("b:NERDTree")
augroup nerdtree
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

    " If only nerdtree is open, then close will exit vim
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
augroup END

" Toggle with Ctrl-n
map <C-n> :NERDTreeToggle<CR>
"   }}}

"   Airline {{{
" Do not show default mode in statusline
set noshowmode

" Display buffers when one window open
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
"   }}}
" }}}

" Colors {{{
" Enable true color
if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

syntax enable           " enable syntax processing

set background=dark

"colorscheme badwolf         " awesome colorscheme
if has('vim_starting')
    colorscheme gruvbox
endif
" }}}

" Autocmd {{{
"if has("autocmd")
augroup vimrc
    autocmd!

    " File types highlighting
    autocmd BufRead,BufNewFile *.cl setfiletype c " OpenCL kernels

    " Set cursor to last place when reopening file
    autocmd BufReadPost * 
                \ if line("'\"") > 1 && line("'\"") <= line("$") | 
                \   exe "normal! g'\"" | 
                \ endif

    " Do not use relativenumber in insert mode
    autocmd InsertEnter * set norelativenumber
    autocmd InsertLeave * set relativenumber

    " Do not use relative number when focus is lost
    " TODO not working in neovim
    autocmd FocusLost   * set norelativenumber
    autocmd FocusGained * set relativenumber

augroup END
" }}}

" Shortcuts/Movement {{{
" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move to beginning/end of line
nnoremap B ^
nnoremap E $
" $/^ doesn't do anything
"nnoremap $ <nop>
"nnoremap ^ <nop>

" highlight last inserted text
nnoremap gV `[v`]

" jk is escape
inoremap jk <esc>

" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" save session (,s). Open again with vim -S
nnoremap <leader>s :mksession<CR>

" w!! saves the file as sudo
cmap w!! w !sudo tee % >/dev/null

" Keep selection when indenting
vnoremap < <gv
vnoremap > >gv

" Moving lines and selections with Ctrl-J and K
nnoremap <c-k> :m-2<cr>==
nnoremap <c-j> :m+<cr>==
inoremap <c-j> <esc>:m+<cr>==gi
inoremap <c-k> <esc>:m-2<cr>==gi
vnoremap <c-j> :m'>+<cr>gv=gv
vnoremap <c-k> :m-2<cr>gv=gv

" alt+{h,j,k,l}  window navigation
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
" }}}

" Spaces and tabs {{{
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set shiftwidth=4    " Make sure >> indents 1 tab
" }}}

" UI/Window {{{
if !has('nvim')
    set wildmenu            " visual autocomplete for command menu
endif
set number              " show line numbers
set relativenumber      " show relative numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
"Ignore these files when completing names and in Explorer
set wildignore+=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set breakindent         " Keep indent level when wrappping line
set textwidth=80 colorcolumn=+1     " Color column at word 80

" t - autowrap to textwidth
" c - autowrap comments to textwidth
" r - autoinsert comment leader with <Enter>
" q - allow formatting of comments with :gq
" l - don't format already long lines
" default: tcqj old -y+t
set formatoptions=cqjr

" Show arrows when there are long lines, and show · for trailing space
set list listchars=tab:»·,trail:·,precedes:←,extends:→

" Vertical and horizontal split lines for unicode
set fillchars=vert:│,fold:-

" Highlight colors are thin lines
highlight VertSplit cterm=none ctermbg=none ctermfg=247

" Ensure that the cursor is at least 5 lines above bottom
set scrolloff=5

" Custom title in terminal
let &titlestring=hostname() . ' : %F %r: NVIM %m'
set title

" Disable visual and audio bell
set noerrorbells visualbell t_vb=

" Window splitting
set splitbelow
set splitright
" }}}

" Searching {{{
if !has('nvim')
    set incsearch           " search as characters are entered
    set hlsearch            " highlight matches
endif
set ignorecase
set smartcase

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>
" }}}

" Folding {{{
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
" space open/closes folds
" TODO collision with space?
nnoremap <space> za
set foldmethod=indent   " fold based on indent level
" }}}

" Backups {{{
set backup
" default ".,$XDG_DATA_HOME/nvim/backup"
set backupdir +=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip+=/private/tmp/*
" default "$XDG_DATA_HOME/nvim/swap//"
set directory +=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup
" }}}

" Functions {{{
" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" TODO this is not called..?
" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

" http://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save
" Make new directory where file is? 
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction

" Autocreate directories that does not exist when saving?
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
" }}}

" Terminal {{{
if has('nvim')
    set sh=zsh

    augroup nvim_term
        autocmd!
        " Start in insert mode
        autocmd BufWinEnter,WinEnter term://* startinsert
    augroup END

    ":tnoremap <Esc> <C-\><C-n>
    tnoremap jk <C-\><C-n>
    " alt+{hjkl} window control for terminal aswell
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l

    " gruvbox terminal color scheme
    let g:terminal_color_0="#282828"
    let g:terminal_color_1="#cc241d"
    let g:terminal_color_2="#98971a"
    let g:terminal_color_3="#d79921"
    let g:terminal_color_4="#458588"
    let g:terminal_color_5="#b16286"
    let g:terminal_color_6="#689d6a"
    let g:terminal_color_7="#a89984"
    let g:terminal_color_8="#928374"
    let g:terminal_color_9="#fb4934"
    let g:terminal_color_10="#b8bb26"
    let g:terminal_color_11="#fabd2f"
    let g:terminal_color_12="#83a598"
    let g:terminal_color_13="#d3869b"
    let g:terminal_color_14="#8ec07c"
    let g:terminal_color_15="#ebdbb2"
    let g:terminal_color_background="#282828"
    let g:terminal_color_foreground="#ebdbb2"
endif
" }}}

set modelines=1         " Let vim look for settings on last line
" vim:foldmethod=marker:foldlevel=0

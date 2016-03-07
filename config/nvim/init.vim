" Based on http://dougblack.io/words/a-good-vimrc.html
" Other tips from https://github.com/euclio/vimrc/blob/master/vimrc

" Enable all py highlighting????
"autocmd BufRead,BufNewFile *.py let python_highlight_all=1
let python_highlight_all = 1

" TODO {{{
    " Base16 theme .XResources, ranger, vim, zsh?
    " XDG variables not set
    "let g:python3_host_prog = '/path/to/python3'
    " unimpaired - bunch of useful mappings on ] and [
    " repeat - . them all!
    " projectionist - jump all over the project with ease
    " targets - more useful movements
    " swapit - ^a/^x on steroids (mostly used for true/false switch)
    " Lightline?
    " https://github.com/carlitux/deoplete-ternjs
" }}}

" Core {{{
if !has('nvim') && has('vim_starting')
    " Use utf-8 everywhere
    set encoding=utf8
else
    " Allow the neovim Python plugin to work inside a virtualenv, by manually
    " specifying the path to python2. This variable must be set before any calls to
    " `has('python')`.
    "let g:python_host_prog='/usr/bin/python2'
    "let g:python_host_prog3='/usr/bin/python3'
endif

" Leader is space
nmap <space> <leader>

" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
" }}}

" Plugins {{{
call plug#begin()

Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'justinmk/vim-dirvish'
" {{{
let g:dirvish_hijack_netrw = 1
augroup plugin_dirvish
    autocmd!
    autocmd FileType dirvish call fugitive#detect(@%)
augroup END
" }}}
Plug 'easymotion/vim-easymotion'
" {{{
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1  " Turn on case insensitive feature
let g:EasyMotion_startofline = 0    " keep cursor column when JK motion
nmap s <Plug>(easymotion-s)
" JK motions: Line motions
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
" }}}

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
" {{{
nnoremap <F6> :UndotreeToggle<cr>
if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif
" }}}

" Syntax checking
Plug 'benekastah/neomake'
" {{{
let g:neomake_javascript_enabled_makers = ['eslint']
" Override eslint with local version where necessary.
let local_eslint = finddir('node_modules', '.;') . '/.bin/eslint'
if matchstr(local_eslint, "^\/\\w") == ''
    let local_eslint = getcwd() . "/" . local_eslint
endif
if executable(local_eslint)
    let g:syntastic_javascript_eslint_exec = local_eslint
endif

augroup plugin_neomake
    autocmd!
    autocmd bufwritepost * Neomake
augroup END
" }}}

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" {{{
let g:fzf_command_prefix = 'Fzf'
function! s:find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

" If in git repo, go to root of repo and use fzf there
command! ProjectFiles execute 'Files' s:find_git_root()

nnoremap <C-p> :FZF<CR>
nnoremap <silent> <leader>b :FzfBuffers<CR>
nnoremap <silent> <leader>m :FzfHistory<CR>
nnoremap <silent> <leader>; :FzfBLines<CR>
nnoremap <silent> <leader>. :FzfLines<CR>
"nnoremap <silent> <leader>gl :Commits<CR>
"nnoremap <silent> <leader>ga :BCommits<CR>
"nmap <leader><tab> <plug>(fzf-maps-n)
"xmap <leader><tab> <plug>(fzf-maps-x)
"omap <leader><tab> <plug>(fzf-maps-o)

" Better command history with q:
command! CmdHist call fzf#vim#command_history({'right': '40'})
nnoremap q: :CmdHist<CR>

" Better search history
command! QHist call fzf#vim#search_history({'right': '40'})
nnoremap q/ :QHist<CR>
" }}}

" Omnicompletion
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'Shougo/deoplete.nvim'
" {{{
let g:deoplete#enable_at_startup = 1
" }}}

Plug 'airblade/vim-gitgutter'   " Show line status in gutter
" {{{
" Always display gitgutter column
let g:gitgutter_sign_column_always=1
" }}}

Plug 'nathanaelkane/vim-indent-guides'
" {{{
let g:indent_guides_start_level = 2
" }}}

" Colorschemes
Plug 'morhetz/gruvbox'

" Clojure/script/ plugins
Plug 'tpope/vim-salve' " Leiningen
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Multiple file types
Plug 'kovisoft/paredit', { 'for': ['clojure', 'scheme'] }
Plug 'junegunn/rainbow_parentheses.vim'
" {{{
augroup plugin_rainbow_lisp
    autocmd!
    autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END
" }}}

" Javascript
" http://davidosomething.com/blog/vim-for-javascript/
Plug 'othree/yajs.vim', { 'for': 'javascript' } " JS syntax
Plug 'itspriddle/vim-javascript-indent', { 'for': 'javascript' } " JS indent
Plug 'mxw/vim-jsx', { 'for': 'javascript' }
" {{{
let g:jsx_ext_required = 0 " Allow JSX in normal JS files
" }}}
Plug 'elzr/vim-json', { 'for': 'json' }

" Python
let g:nvim_ipy_perform_mappings = 0
Plug 'bfredl/nvim-ipy' , { 'on': 'IPython' }

" Plug 'airodactyl/neovim-ranger'
" nnoremap <f9> :tabe %:p:h<cr>
call plug#end()
" }}}

" Colors {{{
syntax enable           " enable syntax processing

set background=dark

if has('vim_starting')
    "colorscheme ps_color
    colorscheme gruvbox
endif
" }}}

" General  {{{
let g:tex_flavor = "latex"
" }}}

" Autocmd {{{
augroup vimrc
    autocmd!

    " File types highlighting
    autocmd BufRead,BufNewFile *.cl setfiletype c " OpenCL kernels

    " run python
    autocmd BufRead *.py set makeprg=clear;python2.7\ %
    autocmd BufRead *.py set autowrite

    " run node.js
    autocmd BufRead *.js set makeprg=clear;node\ %
    autocmd BufRead *.js set autowrite

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
    "autocmd FocusLost   * set norelativenumber
    "autocmd FocusGained * set relativenumber

    " Resize splits when the window is resized.
    autocmd VimResized * exe "normal! \<c-w>="

    " Normalize: Strip trailing whitespace.
    autocmd BufWritePre * :%s/\s\+$//e

    " http://www.vimbits.com/bits/229
    autocmd BufRead COMMIT_EDITMSG setlocal spell!
augroup END
" }}}

" Shortcuts/Movement {{{
" jk is escape
inoremap jk <esc>

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" highlight last inserted text
nnoremap gV `[v`]

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

" window navigation alt+{h,j,k,l}
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Window resizing
nmap <left>  :3wincmd <<cr>
nmap <right> :3wincmd ><cr>
nmap <up>    :3wincmd +<cr>
nmap <down>  :3wincmd -<cr>

" Allow saving files with as root
cmap w!! SudoWrite

" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" save session (,s). Open again with vim -S
nnoremap <leader>s :mksession<CR>

" set paste mode
set pastetoggle=<F2>

" make F5 compile
map <F5> :make!<cr>
" }}}

" Tab Navigation {{{
map <Leader>tt :tabnew<CR>
map <Leader>tc :tabclose<CR>
noremap <Leader>tm :tabmove<CR>
noremap <Leader>tn :tabnext<CR>
noremap <Leader>tp :tabprevious<CR>
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
set wildignore+=.svn,.hg,.git
set wildignore+=*.o,*.a,*.class,*.so,*.obj,*.pyc
set wildignore+=*.jpg,*.png,*.xpm,*.gif,*.bmp,*.jpeg
set wildignore+=*~,#*#,*.sw?,%*,*=
set wildignore+=*node_modules*

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

" Set minheight of window and current to sane value
"set winheight=30
"set winminheight=5
" }}}

" Statusline {{{
"set noshowmode            " Do not show default mode in statusline

set statusline=%{fugitive#statusline()} " Git status
set statusline+=%m%r%w%{HasPaste()}   " File flags
set statusline+=\ %f      " Path to the file
set statusline+=%=        " Switch to the right side
set statusline+=%l/%L     " Current line / total lines
set statusline+=\ %y      " Filetype
" }}}

" Searching {{{
if !has('nvim')
    set incsearch           " search as characters are entered
    set hlsearch            " highlight matches
endif
set smartcase

" turn off search highlight
nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>
" }}}

" Folding {{{
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
" space open/closes folds
" TODO
"nnoremap <space> za
set foldmethod=indent   " fold based on indent level
" }}}

" Backups {{{
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowritebackup
set noswapfile

"set backup
" default ".,$XDG_DATA_HOME/nvim/backup"
"set backupdir +=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
"set backupskip+=/private/tmp/*
" default "$XDG_DATA_HOME/nvim/swap//"
"set directory +=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
"set writebackup
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

" EX | chmod +x
command! EX if !empty(expand('%'))
         \|   write
         \|   call system('chmod +x '.expand('%'))
         \| else
         \|   echohl WarningMsg
         \|   echo 'Save the file first'
         \|   echohl None
         \| endif

function! HasPaste()
    if &paste
        return '[PASTE MODE]'
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction
" }}}

" Terminal {{{
if has('nvim')
    set sh=zsh

    command! VsTerm  vsplit  | terminal
    command! STerm   split   | terminal
    command! TabTerm tabedit | terminal

    nnoremap <silent> <leader>st :STerm<CR>

    augroup nvim_term
        autocmd!
        " Start in insert mode
        autocmd BufWinEnter,WinEnter term://* startinsert
    augroup END

    "tnoremap <Esc> <C-\><C-n> TODO disabled because of fzf problems
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

    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
    " Use a blinking upright bar cursor in Insert mode, a solid block in normal and a blinking underline in replace mode
    " TODO not working
    " https://github.com/neovim/neovim/issues/2583
    "let &t_SI = "\<Esc>[5 q"
    "let &t_SR = "\<Esc>[3 q"
    "let &t_EI = "\<Esc>[2 q"
endif
" }}}

set modelines=1         " Let vim look for settings on last line
" vim:foldmethod=marker:foldlevel=0

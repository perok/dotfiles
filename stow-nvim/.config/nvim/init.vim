" Based on http://dougblack.io/words/a-good-vimrc.html
" Other tips from https://github.com/euclio/vimrc/blob/master/vimrc
" set guicursor=a:block-blinkon0
"set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
" TODO Cause of random q's popping up
set guicursor=
au VimLeave * set guicursor=a:block-blinkon0

set mouse=n  " Mouse support in normal mode


" TODO {{{
    " Base16 theme .XResources, ranger, vim, zsh?
    " swapit - ^a/^x on steroids (mostly used for true/false switch)
    " https://github.com/critiqjo/vim-bufferline
" }}}

" Core {{{
let g:python3_host_prog = "/usr/bin/python3"

if !has('nvim') && has('vim_starting')
    " Use utf-8 everywhere
    set encoding=utf8
endif

" Leader is space
let g:mapleader="\<space>"
let g:maplocalleader=","
" }}}

" Plugins {{{
lua require('plugins')

" vim-which-key {{{
set timeoutlen=500 " Default timeout is 1000ms
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
call which_key#register('<Space>', 'g:which_key_map')
let g:which_key_map =  {}

" Hide status line when WhichKey is active
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
" }}}

let g:startify_custom_header = []
let g:startify_change_to_dir = 0
" let g:startify_change_to_vcs_root = 1

" Trick from
" https://github.com/justinmk/vim-dirvish/issues/70#issuecomment-626258095

" Dirvish {{{
" Replace netrw
let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>

" Use t in dirvish to show subdirectories
" Trick from https://github.com/justinmk/vim-dirvish/issues/70#issuecomment-626258095
augroup dirvish_config
    autocmd!
    autocmd FileType dirvish
            \ nnoremap <silent><buffer> t ddO<Esc>:let @"=substitute(@", '\n', '', 'g')<CR>:r ! find "<C-R>"" -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d<CR>:noh<CR>

augroup END
" }}}
" vim-sneak {{{
" Move around with s{char}{char}

let g:sneak#label = 1 " label mode to imitate vim-easymotion

" Use sneak over standard mappings
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
" }}}

" Undotree {{{
nnoremap <F6> :UndotreeToggle<cr>
if has("persistent_undo")
    set undofile
    set undodir=~/.undodir/
endif
" }}}

" Syntax checking
" ALE {{{
" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1
" Available linters https://github.com/dense-analysis/ale/tree/master/ale_linters
let g:ale_linters = {
\   'sh': ['shellcheck', 'shell'],
\}
" }}}

" For markdown
" https://github.com/iamcco/markdown-preview.nvim ?
" Do not add extra keyboard mappings
let g:pandoc#keyboard#use_default_mappings = 0

" Read: https://github.com/junegunn/fzf/blob/master/README-VIM.md

" FzF {{{
let g:fzf_command_prefix = 'Fzf'
function! s:find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

" If in git repo, go to root of repo and use fzf there
command! ProjectFiles execute 'Files' s:find_git_root()

nnoremap <C-p> :FzfFiles<CR>
nnoremap <silent> <leader>b :FzfBuffers<CR>
nnoremap <silent> <leader>m :FzfHistory<CR>
nnoremap <silent> <leader>; :FzfBLines<CR>
nnoremap <silent> <leader>. :FzfLines<CR>
"nnoremap <silent> <leader>gl :Commits<CR>
"nnoremap <silent> <leader>ga :BCommits<CR>
"nmap <leader><tab> <plug>(fzf-maps-n)
"xmap <leader><tab> <plug>(fzf-maps-x)
"omap <leader><tab> <plug>(fzf-maps-o)

" TODO FzfHistory sorted by oldfiles?
command! FzfMru call fzf#run(fzf#wrap({
\  'source':  v:oldfiles,
\ }))

" Delegate everything to Ripgrep (not fuzzy search over first result)
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Enable per-command history
" - History files will be stored in the specified directory
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Better command history with q:
command! CmdHist call fzf#vim#command_history({'right': '40'})
nnoremap q: :CmdHist<CR>

" Better search history
command! QHist call fzf#vim#search_history({'right': '40'})
nnoremap q/ :QHist<CR>

" let g:fzf_files_options =
"   \ '--preview "(highlight -O ansi {} || cat {}) 2> /dev/null | head -'.&lines.'"'

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
" }}}

command! Ranger FloatermNew ranger

" Omnicompletion

" GitGutter {{{
" Always display gitgutter column
let g:gitgutter_map_keys = 0 " Activate stuff when I need it..
" Might cause perf issues? https://github.com/neovim/neovim/issues/12587
set updatetime=100 " Reduce time for CursorHold events
" }}}

" Indent guides {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['help', 'startify']
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
" }}}

let g:vista_default_executive = 'nvim_lsp'
nmap <F8> :Vista nvim_lsp<CR>
"TODO Vista finder nvim_lsp -> nvim-telescope
" }}}

" LSP: Language Server Protocol {{{
" nvim-compe {{{
set completeopt=menu,menuone,noselect

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.spell = v:true
let g:compe.source.tags = v:true
let g:compe.source.snippets_nvim = v:true
let g:compe.source.treesitter = v:true

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Decoration color. Available options shown by :highlights
" let g:metals_decoration_color = 'Conceal'
" }}}
" }}}

" Extra plugin configuration {{{
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'scala', 'html', 'javascript', 'yaml', 'css', 'lua', 'json', 'elm', 'bash'},
  highlight = {
    enable = true
  }
}
EOF

call sign_define("LspDiagnosticsSignError", {"text" : "✘", "texthl" : "LspDiagnosticsDefaultError"})
call sign_define("LspDiagnosticsSignWarning", {"text" : "", "texthl" : "LspDiagnosticsDefaultWarning"})

" Needed for symbol highlights to work correctly (source: nvim_metals)
hi! link LspReferenceText CursorColumn
hi! link LspReferenceRead CursorColumn
hi! link LspReferenceWrite CursorColumn

lua << EOF
  local shared_diagnostic_settings = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                                                  {virtual_text = {prefix = '', truncated = true}})
  local lsp_config = require'lspconfig'
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true


  lsp_config.util.default_config = vim.tbl_extend('force', lsp_config.util.default_config, {
    handlers = {['textDocument/publishDiagnostics'] = shared_diagnostic_settings},
    capabilities = capabilities
  })

  lsp_config.vimls.setup {}
  lsp_config.elmls.setup {}
  lsp_config.dockerls.setup {}
  lsp_config.cssls.setup {}
  lsp_config.yamlls.setup {}
  lsp_config.html.setup {}

  metals_config = require'metals'.bare_config
  metals_config.settings = {
    showImplicitArguments = true
  }

  -- Enables `metals#status()`
  metals_config.init_options.statusBarProvider = 'on'
  metals_config.handlers['textDocument/publishDiagnostics'] = shared_diagnostic_settings
  metals_config.capabilities = capabilities
EOF

augroup lsp
  au!
  au FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)
  autocmd Filetype scala,elm,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd BufWritePre *.scala,*.sbt,*.elm lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup end


nnoremap <nowait> <silent> <leader>g  <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K           <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
" Here is an example of how to use telescope as an alternative to the default references
" TODO add telescope? https://github.com/nvim-lua/telescope.nvim
" nnoremap <silent> <leader>s   <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
nnoremap <silent> gds         <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gws         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>rn  <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>f   <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>ca  <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>ws  <cmd>lua require"metals".worksheet_hover()<CR>
nnoremap <silent> <leader>a   <cmd>lua require"metals".open_all_diagnostics()<CR>
" Buffer diagnostic only
nnoremap <silent> <leader>d   <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <silent> [c          <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>
nnoremap <silent> ]c          <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>
" }}}

" Colors {{{
syntax enable           " enable syntax processing

set background=dark
if has("termguicolors")
    set termguicolors   " enable true color support
endif

if has('vim_starting')
    "colorscheme gruvbox
    "let g:base16colorspace=256
    "colorscheme base16-ocean
    "colorscheme iceberg
    "let g:base16colorspace=256
    "colorscheme base16-ocean
    " colorscheme twilight
    colorscheme OceanicNext
endif


" From base16-nvim
" let g:base16_transparent_background = 1
"let g:base16_airline=1
" }}}

" General  {{{
let g:tex_flavor = "latex"

set hidden  " Allow buffer to not be saved
" }}}

" Autocmd {{{
augroup vimrc
    autocmd!

    " Set cursor to last place when reopening file
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g'\"" |
                \ endif

    " Do not use relativenumber in insert mode
    " TODO disable when in term
    autocmd InsertEnter * set norelativenumber
    autocmd InsertLeave * set relativenumber
    " TODO when entering Term. Disable all number showing

    " Do not use relative number when focus is lost
    " TODO not working in neovim
    "autocmd FocusLost   * set norelativenumber
    "autocmd FocusGained * set relativenumber

    " Resize splits when the window is resized.
    autocmd VimResized * exe "normal! \<c-w>="

    " Strip trailing whitespace.
    fun! TrimWhitespace() " {{{
        let l:save = winsaveview()
        %s/\s\+$//e
        call winrestview(l:save)
    endfun " }}}
    autocmd BufWritePre * :call TrimWhitespace()

    " http://www.vimbits.com/bits/229
    autocmd BufRead COMMIT_EDITMSG setlocal spell!
augroup END
" }}}

" Shortcuts/Movement {{{
" jk is escape
inoremap jk <esc>

" Yank to end of line
nnoremap Y y$
" Move from position to $ one line down
" nnoremap K i<CR><Esc>d^==kg_lD
" TODO above crashed with metals mapping

" move vertically by visual line
" https://stackoverflow.com/questions/20975928/moving-the-cursor-through-long-soft-wrapped-lines-in-vim/21000307#21000307
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" Quickly select the text that was just pasted. This allows you to, e.g.,
" indent it after pasting.
nnoremap gV `[v`]

" Keep selection when indenting
vnoremap < <gv
vnoremap > >gv

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Use | and _ to split windows (while preserving original behaviour of [count]bar and [count]_).
nnoremap <expr><silent> <Bar> v:count == 0 ? "<C-W>v<C-W><Right>" : ":<C-U>normal! 0".v:count."<Bar><CR>"
nnoremap <expr><silent> _     v:count == 0 ? "<C-W>s<C-W><Down>"  : ":<C-U>normal! ".v:count."_<CR>"

" Moving lines and selections with Ctrl-J and K
nnoremap <c-k> :m-2<cr>==
nnoremap <c-j> :m+<cr>==
inoremap <c-j> <esc>:m+<cr>==gi
inoremap <c-k> <esc>:m-2<cr>==gi
vnoremap <c-j> :m'>+<cr>gv=gv
vnoremap <c-k> :m-2<cr>gv=gv

" window navigation alt+{h,j,k,l}
" TODO does these work?
" '<M-...>' Alt-key or meta-key
" This? https://vi.stackexchange.com/questions/2350/how-to-map-alt-key
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Window resizing
nmap <left>  :3wincmd ><cr>
nmap <right> :3wincmd <<cr>
nmap <up>    :3wincmd +<cr>
nmap <down>  :3wincmd -<cr>

" Allow saving files with as root
cmap w!! SudoWrite

fu! OpenInSplitIfBufferDirty(file)
    if line('$') == 1 && getline(1) == ''
        exec 'e' a:file
    else
        exec 'vsp' a:file
    endif
endfu
" command -nargs=1 -complete=file -bar CleverOpen :call OpenInSplitIfBufferDirty(<q-args>)

" edit vimrc/zshrc and load vimrc bindings
nnoremap <silent> <leader>ev :call OpenInSplitIfBufferDirty($MYVIMRC)<cr>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" save session (,s). Open again with vim -S
nnoremap <leader>ss :mksession!<CR>

" Open spell dropdown window with <leader>s
nnoremap <leader>sc a<C-X><C-S>

" set paste mode
set pastetoggle=<F2>

" make F5 compile
map <F5> :make!<cr>

" Allow moving cursor outside existing text
set virtualedit=all
" }}}

" Tab Navigation {{{
map <Leader>tt :tabnew<CR>
map <Leader>tc :tabclose<CR>
noremap <Leader>tm :tabmove<CR>
noremap <Leader>tn :tabnext<CR>
noremap <Leader>tp :tabprevious<CR>
" }}}

" Spaces and tabs {{{
set tabstop=2       " number of visual spaces per TAB
set softtabstop=2   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set shiftwidth=2    " Make sure >> indents 1 tab
" }}}

" UI/Window {{{
if has('nvim')
    set inccommand=split    " visual substitution
else " Settings that are not default in vim
    set wildmenu            " visual autocomplete for command menu
endif

set signcolumn=yes      " Always show left vertical information line


set winblend=10         " Transparancy for wildmenu
set pumblend=10         " Transparancy for pum

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
set sidescroll=1        " Horizontally scroll 1 at a time
set breakindent         " Keep indent level when wrappping line
set textwidth=80        " Width of text for wrapping
let &colorcolumn=join(range(81,999),",") " Color column from 81 outwards
" let colorcolumn=+1      " TODO not working?

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
set noshowmode            " Do not show default mode in statusline

" set statusline=%{fugitive#statusline()} " Git status
" set statusline+=%m%r%w%{HasPaste()}   " File flags
" set statusline+=\ %f      " Path to the file
" set statusline+=%=        " Switch to the right side
" set statusline+=%l/%L     " Current line / total lines
" set statusline+=\ %y      " Filetype

  "\     [ 'lspErrors', 'lspWarnings' ]
let g:lightline = {
  \ 'colorscheme': 'nord',
  \ 'mode_map': { 'c': 'NORMAL' },
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste', 'lspMetalsStatus'],
  \     [ 'lspError', 'lspWarnings' ],
  \     [ 'fugitive', 'filename' ],
  \   ]
  \ },
  \ 'component_function': {
  \   'modified': 'LightLineModified',
  \   'readonly': 'LightLineReadonly',
  \   'fugitive': 'LightLineFugitive',
  \   'filename': 'LightLineFilename',
  \   'fileformat': 'LightLineFileformat',
  \   'filetype': 'LightLineFiletype',
  \   'fileencoding': 'LightLineFileencoding',
  \   'mode': 'LightLineMode',
  \   'lspError': 'LspErrors',
  \   'lspWarnings': 'LspWarnings',
  \   'lspMetalsStatus': 'LightLineMetalsStatus',
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' }
\ }

function! LightLineModified()
  return &ft =~ 'help\|startify' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help\|startify' && &readonly ? '' : ''
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ (&ft =~ 'dirvish\|startify' ? '' :
        \  '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  if &ft !~? 'help\|dirvish\|startify' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? ' '._ : ''
  endif
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

"-----------------------------------------------------------------------------
" LSP statusline
"-----------------------------------------------------------------------------
function! LspErrors() abort
  return metals#errors()
endfunction

" metals warnings and errors
function! LspWarnings() abort
  return metals#warnings()
endfunction

function! LightLineMetalsStatus()
  return metals#status()
endfunction
" }}}

" Searching {{{
if !has('nvim')
    set incsearch           " search as characters are entered
    set hlsearch            " highlight matches
endif
set smartcase

" turn off search highlight
nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>

" Use RipGrep for grepping. Respects gitignore, etc
set grepprg=rg\ -H\ --no-heading\ --vimgrep
" }}}

" Folding {{{
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
" shift tab open/closes folds
nnoremap <s-tab> za
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
function! ToggleNumber() " {{{
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc " }}}


" http://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save
" Make new directory where file is?
function! s:MkNonExDir(file, buf) " {{{
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction " }}}

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

function! HasPaste() " {{{
    if &paste
        return '[PASTE MODE]'
    en
    return ''
endfunction " }}}

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt() " {{{
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
endfunction " }}}
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
    "     " Start in insert mode
    "     autocmd BufWinEnter,WinEnter term://* startinsert
    " autocmd TermEnter * startinsert " TODO new?

    autocmd TermOpen * setlocal nonumber norelativenumber
    "
    " TODO THIS ALSO INFERS WITH FZF.VIM
        " autocmd TermClose * bd!|q " quit when a terminal closes instead of showing exit code and waiting
    augroup END

    " http://neovim.io/doc/user/nvim_terminal_emulator.html
    " TODO disabled because of fzf problems
    " tnoremap <Esc> <C-\><C-n>
    "tnoremap jk <C-\><C-n>

    " alt+{hjkl} window control for terminal aswell
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l

    " Use a blinking upright bar cursor in Insert mode, a solid block in normal and a blinking underline in replace mode
    " TODO not working
    " https://github.com/neovim/neovim/issues/2583
    "let &t_SI = "\<Esc>[5 q"
    "let &t_SR = "\<Esc>[3 q"
    "let &t_EI = "\<Esc>[2 q"
endif
" }}}

set modelines=1 " Let vim look for settings on last line
" vim:foldmethod=marker:foldlevel=0

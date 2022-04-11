" Based on http://dougblack.io/words/a-good-vimrc.html
" Other tips from https://github.com/euclio/vimrc/blob/master/vimrc
" set guicursor=a:block-blinkon0
"set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
" TODO Cause of random q's popping up
set guicursor=
au VimLeave * set guicursor=a:block-blinkon0

set mouse=n  " Mouse support in normal mode


" TODO {{{
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
" nvim-tree {{{
" TODO move to plugins when setting is available in lua
let g:nvim_tree_group_empty = 1
" }}}
"

augroup Packer
  autocmd!
  autocmd BufWritePost plugins.lua PackerCompile
augroup end
lua require('plugins')

" vim-which-key {{{
set timeoutlen=500 " Default timeout is 1000ms
" nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
" nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
" call which_key#register('<Space>', 'g:which_key_map')
" let g:which_key_map =  {}

" Hide status line when WhichKey is active
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
" TODO this is just an example
"let g:which_key_map['w'] = {
"      \ 'name' : '+windows' ,
"      \ 'w' : ['<C-W>w'     , 'other-window']          ,
"      \ 'd' : ['<C-W>c'     , 'delete-window']         ,
"      \ '-' : ['<C-W>s'     , 'split-window-below']    ,
"      \ '|' : ['<C-W>v'     , 'split-window-right']    ,
"      \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
"      \ 'h' : ['<C-W>h'     , 'window-left']           ,
"      \ 'j' : ['<C-W>j'     , 'window-below']          ,
"      \ 'l' : ['<C-W>l'     , 'window-right']          ,
"      \ 'k' : ['<C-W>k'     , 'window-up']             ,
"      \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
"      \ 'J' : [':resize +5'  , 'expand-window-below']   ,
"      \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
"      \ 'K' : [':resize -5'  , 'expand-window-up']      ,
"      \ '=' : ['<C-W>='     , 'balance-window']        ,
"      \ 's' : ['<C-W>s'     , 'split-window-below']    ,
"      \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
"      \ '?' : ['Windows'    , 'fzf-window']            ,
"      \ }
" }}}

let g:startify_custom_header = []
let g:startify_change_to_dir = 0
" let g:startify_change_to_vcs_root = 1

" Trick from
" https://github.com/justinmk/vim-dirvish/issues/70#issuecomment-626258095

" Dirvish {{{
" Replace netrw
let g:loaded_netrw = 1
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

" let g:sneak#label = 1 " label mode to imitate vim-easymotion

" Use sneak over standard mappings
" map f <Plug>Sneak_f
" map F <Plug>Sneak_F
" map t <Plug>Sneak_t
" map T <Plug>Sneak_T
" }}}
" Undotree {{{
nnoremap <F6> :UndotreeToggle<cr>
if has("persistent_undo")
    set undofile
    set undodir=~/.undodir/
endif
" }}}


" For markdown
" https://github.com/iamcco/markdown-preview.nvim ?
" Do not add extra keyboard mappings
let g:pandoc#keyboard#use_default_mappings = 0

" Telescope setup {{{

nnoremap <C-p> <cmd>Telescope find_files hidden=true<cr>
nnoremap <C-a> <cmd>Telescope commands<cr>

nnoremap <silent> <leader>b  <cmd>lua require('telescope.builtin').buffers()<CR>
lua << EOF
vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })
EOF
" }}}

command! Ranger FloatermNew ranger

" Omnicompletion

let g:vista_default_executive = 'nvim_lsp'
nmap <F8> :Vista nvim_lsp<CR>
"TODO Vista finder nvim_lsp -> nvim-telescope

" }}}

" LSP: Language Server Protocol {{{

" nvim-cmp {{{
set completeopt-=longest
" }}}

" Extra plugin configuration {{{
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'scala', 'html', 'javascript', 'yaml', 'css', 'lua', 'http', 'json', 'elm', 'bash', 'python', 'ruby'},
  highlight = {
    enable = true
  },
  -- To make use 'JoosepAlviste/nvim-ts-context-commentstring' work
  context_commentstring = {
    enable = true
  },
  rainbow = { -- For plugin 'p00f/nvim-ts-rainbow'
    enable = true,
    -- disable = { '' }, -- FT's
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true
  }
}
EOF


sign define DiagnosticSignError text=✘ texthl=DiagnosticSignError linehl=0 numhl=1
sign define DiagnosticSignWarn text= texthl=DiagnosticsSignWarn linehl=0 numhl=1

" Needed for symbol highlights to work correctly (source: nvim_metals)
hi! link LspReferenceText CursorColumn
hi! link LspReferenceRead CursorColumn
hi! link LspReferenceWrite CursorColumn

hi! link LspSagaFinderSelection CursorColumn

let g:cursorhold_updatetime = 100 " https://github.com/antoinemadec/FixCursorHold.nvim - for diagnostic_open
lua << EOF
  -- Diagnostics configuration
  vim.cmd([[au CursorHold,CursorHoldI * lua vim.diagnostic.open_float(0,{scope = "cursor"})]])
  vim.diagnostic.config({
    virtual_text = false,
    sign = true,
    -- update_in_insert = true,
    float = { border = "single" }
  })

  local opts = { noremap = true, silent = true }

  -- Diagnostic keymaps
  vim.api.nvim_set_keymap('n', '<leader>d', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.api.nvim_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
 -- " Buffer diagnostic only
 -- nnoremap <silent> <leader>d   <cmd>lua vim.diagnostic.setloclist()<CR>
 -- nnoremap <silent> ]e          <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
 -- nnoremap <silent> [e          <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>


  local flags = {
    -- This will be the default in neovim 0.7+
    debounce_text_changes = 150,
  }

  local on_attach = function(client, bufnr)
    require "lsp-format".on_attach(client)

    -- Force syncronous formatting when :wq (lukas-reineke/lsp-format.nvim is async)
    vim.cmd [[cabbrev wq execute "lua vim.lsp.buf.formatting_sync()" <bar> wq]]

    --
    -- Keybindings
    --

    --vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gds', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gws', [[<cmd>lua vim.lsp.buf.workspace_symbol()<CR>]], opts)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
 -- " TODO I want this?
 -- " nnoremap <silent> <leader>sh  <cmd>lua vim.lsp.buf.signature_help()<CR>

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>aa', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ae', '<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>aw', '<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>', opts)



-- " Metals specific
-- " map("n", "<leader>tt", [[<cmd>lua require("metals.tvp").toggle_tree_view()<CR>]])
-- " map("n", "<leader>tr", [[<cmd>lua require("metals.tvp").reveal_in_tree()<CR>]])


  end

  --local shared_diagnostic_settings = vim.lsp.with(
  --  vim.lsp.diagnostic.on_publish_diagnostics,
  --  {
  --    virtual_text = false --{prefix = '', truncated = true}
  --  }
  --)
  local lspconfig = require('lspconfig')
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local servers = { 'vimls', 'elmls', 'dockerls', 'cssls', 'tsserver', 'yamlls', 'html', 'bashls', 'solargraph', 'terraformls', 'purescriptls', 'hls', 'sqlls' }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = flags,
    }
  end

  lspconfig.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = flags,
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
      },
    },
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
        end,
      },
    },
  }

  -- Configure Scala LSP server
  metals_config = require'metals'.bare_config()
  metals_config.capabilities = capabilities
  metals_config.flags = flags

  metals_config.settings = {
    showImplicitArguments = true
  }

  -- Enables `metals#status()`
  metals_config.init_options.statusBarProvider = 'on'

  -- Debug settings if you're using nvim-dap
  local dap = require("dap")
  dap.configurations.scala = {
    {
      type = "scala",
      request = "launch",
      name = "Run",
      metals = {
        runType = "run",
        args = { "firstArg", "secondArg", "thirdArg" },
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Test File",
      metals = {
        runType = "testFile",
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Test Target",
      metals = {
        runType = "testTarget",
      },
    },
  }

  metals_config.on_attach = function(client, bufnr)
    vim.cmd([[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]])
    vim.cmd([[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]])
    vim.cmd([[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]])

    on_attach(client)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ws', '<cmd>lua require"metals".worksheet_hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'v', 'K', '<Esc><cmd>lua require("metals").type_of_range()<CR>', opts)

    -- TODO configure dap keybindings
    require("metals").setup_dap()
  end

  vim.cmd([[augroup lsp]])
  vim.cmd([[autocmd!]])
  -- vim.cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
  --vim.cmd([[autocmd FileType scala,java,elm,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc]]) -- TODO disable? See https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion#nvim-cmp
  vim.cmd([[autocmd FileType scala,sbt,java lua require("metals").initialize_or_attach(metals_config)]])
  --vim.cmd([[autocmd BufWritePre *.scala,*.sbt,*.elm lua vim.lsp.buf.formatting_sync(nil, 1000)]])
  vim.cmd([[augroup END]])


EOF
" }}}
" }}}

" Colors {{{
syntax enable           " enable syntax processing

set background=dark
if has("termguicolors")
    set termguicolors   " enable true color support
endif


" lua << EOF
" local nightfox = require('nightfox')
" nightfox.setup({
"   fox = "nordfox", -- change the colorscheme to use nordfox
" })
" nightfox.load()
" EOF

if has('vim_starting')
    colorscheme kanagawa
    "colorscheme gruvbox
    "let g:base16colorspace=256
    "colorscheme base16-ocean
    "colorscheme iceberg
    "let g:base16colorspace=256
    "colorscheme base16-ocean
    " colorscheme twilight
    " colorscheme tokyonight
    " let g:nightfox_style = "nordfox"
    " colorscheme nightfox
    " colorscheme tokyonight
    " colorscheme OceanicNext
    " Enables transparancy in NeoVim. (removes background colors)
    "hi Normal guibg=NONE ctermbg=NONE
    "hi LineNr guibg=NONE ctermbg=NONE
    "hi SignColumn guibg=NONE ctermbg=NONE
    "hi EndOfBuffer guibg=NONE ctermbg=NONE
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

augroup cursorline
  " Show cursorlines only at active buffer
  autocmd!
  autocmd WinEnter,BufEnter *\(NvimTree_*\)\@<! setlocal cursorline cursorcolumn
  autocmd WinLeave,BufLeave *\(NvimTree_*\)\@<!  setlocal nocursorline nocursorcolumn
  autocmd TermOpen * setlocal nocursorline nocursorcolumn
augroup END

augroup vimrc
    autocmd!

    " Set cursor to last place when reopening file
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g'\"" |
                \ endif

    " Do not use relativenumber in insert mode
    " This only applies for things that has filetype set (not terminal)
    autocmd InsertEnter *\(NvimTree_*\|^$\)\@<!  setlocal norelativenumber
    autocmd InsertLeave *\(NvimTree_*\|^$\)\@<!  setlocal relativenumber
    " TODO norelativenumber when leaving the buffer
    " autocmd BufLeave *\(NvimTree\)\@<! : setlocal norelativenumber
    " autocmd BufEnter *\(NvimTree\)\@<! : setlocal relativenumber
    autocmd TermOpen * setlocal nonumber norelativenumber

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
"nnoremap <c-k> :m-2<cr>==
"nnoremap <c-j> :m+<cr>==
inoremap <c-j> <esc>:m+<cr>==gi
inoremap <c-k> <esc>:m-2<cr>==gi
vnoremap <c-j> :m'>+<cr>gv=gv
vnoremap <c-k> :m-2<cr>gv=gv

" window navigation alt+{h,j,k,l}
" TODO does these work?
" '<M-...>' Alt-key or meta-key
" This? https://vi.stackexchange.com/questions/2350/how-to-map-alt-key
" TODO note that we are using vim-tmux-navigator with c-hjkl atm
" Or should we defined vim-tmux-navigator with alt?
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
nnoremap <silent> <A-\> :TmuxNavigatePrevious<cr>
"nnoremap <A-h> <C-w>h
"nnoremap <A-j> <C-w>j
"nnoremap <A-k> <C-w>k
"nnoremap <A-l> <C-w>l
"" alt+{hjkl} window control for terminal aswell
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l

" Window resizing
" Problematic with home key row mod on laptop without double click repeat
" nmap <left>  :3wincmd ><cr>
" nmap <right> :3wincmd <<cr>
" nmap <up>    :3wincmd +<cr>
" nmap <down>  :3wincmd -<cr>

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
"let &colorcolumn=join(range(81,999),",") " Color column from 81 outwards
set colorcolumn=80
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

" Searching {{{
if !has('nvim')
    set incsearch           " search as characters are entered
    set hlsearch            " highlight matches
endif

" Case insensitive searching UNLESS /C or capital in search
set ignorecase
set smartcase

" Hightlight on yank
augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end

" turn off search highlight
nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>

" Use RipGrep for grepping. Respects gitignore, etc
set grepprg=rg\ -H\ --smart-case\ --hidden\ --no-heading\ --vimgrep
set grepformat=%f:%l:%c:%m
augroup quickfix
    " Open quickfix window after :grep
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup END


"set grepprg=rg\ --vimgrep
"set grepformat^=%f:%l:%c:%m

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
" FloatTerm
nnoremap   <silent>   <F7>    :FloatermNew<CR>
tnoremap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
nnoremap   <silent>   <F8>    :FloatermPrev<CR>
tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
nnoremap   <silent>   <F9>    :FloatermNext<CR>
tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
nnoremap   <silent>   <F12>   :FloatermToggle<CR>
tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>
" TODO I want F12? disabled yakuake

if has('nvim')
    set sh=zsh

    command! VsTerm  vsplit  | terminal
    command! STerm   split   | terminal
    command! TabTerm tabedit | terminal

    nnoremap <silent> <leader>st :STerm<CR>

    function s:TerminalClose()
      " Only run close when no filetype (normal terminal)
      if &filetype ==# ''
        :q
      endif
    endfunction

    augroup nvim_term
      autocmd!
      "     " Start in insert mode
      "     autocmd BufWinEnter,WinEnter term://* startinsert
      " autocmd TermEnter * startinsert " TODO new?

      " quit when a terminal closes instead of showing exit code and waiting
      " Disabled because https://vi.stackexchange.com/a/17923
      "autocmd TermClose * call s:TerminalClose()
    augroup END

    " Extension of vim-tmux-navigator
    function s:AddTerminalNavigation()
      if &filetype ==# ''
        tnoremap <buffer> <silent> <c-h> <c-\><c-n>:TmuxNavigateLeft<cr>
        tnoremap <buffer> <silent> <c-j> <c-\><c-n>:TmuxNavigateDown<cr>
        tnoremap <buffer> <silent> <c-k> <c-\><c-n>:TmuxNavigateUp<cr>
        tnoremap <buffer> <silent> <c-l> <c-\><c-n>:TmuxNavigateRight<cr>
      endif
    endfunction

    " TODO do I want this at all?
    augroup TerminalNavigation
      autocmd!
      "autocmd TermOpen * call s:AddTerminalNavigation()
      "" https://github.com/junegunn/fzf.vim/issues/982
      "autocmd FileType fzf tnoremap <C-j> <nop>
      "autocmd FileType fzf tnoremap <C-k> <nop>
    augroup END

    " http://neovim.io/doc/user/nvim_terminal_emulator.html
    " TODO disabled because of fzf problems
    "tnoremap <Esc> <C-\><C-n>
    "Alternative fix:
    "tnoremap <expr> <esc> &filetype == 'fzf' ? "\<esc>" : "\<c-\>\<c-n>"
    "tnoremap <expr> <esc> match('fzf\|lspsaga', &filetype) ? "\<esc>" : "\<c-\>\<c-n>"
    " But it does not help for other not fzf windows. Must then add every
    " exeception
    " And this did not work
"    autocmd BufWinEnter,WinEnter term://*  tnoremap <buffer> <Esc> <C-\><C-n>
" But it is bad idea? vim mode inside terminal as well. So EESC should work
" inside there properly
    " This one creates problems with j navigation
    "tnoremap jk <C-\><C-n>


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

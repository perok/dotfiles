-- TODO must be bootstrapped with
-- git clone https://github.com/wbthomason/packer.nvim\
--   ~/.local/share/nvim/site/pack/packer/opt/packer.nvim
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use { 'morhetz/gruvbox' }
  use { 'chriskempson/base16-vim' }
  use { 'dawikur/base16-vim-airline-themes' }
  use { 'mhartington/oceanic-next' } --
  -- use { 'Soares/base16.nvim' } --
  -- use { 'jacoborus/tender' } --
  -- use { 'cocopon/iceberg.vim' } --

  use { 'liuchengxu/vim-which-key' }
  use { 'mhinz/vim-startify' }

  use { 'editorconfig/editorconfig-vim' }

  use { 'kevinhwang91/nvim-bqf' }
  use { 'justinmk/vim-dirvish' }
  use { 'justinmk/vim-sneak' }
  use { 'tpope/vim-eunuch' }
  use { 'tpope/vim-surround' }
  use { 'tpope/vim-unimpaired' } -- Bindings on [ and ]
  use { 'tpope/vim-repeat' }  -- '.' supports non-native commands
  use { 'wellle/targets.vim' } --   -- More useful text object

  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-fugitive' }

  use { 'itchyny/lightline.vim' }
  use { 'junegunn/rainbow_parentheses.vim' }
  use { 'airblade/vim-gitgutter' }  -- TODO? https://github.com/lewis6991/gitsigns.nvim
  use { 'nathanaelkane/vim-indent-guides' }

  use { 'mbbill/undotree', cmd = 'UndotreeToggle' }
  --use { 'whiteinge/diffconflicts' }
  use { 'voldikss/vim-floaterm' }
  use { 'liuchengxu/vista.vim' }

  use { 'junegunn/fzf',
    run = function() vim.fn['fzf#install']() end,
    requires = {
      { 'junegunn/fzf.vim' }
    }
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      { 'nvim-telescope/telescope-symbols.nvim' }
     -- {'nvim-telescope/telescope-fzy-native.nvim'}
    }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    -- We recommend updating the parsers on update
    run = ':TSUpdate'
  }
  use { 'onsails/lspkind-nvim' }
  use { 'neovim/nvim-lspconfig' }
  use { 'scalameta/nvim-metals' } -- LSP server for Scala
  use {
    'hrsh7th/nvim-compe',
    requires = {
      { 'hrsh7th/vim-vsnip' }
    }
  }

  use { 'dense-analysis/ale' }
  use { 'vim-pandoc/vim-pandoc', ft = { 'markdown', 'pandoc' } }
  use { 'vim-pandoc/vim-pandoc-syntax' , ft = { 'markdown', 'pandoc' } }
end)

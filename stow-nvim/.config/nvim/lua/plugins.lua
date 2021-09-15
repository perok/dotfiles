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

  use { 'kyazdani42/nvim-web-devicons' }
  use { 'itchyny/lightline.vim' }
  use {
    'junegunn/rainbow_parentheses.vim',
    ft = { 'lisp', 'clojure', 'scheme', 'scala'},
    cmd = 'RainbowParentheses',
    config = 'vim.cmd[[RainbowParentheses]]'
}
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
  use {
    -- Fanyc vscode like icons for lsp
    'onsails/lspkind-nvim',
    config = function() require('lspkind').init() end
  }
  use { 'neovim/nvim-lspconfig' }
  use { 'scalameta/nvim-metals' } -- LSP server for Scala
  use {
    'hrsh7th/nvim-compe',
    requires = {
      { 'hrsh7th/vim-vsnip' },
      { 'hrsh7th/vim-vsnip-integ' },
      { 'norcalli/snippets.nvim' },
    },
    config = function()
      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local check_back_space = function()
          local col = vim.fn.col('.') - 1
          if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
              return true
          else
              return false
          end
      end

      -- Use (s-)tab to:
      --- move to prev/next item in completion menuone
      --- jump to prev/next snippet's placeholder
      _G.tab_complete = function()
        if vim.fn.pumvisible() == 1 then
          return t "<C-n>"
        elseif vim.fn.call("vsnip#available", {1}) == 1 then
          return t "<Plug>(vsnip-expand-or-jump)"
        elseif check_back_space() then
          return t "<Tab>"
        else
          return vim.fn['compe#complete']()
        end
      end
      _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
          return t "<C-p>"
        elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
          return t "<Plug>(vsnip-jump-prev)"
        else
          return t "<S-Tab>"
        end
      end

      vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
      vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
      vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
      vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    end
  }

  use { 'dense-analysis/ale' }
  use { 'vim-pandoc/vim-pandoc', ft = { 'markdown', 'pandoc' } }
  use { 'vim-pandoc/vim-pandoc-syntax' , ft = { 'markdown', 'pandoc' } }
end)

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
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/vim-vsnip",
      'norcalli/snippets.nvim',
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-calc",
    },
    config = function()
      local lspkind = require('lspkind')
      local cmp = require'cmp'

      cmp.setup {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'vsnip' }, -- TODO https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
          { name = 'nvim_lua' },
          { name = 'emoji' },
          { name = 'calc' },
        },
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          -- ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })
        },
        formatting = {
          format = function(entry, vim_item)
            -- fancy icons and a name of kind
            vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

            -- set a name for each source
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[Latex]",
            })[entry.source.name]

            return vim_item
          end
        },
        documentation = {
          -- https://github.com/hrsh7th/nvim-cmp#documentationwinhighlight-type-string
          -- maxwidth = 20
        }
      }
    end
  }

  use { 'dense-analysis/ale' }
  use { 'vim-pandoc/vim-pandoc', ft = { 'markdown', 'pandoc' } }
  use { 'vim-pandoc/vim-pandoc-syntax' , ft = { 'markdown', 'pandoc' } }
end)

-- TODO must be bootstrapped with

-- git clone https://github.com/wbthomason/packer.nvim\
--   ~/.local/share/nvim/site/pack/packer/opt/packer.nvim
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  -- TODO PackerSync removes itself. Does this help?
  use {'wbthomason/packer.nvim', opt = true}
  use 'antoinemadec/FixCursorHold.nvim'

  -- use { 'morhetz/gruvbox' }
  -- use { 'chriskempson/base16-vim' }
  -- use { 'dawikur/base16-vim-airline-themes' }
  -- use { 'mhartington/oceanic-next' } --
  -- use 'folke/tokyonight.nvim'
  use 'EdenEast/nightfox.nvim'
  use "rebelot/kanagawa.nvim"
  -- use 'shaunsingh/nord.nvim'
  -- use { 'Soares/base16.nvim' } --
  -- use { 'jacoborus/tender' } --
  -- use { 'cocopon/iceberg.vim' } --

  -- use { 'liuchengxu/vim-which-key' }
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end
  }
  use { 'mhinz/vim-startify' }

  use { 'editorconfig/editorconfig-vim' }

  use { 'kevinhwang91/nvim-bqf', ft = 'qf' }

  -- File explorer
  -- use { 'justinmk/vim-dirvish' }
  use {
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup({
        view_options = {
          show_hidden = true,
        }
      })
      vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
    end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require'nvim-tree'.setup {
        -- disables netrw completely
        disable_netrw       = true,
        -- hijack netrw window on startup
        hijack_netrw        = true,
        -- hijacks new directory buffers when they are opened. - Dirvish coop
        hijack_directories   = {
          enable = false,
        },
        hijack_cursor       = true,
        update_focused_file = {
          enable = true
        },
        renderer = {
          group_empty = true,
          -- Hide the root path of the current folder on top of the tree
          root_folder_label = false
        }
      }
    end
  }

  use 'lambdalisue/suda.vim'

  -- use { 'justinmk/vim-sneak' }
  use {
   'ggandor/leap.nvim', -- Similar to vim-sneak
    config = function()
      require('leap').add_default_mappings()
    end
  }
  use { 'tpope/vim-eunuch' }
  use { 'tpope/vim-surround' }
  use { 'tpope/vim-unimpaired' } -- Bindings on [ and ]
  use { 'tpope/vim-repeat' }  -- '.' supports non-native commands
  use { 'wellle/targets.vim' } --   -- More useful text object
  use 'christoomey/vim-tmux-navigator'

  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-fugitive' }

  use { 'kyazdani42/nvim-web-devicons' }
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      -- local function get_short_cwd()
      --   return vim.fn.fnamemodify(vim.fn.getcwd(), ':t:h')
      -- end

      require('lualine').setup {
        sections = {
          -- lualine_a = {'mode', 'g:metals_status'}
          lualine_c = {
            -- get_short_cwd,
            'filename',
            'g:metals_status'
            -- {'g:metals_status', separator = { left = '', right = ''}}
          }
        }
      }
    end
  }

  -- Better search highlighting
  -- use {'kevinhwang91/nvim-hlslens'}
  -- TODO disabled because its crashing nvim https://github.com/kevinhwang91/nvim-hlslens/issues/33

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require("ibl").setup {
        exclude = {
          filetypes = { 'NvimTree', "startify", "lspinfo", "packer", "checkhealth", "help", ""},
          buftypes = { 'terminal' }
        },
        scope = {
          enabled = true
        }
      }
    end
  }
  use {
    "lukas-reineke/lsp-format.nvim",
    config = function()
      require("lsp-format").setup {}
    end
  }

  use 'RRethy/vim-illuminate' -- Hightlight similiar text

  use { 'mbbill/undotree', cmd = 'UndotreeToggle' }
  --use { 'whiteinge/diffconflicts' }
  use 'sindrets/diffview.nvim' -- Git diff viewer
  -- use {
  --   'voldikss/vim-floaterm',
  --   cmd = { 'FloatTermNew', 'FloatTermToggle' }
  -- -- color problem? let g:floaterm_winblend = 0
  -- -- migrate ctrlp to command! FZF FloatermNew fzf ??
  -- }

  use { 'liuchengxu/vista.vim' }

  -- No bullshit tabline improvement
  use {
    'alvarosevilla95/luatab.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function ()
      require('luatab').setup{}
    end
  }

--  use 'junegunn/vim-peekaboo' -- replaced by WhichKey plugin
--  TODO remove fzf because of telescope. But how to install for shell?
  use { 'junegunn/fzf',
    run = function() vim.fn['fzf#install']() end,
    requires = {
      { 'junegunn/fzf.vim' }
    }
  }
  use {
    'nvim-telescope/telescope.nvim',
    config = function()
      local telescope = require('telescope')
      telescope.setup{
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--hidden',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
          },
          path_display = {
            truncate = 2,
          },
        },
        pickers = {
          buffers = {
            -- sort_lastused = true,
            sort_mru = true,
            ignore_current_buffer = true,
            -- Not fuzzy sort but should keep MRU order
            -- sorter = require'telescope.sorters'.get_substr_matcher(),
          }
        },
      }

      telescope.load_extension('fzy_native')
    end,
    requires = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-symbols.nvim' },
      { 'nvim-telescope/telescope-fzy-native.nvim' }
    }
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    -- We recommend updating the parsers on update
    run = ':TSUpdate'
  }
  use 'p00f/nvim-ts-rainbow'
  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function ()
       require('ts_context_commentstring').setup {}
       vim.g.skip_ts_context_commentstring_module = true
    end
  }
  use { 'neovim/nvim-lspconfig' }
  -- use({
  -- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  -- config = function()
  --   require("lsp_lines").setup()
  -- end,
-- })
  use {  -- LSP server for Scala
    'scalameta/nvim-metals' ,
    requires = {
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap'
    },
  }
  use {
    "rcarriga/nvim-dap-ui",
    requires = {
      "mfussenegger/nvim-dap"
    }
  }

  use {
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end
  }

  use { 'hashivim/vim-terraform' }

  use {
    "petertriho/cmp-git",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("cmp_git").setup()
    end
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      'hrsh7th/cmp-vsnip',
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      -- Fanyc vscode like icons for lsp
      'onsails/lspkind-nvim',
    },
    config = function()
      local lspkind = require('lspkind')
      local cmp = require'cmp'

      cmp.setup {
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = "nvim_lsp_signature_help" },
          { name = 'path' },
          { name = 'vsnip' }, -- TODO https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping
          { name = 'nvim_lua' },
          { name = 'emoji' },
          { name = 'calc' },
        }, {
          { name = 'buffer' },
        }),
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          -- ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-n>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end
        }),
        ['<C-p>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end
        }),



        },
        formatting = {
          format = lspkind.cmp_format({with_text = false, maxwidth = 50})
        },
        -- window = {
          -- documentation = {
            -- https://github.com/hrsh7th/nvim-cmp#documentationwinhighlight-type-string
            -- maxwidth = 20
          -- }
        -- }
      }

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline(':', {
      --   sources = cmp.config.sources({
      --     { name = 'path' }
      --   }, {
      --     -- https://github.com/hrsh7th/cmp-cmdline/issues/24
      --     { name = 'cmdline', keyword_pattern=[=[[^[:blank:]\!]*]=] }
      --   })
      -- })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = 'buffer' },
        })
      })
    end
  }
  -- anoying..
  -- use {
  --   'kosayoda/nvim-lightbulb',
  --   config = function()
  --     vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
  --   end
  -- }

  use {
    'rest-nvim/rest.nvim',
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          show_http_info = true,
          show_headers = true,
        },
        -- Jump to request line on run
        jump_to_request = true,
        env_file = '.env',
        custom_dynamic_variables = {},
        yank_dry_run = true,
    })
    vim.cmd("command! RestNvim lua require('rest-nvim').run()")
		vim.cmd("command! RestNvimPreview lua require('rest-nvim').run(true)")
    end
  }

  -- use { 'vim-pandoc/vim-pandoc', ft = { 'markdown', 'pandoc' } }
  -- use { 'vim-pandoc/vim-pandoc-syntax' , ft = { 'markdown', 'pandoc' } }
  use 'purescript-contrib/purescript-vim'
  use 'kmonad/kmonad-vim'
  use 'b0o/schemastore.nvim'
end)

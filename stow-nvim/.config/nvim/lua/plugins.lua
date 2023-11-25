-- Bootstrap
-- Remember: leader and localleader first
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function buf_map(bufnr, mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

local on_attach = function(client, bufnr)
  --
  -- Keybindings
  --

  --vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>')
  buf_map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  buf_map(bufnr, 'n', 'gds', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])
  buf_map(bufnr, 'n', 'gws', [[<cmd>lua vim.lsp.buf.workspace_symbol()<CR>]])

  buf_map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  buf_map(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  -- " TODO I want this? crashes with telescope
  -- " nnoremap <silent> <leader>sh  <cmd>lua vim.lsp.buf.signature_help()<CR>

  buf_map(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  buf_map(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  buf_map(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  buf_map(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  buf_map(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  buf_map(bufnr, 'n', '<leader>cl', '<cmd>lua vim.lsp.codelens.run()<CR>')
  buf_map(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  buf_map(bufnr, 'n', '<leader>aa', '<cmd>lua vim.diagnostic.setqflist()<CR>')
  buf_map(bufnr, 'n', '<leader>ae', '<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>')
  buf_map(bufnr, 'n', '<leader>aw', '<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>')
end

require('lazy').setup({
  --  'morhetz/gruvbox',
  --  'chriskempson/base16-vim',
  --  'dawikur/base16-vim-airline-themes',
  --  'mhartington/oceanic-next', --
  -- 'folke/tokyonight.nvim',
  'EdenEast/nightfox.nvim',
  "rebelot/kanagawa.nvim",
  -- 'shaunsingh/nord.nvim',
  --  'Soares/base16.nvim', --
  --  'jacoborus/tender', --
  --  'cocopon/iceberg.vim', --

  --  'liuchengxu/vim-which-key',
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end
  },
   'mhinz/vim-startify',

   'editorconfig/editorconfig-vim',

  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf'
  },


  { -- File explorer
    -- 'justinmk/vim-dirvish',
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup({
        view_options = {
          show_hidden = true,
        }
      })
      vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
    end
  },

  {
    'nvim-tree/nvim-tree.lua', -- TODO https://github.com/nvim-neo-tree/neo-tree.nvim ?
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
  },

  'lambdalisue/suda.vim',

  --  'justinmk/vim-sneak',
  {
   'ggandor/leap.nvim', -- Similar to vim-sneak
    config = function()
      require('leap').add_default_mappings()
    end
  },
   'tpope/vim-eunuch',
   'tpope/vim-surround',
   'tpope/vim-unimpaired', -- Bindings on [ and ]
   'tpope/vim-repeat',  -- '.' supports non-native commands
   'wellle/targets.vim', --   -- More useful text object
   'christoomey/vim-tmux-navigator',
   'tpope/vim-commentary',
   'tpope/vim-fugitive',
   'nvim-tree/nvim-web-devicons',
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
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
  },

  -- Better search highlighting
  -- 'kevinhwang91/nvim-hlslens',
  -- TODO disabled because its crashing nvim https://github.com/kevinhwang91/nvim-hlslens/issues/33

  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  },

  {
    'lukas-reineke/indent-blankline.nvim',
     main = "ibl",
    opts = {
      exclude = {
        filetypes = { 'NvimTree', "startify", "lspinfo", "packer", "checkhealth", "help", ""},
        buftypes = { 'terminal' }
      },
      scope = {
        enabled = true
      }
    }
  },
  { -- Formatter
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    -- Everything in opts will be passed to setup()
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        -- scala = { "scalafmt" },
        javascript = { { "prettierd", "prettier" } },
      },
      -- Set up format-on-save
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  'RRethy/vim-illuminate', -- Hightlight similiar text,

  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle'
  },
  -- 'whiteinge/diffconflicts',
  'sindrets/diffview.nvim', -- Git diff viewer,
  -- {
  --   'voldikss/vim-floaterm',
  --   cmd = { 'FloatTermNew', 'FloatTermToggle' }
  -- -- color problem? let g:floaterm_winblend = 0
  -- -- migrate ctrlp to command! FZF FloatermNew fzf ??
  -- },

   'liuchengxu/vista.vim',

  -- No bullshit tabline improvement TODO not maintained?
  {
    'alvarosevilla95/luatab.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function ()
      require('luatab').setup{}
    end
  },

--  TODO remove fzf because of telescope. But how to install for shell?
  { 'junegunn/fzf',
    build = function() vim.fn['fzf#install']() end,
    dependencies = {
      { 'junegunn/fzf.vim' }
    }
  },
  {
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
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      'nvim-telescope/telescope-fzy-native.nvim'
    }
  },

  {
    'nvim-treesitter/nvim-treesitter',
    event = { "VeryLazy" },
    build = ':TSUpdate',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function ()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = 'all', --{'scala', 'html', 'javascript', 'yaml', 'css', 'lua', 'http', 'json', 'elm', 'bash', 'python', 'ruby', 'elixir'},
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        highlight = {
          enable = true,
          -- disable = {'scala'},
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
    end
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    -- TODO scala support
    config = function ()
      local rainbow_delimiters = require 'rainbow-delimiters'

      require('rainbow-delimiters.setup').setup {
      strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
      },
      query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
      },
      highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
      },
    }
  end
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function ()
       require('ts_context_commentstring').setup {}
       vim.g.skip_ts_context_commentstring_module = true
    end
  },


  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
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
      {
        "petertriho/cmp-git",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
          require("cmp_git").setup()
        end
      },
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
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            }
          }
        })
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = 'buffer' },
        })
      })
    end
  },
  {
    'neovim/nvim-lspconfig',
    config = function(self, opts)
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local servers = {
        'vimls', 'elmls', 'dockerls', 'cssls', 'tsserver',
        'yamlls', 'html', 'bashls', 'solargraph', 'terraformls',
        'purescriptls', 'hls', 'sqlls'
      }

      local flags = {
      }

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
    end
  },
  -- ({
  -- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  -- config = function()
  --   require("lsp_lines").setup()
  -- end,
-- }),
  {  -- LSP server for Scala
    'scalameta/nvim-metals',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'mfussenegger/nvim-dap',
        config = function(self, opts)
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
        end
      }
    },
    ft = { "sc", "scala", "sbt", "java" },
    opts = function()
      local function buf_map(bufnr, mode, lhs, rhs, opts)
        local options = { noremap = true, silent = true }
        if opts then
          options = vim.tbl_extend("force", options, opts)
        end
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
      end

      local metals_config = require'metals'.bare_config()
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
      metals_config.flags = flags
      metals_config.serverVersion = 'latest.snapshot'

      metals_config.settings = {
        showImplicitArguments = true
      }

      -- Enables `metals#status()`
      metals_config.init_options.statusBarProvider = 'on'

      metals_config.on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        require("metals").setup_dap()

        vim.cmd([[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]])
        vim.cmd([[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]])
        vim.cmd([[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]])

        buf_map(bufnr, "n", "<leader>ws", function()
          require("metals").hover_worksheet()
        end, opts)

        vim.api.nvim_buf_set_keymap(bufnr, 'v', 'K', '<Esc><cmd>lua require("metals").type_of_range()<CR>', opts)

        buf_map(bufnr, "n", "<leader>dc", function()
          require("dap").continue()
        end, opts)

        buf_map(bufnr, "n", "<leader>dr", function()
          require("dap").repl.toggle()
        end, opts)

        buf_map(bufnr, "n", "<leader>dK", function()
          require("dap.ui.widgets").hover()
        end, opts)

        buf_map(bufnr, "n", "<leader>dt", function()
          require("dap").toggle_breakpoint()
        end, opts)

        buf_map(bufnr, "n", "<leader>dso", function()
          require("dap").step_over()
        end, opts)

        buf_map(bufnr, "n", "<leader>dsi", function()
          require("dap").step_into()
        end, opts)

        buf_map(bufnr, "n", "<leader>dl", function()
          require("dap").run_last()
        end, opts)
      end

      return metals_config
    end,
    config = function(self, metals_config)
      require("metals").initialize_or_attach(metals_config)
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap"
    }
  },

  {
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end
  },

  'hashivim/vim-terraform',


  {
    'rest-nvim/rest.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
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
        yank_dry_build = true,
    })
    vim.cmd("command! RestNvim lua require('rest-nvim').run()")
    vim.cmd("command! RestNvimPreview lua require('rest-nvim').run(true)")
    end
  },

  --  'vim-pandoc/vim-pandoc', ft = { 'markdown', 'pandoc' },
  --  'vim-pandoc/vim-pandoc-syntax', ft = { 'markdown', 'pandoc' },
  -- 'purescript-contrib/purescript-vim',
  'kmonad/kmonad-vim',
  'b0o/schemastore.nvim',
})

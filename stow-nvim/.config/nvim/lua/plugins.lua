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

  --vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  buf_map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.definition()<cr>')
  buf_map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
  buf_map(bufnr, 'n', 'gds', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]])
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]])
  buf_map(bufnr, 'n', 'gws', [[<cmd>lua vim.lsp.buf.workspace_symbol()<cr>]])

  buf_map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
  buf_map(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
  -- " TODO I want this? crashes with telescope
  -- " nnoremap <silent> <leader>sh  <cmd>lua vim.lsp.buf.signature_help()<cr>

  buf_map(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>')
  buf_map(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>')
  buf_map(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>')
  buf_map(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
  buf_map(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
  buf_map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
  buf_map(bufnr, 'n', '<leader>cl', '<cmd>lua vim.lsp.codelens.run()<cr>')
  buf_map(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')

  -- Diagnostics
  buf_map(bufnr, 'n', '<leader>aa', '<cmd>lua vim.diagnostic.setqflist()<cr>', { desc = "LSP diagnostic set all" })
  buf_map(bufnr, 'n', '<leader>ae', '<cmd>lua vim.diagnostic.setqflist({severity = "E"})<cr>',
    { desc = "LSP diagnostic set all error" })
  buf_map(bufnr, 'n', '<leader>aw', '<cmd>lua vim.diagnostic.setqflist({severity = "W"})<cr>',
    { desc = "LSP diagnostic set all warn" })

  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
end

require('lazy').setup({
  --  'morhetz/gruvbox',
  --  'chriskempson/base16-vim',
  --  'dawikur/base16-vim-airline-themes',
  --  'mhartington/oceanic-next', --
  -- 'folke/tokyonight.nvim',
  'EdenEast/nightfox.nvim',
  'rebelot/kanagawa.nvim',
  -- 'shaunsingh/nord.nvim',
  --  'Soares/base16.nvim', --
  --  'jacoborus/tender', --
  --  'cocopon/iceberg.vim', --

  --  'liuchengxu/vim-which-key',
  {
    "folke/which-key.nvim",
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500 -- Default timeout is 1000ms
    end,
    opts = {
      defaults = {
        -- TODO why not working?
        ["<leader>a"] = { name = "+Diagnostics to QF" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
  {
    'mhinz/vim-startify',
    init = function()
      vim.g.startify_custom_header = {}
      vim.g.startify_change_to_dir = 0
      --let g:startify_change_to_vcs_root = 1
    end
  },

  'editorconfig/editorconfig-vim',

  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf'
  },


  { -- File explorer
    -- 'justinmk/vim-dirvish',
    'stevearc/oil.nvim',
    opts = {
      view_options = {
        show_hidden = true,
      }
    },
    keys = {
      {
        "-",
        function()
          require("oil").open()
        end,
        desc = "Open parent directory",
      },
    },
  },

  {
    'nvim-tree/nvim-tree.lua', -- TODO https://github.com/nvim-neo-tree/neo-tree.nvim ?
    config = function()
      require 'nvim-tree'.setup {
        -- disables netrw completely
        disable_netrw       = true,
        -- hijack netrw window on startup
        hijack_netrw        = true,
        -- hijacks new directory buffers when they are opened. - Dirvish coop
        hijack_directories  = {
          enable = false,
        },
        hijack_cursor       = true,
        update_focused_file = {
          enable = true
        },
        renderer            = {
          group_empty = true,
          -- Hide the root path of the current folder on top of the tree
          root_folder_label = false
        }
      }
    end
  },

  'lambdalisue/suda.vim',

  {
    --  'justinmk/vim-sneak',
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end
  },
  'tpope/vim-eunuch',
  'tpope/vim-surround',
  'tpope/vim-unimpaired', -- Bindings on [ and ]
  'tpope/vim-repeat',     -- '.' supports non-native commands
  'wellle/targets.vim',   --   -- More useful text object
  'christoomey/vim-tmux-navigator',
  'tpope/vim-commentary',
  'tpope/vim-fugitive',
  'nvim-tree/nvim-web-devicons',
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
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
      -- Do like this? https://github.com/LazyVim/LazyVim/blob/68ff818a5bb7549f90b05e412b76fe448f605ffb/lua/lazyvim/plugins/editor.lua#L334
      require('gitsigns').setup()
    end
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {
      exclude = {
        filetypes = { 'NvimTree', "startify", "lspinfo", "packer", "checkhealth", "help", "" },
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
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
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

      -- Disable formatting on save
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save. ! for only this buffer",
        bang = true,
      })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end,
  },

  'RRethy/vim-illuminate', -- Hightlight similiar text,

  {
    -- leader U Tescope, delete this?
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = {
      { '<F6>', [[<cmd>UndotreeToggle<cr>]], silent = true },
    }
  },
  -- 'whiteinge/diffconflicts',
  'sindrets/diffview.nvim', -- Git diff viewer,
  -- {
  --   'voldikss/vim-floaterm',
  --   cmd = { 'FloatTermNew', 'FloatTermToggle' }
  -- -- color problem? let g:floaterm_winblend = 0
  -- -- migrate ctrlp to command! FZF FloatermNew fzf ??
  -- },

  {
    -- TODO Vista finder nvim_lsp -> nvim-telescope
    'liuchengxu/vista.vim',
    init = function()
      vim.g.vista_default_executive = 'nvim_lsp'
    end,
    keys = {
      { '<F8>', [[<cmd>Vista nvim_lsp<cr>]], silent = true },
    }
  },

  -- No bullshit tabline improvement TODO not maintained?
  {
    'alvarosevilla95/luatab.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('luatab').setup {}
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      local telescope = require('telescope')
      telescope.setup {
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

      telescope.load_extension('fzf')
    end,
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      -- 'nvim-telescope/telescope-fzy-native.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      {
        "debugloop/telescope-undo.nvim",
        keys = {
          { "<leader>U", "<cmd>Telescope undo<cr>", silent = true, desc = "Undo visualize" }
        },
        config = function()
          require("telescope").load_extension("undo")
        end,
      },
      {
        "folke/which-key.nvim",
        optional = true,
        opts = {
          defaults = {
            ["<leader>s"] = { name = "+search" },
          },
        },
      },
    },
    keys = {
      { '<C-p>',           [[<cmd>Telescope find_files hidden=true<cr>]],                                      silent = true, desc = 'Find files' },
      { '<leader><space>', "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",                      silent = true, desc = 'Buffers' },
      -- Inspiration to go through: https://github.com/LazyVim/LazyVim/blob/68ff818a5bb7549f90b05e412b76fe448f605ffb/lua/lazyvim/plugins/editor.lua#L136
      -- overrides C-a increment
      -- { '<C-a>',           [[<cmd>Telescope commands<cr>]],                                                   silent = true, desc = 'Commands' },
      -- search
      { '<leader>s"',      "<cmd>Telescope registers<cr>",                                                     silent = true, desc = "Registers" },
      { "<leader>sc",      "<cmd>Telescope command_history<cr>",                                               silent = true, desc = "Command History" },
      { "<leader>sC",      "<cmd>Telescope commands<cr>",                                                      silent = true, desc = "Commands" },
      { "<leader>sm",      "<cmd>Telescope marks<cr>",                                                         silent = true, desc = "Jump to Mark" },
      { '<leader>b',       "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",                      silent = true, desc = 'Buffers' },
      { '<leader>sf',      [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<cr>]],      silent = true, desc = 'Find files' },
      { '<leader>sb',      [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]],          silent = true, desc = 'Fuzzy find current buffer' },
      { '<leader>sh',      [[<cmd>lua require('telescope.builtin').help_tags()<cr>]],                          silent = true, desc = 'Help tags' },
      { '<leader>st',      [[<cmd>lua require('telescope.builtin').tags()<cr>]],                               silent = true, desc = 'Tags' },
      { '<leader>sd',      [[<cmd>lua require('telescope.builtin').grep_string()<cr>]],                        silent = true, desc = 'Grep string' },
      { '<leader>sp',      [[<cmd>lua require('telescope.builtin').live_grep()<cr>]],                          silent = true, desc = "Live grep" },
      { '<leader>so',      [[<cmd>lua require('telescope.builtin').tags({ only_current_buffer = true })<cr>]], silent = true, desc = 'Tags in buffer' },
      { '<leader>?',       [[<cmd>lua require('telescope.builtin').oldfiles()<cr>]],                           silent = true, desc = 'Old files' },
      -- {'<leader>fg', "<cmd>Telescope live_grep<cr>", desc = "Live grep"},
      -- {'<leader>ff', "<cmd>Telescope find_files<cr>" desc = "Find file"},
    },
  },

  {
    -- Better increment/decrement C-a, C-x
    'monaqa/dial.nvim',
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
  },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    event = { "VeryLazy" },
    build = ':TSUpdate',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
          'scala',
          'html',
          'javascript',
          'yaml',
          'css',
          'scss',
          -- "comment", -- comments are slowing down TS bigtime, so disable for now
          "graphql",
          "gitcommit",
          "gitignore",
          "sql",
          'lua',
          'http',
          'json',
          'elm',
          'bash',
          'python',
          'ruby',
          'elixir'
        },
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
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')

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
    config = function()
      require('ts_context_commentstring').setup {}
      vim.g.skip_ts_context_commentstring_module = true
    end
  },


  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
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
      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local lspkind = require('lspkind')
      local cmp = require 'cmp'

      cmp.setup {
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50
          })
        },
        -- window = {
        -- documentation = {
        -- https://github.com/hrsh7th/nvim-cmp#documentationwinhighlight-type-string
        -- maxwidth = 20
        -- }
        -- }
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
          ['<cr>'] = cmp.mapping.confirm({
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
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'b0o/schemastore.nvim',
    },
    opts = {
      ensure_installed = {
        'lua_ls',
        'dockerls',
        'docker_compose_language_service',
        'eslint',
        'elmls',
        'marksman', -- markdown
        -- 'solargraph', -- ruby TODO install error
        'terraformls',
        'gradle_ls',
        'vimls',
        'lemminx', -- xml
        'yamlls',
        'jsonls',
        'cssls',
        'sqlls',
        'html',
        'tsserver', -- JS
        "bashls"
      }
    },
    config = function(self, opts)
      -- First mason, then lspconfig.
      require("mason").setup()
      require("mason-lspconfig").setup(vim.tbl_deep_extend("force", opts, {
        -- See https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
        handlers = {
          -- Will be called for each installed server that doesn't have
          -- a dedicated handler.
          function(server_name)
            require("lspconfig")[server_name].setup {
              on_attach = on_attach,
            }
          end,
          ["nil_ls"] = function()
            require('lspconfig').nil_ls.setup {}
          end,
          ["sqlls"] = function()
            require('lspconfig').sqlls.setup {
              -- ? https://github.com/LunarVim/LunarVim/discussions/4210#discussioncomment-6083169
              root_dir = function() return vim.loop.cwd() end,
            }
          end,
          ["lua_ls"] = function()
            require('lspconfig').lua_ls.setup {
              on_attach = on_attach,
              -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
              on_init = function(client)
                local path = client.workspace_folders[1].name
                if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                  client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                    Lua = {
                      runtime = {
                        version = 'LuaJIT' -- LuaJIT for neovim
                      },
                      -- Make the server aware of Neovim runtime files
                      workspace = {
                        checkThirdParty = false,
                        library = {
                          vim.env.VIMRUNTIME
                          -- "${3rd}/luv/library"
                          -- "${3rd}/busted/library",
                        }
                        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                        -- library = vim.api.nvim_get_runtime_file("", true)
                      }
                    }
                  })

                  client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                end
                return true
              end
            }
          end,
          ["jsonls"] = function()
            require('lspconfig').jsonls.setup {
              on_attach = on_attach,
              settings = {
                json = {
                  schemas = require('schemastore').json.schemas(),
                  validate = { enable = true },
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
          end,
          ["yamlls"] = function()
            require('lspconfig').yamlls.setup {
              on_attach = on_attach,
              settings = {
                yaml = {
                  schemaStore = {
                    -- You must disable built-in schemaStore support if you want to use
                    -- this plugin and its advanced options like `ignore`.
                    enable = false,
                    -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                    url = "",
                  },
                  schemas = require('schemastore').yaml.schemas(),
                },
              },
            }
          end,
        },
      }))

      -- Defaults for lspconfig (after mason)
      local lspconfig = require("lspconfig")

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        -- on_attach = on_attach, -- TODO why not working here?
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      require('lspconfig').nil_ls.setup {
        on_attach = on_attach,
      }
    end
  },
  -- ({
  -- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  -- config = function()
  --   require("lsp_lines").setup()
  -- end,
  -- }),
  { -- LSP server for Scala
    'scalameta/nvim-metals',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'mfussenegger/nvim-dap',
        -- TODO opts?
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
      local metals_config = require('metals').bare_config()
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.settings = {
        showImplicitArguments = true,
        useGlobalExecutable = true -- Practical for nix
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
        end)

        buf_map(bufnr, 'v', 'K', '<Esc><cmd>lua require("metals").type_of_range()<cr>')

        buf_map(bufnr, "n", "<leader>mts", function()
          require("metals").toggle_setting("showImplicitArguments")
        end)

        buf_map(bufnr, "n", "<leader>dc", function()
          require("dap").continue()
        end)

        buf_map(bufnr, "n", "<leader>dr", function()
          require("dap").repl.toggle()
        end)

        buf_map(bufnr, "n", "<leader>dK", function()
          require("dap.ui.widgets").hover()
        end)

        buf_map(bufnr, "n", "<leader>dt", function()
          require("dap").toggle_breakpoint()
        end)

        buf_map(bufnr, "n", "<leader>dso", function()
          require("dap").step_over()
        end)

        buf_map(bufnr, "n", "<leader>dsi", function()
          require("dap").step_into()
        end)

        buf_map(bufnr, "n", "<leader>dl", function()
          require("dap").run_last()
        end)
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap"
    }
  },

  -- Show diagnostics
  -- {
  --   'dgagn/diagflow.nvim',
  --   event = 'LspAttach',
  --   opts = {}
  -- },
  -- { -- Seems to not be compatible with indent blanklines
  --   -- https://github.com/lukas-reineke/indent-blankline.nvim/issues/596
  --   'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
  -- },

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
})

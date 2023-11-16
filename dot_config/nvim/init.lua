vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set('n', 'y', '"+y')
vim.keymap.set('n', 'yy', '"+yy')
vim.keymap.set('n', 'Y', '"+Y')
vim.keymap.set('x', 'y', '"+y')
vim.keymap.set('x', 'Y', '"+Y')

vim.keymap.set('n', '<', '[', { remap = true })
vim.keymap.set('n', '>', ']', { remap = true })
vim.keymap.set('o', '<', '[', { remap = true })
vim.keymap.set('o', '>', ']', { remap = true })
vim.keymap.set('x', '<', '[', { remap = true })
vim.keymap.set('x', '>', ']', { remap = true })

-- Install package manager
--    https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  {
    'nmac427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end,
  },

  -- Run prettier on file save
  {
    'mhartington/formatter.nvim',
    config = function()
      local prettierd_config = {
        -- prettierd
        function()
          return {
            exe = "prettierd",
            args = { vim.api.nvim_buf_get_name(0) },
            stdin = true
          }
        end
      }
      require('formatter').setup({
        logging = false,
        filetype = {
          javascript = prettierd_config,
          typescript = prettierd_config,
          javascriptreact = prettierd_config,
          typescriptreact = prettierd_config,
          -- other formatters ...
        }
      })
      vim.cmd([[
      augroup FormatAutogroup
        autocmd!
        autocmd BufWritePost * FormatWrite
      augroup END
      ]])
    end
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- "2rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin"
    end
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },

  { "hrsh7th/cmp-path" },

  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        position = "right",
        height = 18,
        width = 80,
        icons = false,
        fold_open = "v",      -- icon used for open folds
        fold_closed = ">",    -- icon used for closed folds
        indent_lines = false, -- add an indent guide below the fold icons
        signs = {
          -- icons / text used for a diagnostic
          error = "error",
          warning = "warn",
          hint = "hint",
          information = "info",
          other = "",
        },
        use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
      })
      vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end, { desc = "Toggle Trouble" })
      vim.keymap.set("n", "<leader>xw", function() require("trouble").open("workspace_diagnostics") end,
        { desc = "Trouble workspace diagnostics" })
      vim.keymap.set("n", "<leader>xd", function() require("trouble").open("document_diagnostics") end,
        { desc = "Trouble document diagnostics" })
      vim.keymap.set("n", "<leader>xq", function() require("trouble").openc("quickfix") end,
        { desc = "Trouble Quickfix" })
      vim.keymap.set("n", "<leader>xl", function() require("trouble").open("loclist") end, { desc = "Trouble Loclist" })
      vim.keymap.set("n", "gR", function() require("trouble").open("lsp_references") end,
        { desc = "Trouble LSP References" })
    end,
  },



  {
    "aserowy/tmux.nvim",
    config = function()
      return require("tmux").setup({
        copy_sync = {
          redirect_to_clipboard = true,
        },
        resize = {
          -- enables default keybindings (A-hjkl) for normal mode
          enable_default_keybindings = true,
          resize_step_x = 5,
          resize_step_y = 5,
        }
      })
    end
  },

  {
    'ggandor/lightspeed.nvim',
    dependencies = { 'tpope/vim-repeat' },
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        ---@diagnostic disable-next-line: unused-local
        on_attach = function(_bufnr)
          -- local gs = package.loaded.gitsigns
          --
          -- local function map(mode, l, r, opts)
          --   opts = opts or {}
          --   opts.buffer = bufnr
          --   vim.keymap.set(mode, l, r, opts)
          -- end

          -- Navigation
          -- map('n', ']c', function()
          --   if vim.wo.diff then return ']c' end
          --   vim.schedule(function() gs.next_hunk() end)
          --   return '<Ignore>'
          -- end, { expr = true })
          --
          -- map('n', '[c', function()
          --   if vim.wo.diff then return '[c' end
          --   vim.schedule(function() gs.prev_hunk() end)
          --   return '<Ignore>'
          -- end, { expr = true })

          -- Actions
          -- map('n', '<leader>hs', gs.stage_hunk, { desc = 'stage hunk' })
          -- map('n', '<leader>hr', gs.reset_hunk, { desc = 'reset hunk' })
          -- map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          --   { desc = "stage hunk" })
          -- map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          --   { desc = 'reset hunk' })
          -- map('n', '<leader>hS', gs.stage_buffer, { desc = 'stage buffer' })
          -- map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
          -- map('n', '<leader>hR', gs.reset_buffer, { desc = 'reset buffer' })
          -- map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview hunk' })
          -- map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = 'blame line' })
          -- map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle line blame' })
          -- map('n', '<leader>hd', gs.diffthis, { desc = 'diffthis' })
          -- map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'diffthis~' })
          -- map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle deleted' })
          --
          -- -- Text object
          -- map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      }
    end
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    config = function()
      --  Switch for controlling whether you want autoformatting.
      --  Use :KickstartFormatToggle to toggle autoformatting on or off
      local format_is_enabled = true
      vim.api.nvim_create_user_command('KickstartFormatToggle', function()
        format_is_enabled = not format_is_enabled
        print('Setting autoformatting to: ' .. tostring(format_is_enabled))
      end, {})

      -- Create an augroup that is used for managing our formatting autocmds.
      --      We need one augroup per client to make sure that multiple clients
      --      can attach to the same buffer without interfering with each other.
      local _augroups = {}
      local get_augroup = function(client)
        if not _augroups[client.id] then
          local group_name = 'kickstart-lsp-format-' .. client.name
          local id = vim.api.nvim_create_augroup(group_name, { clear = true })
          _augroups[client.id] = id
        end

        return _augroups[client.id]
      end

      -- Whenever an LSP attaches to a buffer, we will run this function.
      --
      -- See `:help LspAttach` for more information about this autocmd event.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
        -- This is where we attach the autoformatting for reasonable clients
        callback = function(args)
          local client_id = args.data.client_id
          local client = vim.lsp.get_client_by_id(client_id)
          local bufnr = args.buf

          -- Only attach to clients that support document formatting
          if not client.server_capabilities.documentFormattingProvider then
            return
          end

          -- Tsserver usually works poorly. Sorry you work with bad languages
          -- You can remove this line if you know what you're doing :)
          if client.name == 'tsserver' then
            return
          end


          -- Create an autocmd that will run *before* we save the buffer.
          --  Run the formatting command for the LSP that has just attached.
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = get_augroup(client),
            buffer = bufnr,
            callback = function()
              if not format_is_enabled then
                return
              end

              vim.lsp.buf.format {
                async = false,
                filter = function(c)
                  return c.id == client.id
                end,
              }
            end,
          })
        end,
      })
    end,
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },

  {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
      require('rainbow-delimiters.setup').setup {
      }
    end
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',           opts = {} },

  { 'smartpde/telescope-recent-files', },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'windwp/nvim-ts-autotag'
    },
    build = ':TSUpdate',
  },
  { import = 'plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true


-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
vim.o.scrolloff = 12
vim.o.scrollback = 20

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevelstart = 99


vim.o.wrap = false

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

require('telescope').setup {
  defaults = {
    file_ignore_patterns = { "*.git/*", "tmp", "node_modules", "deps", "_build" },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<c-a>"] = function() vim.cmd ":norm I" end,
        ["<c-e>"] = function() vim.cmd ":norm A" end,
        ["<c-u>"] = function() vim.cmd ":norm c0" end,
        ['<c-p>'] = function(prompt_bufnr)
          local prompt_title = action_state.get_current_picker(prompt_bufnr).prompt_title
          if prompt_title == 'Recent files' then
            actions.move_selection_next(prompt_bufnr)
          else
            actions.move_selection_previous(prompt_bufnr)
          end
        end
      },
    },
  },
  extensions = {
    recent_files = {
      only_cwd = true,
      show_current_file = false,
      ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*" },
      mappings = {
        i = {
          ['<c-b>'] = actions.select_default
        }
      }
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Enable telescope recent files
pcall(require('telescope').load_extension, 'recent_files')




local function custom_telescope(method)
  return function()
    method(require('telescope.themes').get_ivy({
      previewer = false,
    }))
  end
end

vim.keymap.set('n', '<c-p>', custom_telescope(require('telescope').extensions.recent_files.pick),
  { desc = 'Find project file sort by recency' })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', custom_telescope(require('telescope.builtin').oldfiles),
  { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>/', custom_telescope(require('telescope.builtin').current_buffer_fuzzy_find),
  { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sf', custom_telescope(require('telescope.builtin').find_files),
  { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', custom_telescope(require('telescope.builtin').help_tags), { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', custom_telescope(require('telescope.builtin').grep_string),
  { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', custom_telescope(require('telescope.builtin').live_grep),
  { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', custom_telescope(require('telescope.builtin').diagnostics),
  { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sc', custom_telescope(require('telescope.builtin').commands),
  { desc = '[S]earch [C]ommands' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,

  autotag = {
    enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
  },
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<M-Right>',
      node_incremental = '<M-Right>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-Left>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  tailwindcss = {},
  emmet_language_server = {},
  tsserver = {},
  elixirls = {
    dialyzerEnabled = true
  },
  html = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  gopls = {
    settings = {
      gopls = {
        staticcheck = true,
      },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()


-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

---@diagnostic disable-next-line: missing-fields
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'copilot',  group_index = 2 },
    { name = 'nvim_lsp', group_index = 2 },
    { name = 'luasnip',  group_index = 2 },
    { name = "path",     group_index = 2 },
  },
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

vim.api.nvim_create_autocmd('BufRead', {
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
            not (ft:match('commit') and ft:match('rebase'))
            and last_known_line > 1
            and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})

-- this is for diagnositcs signs on the line number column
-- use this to beautify the plain E W signs to more fun ones
-- !important nerdfonts needs to be setup for this to work in your terminal
local signs = { Error = "x", Warn = "!", Hint = "§", Info = "i" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false
  }
)

vim.api.nvim_set_keymap(
  'n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>',
  { desc = 'Show Diagnostic under cursor', noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n', '<Leader>e', '<cmd>Neotree toggle<cr>',
  { desc = 'Toggle Tree File Finder', noremap = true, silent = true }
)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

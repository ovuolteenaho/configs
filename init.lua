local cmd = vim.cmd
local fn = vim.fn

vim.opt.mouse = ''
vim.opt.syntax = 'on'
vim.opt.errorbells = false
vim.opt.smartcase = true
vim.opt.showmode = false
vim.bo.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.hidden = true
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.bo.autoindent = true
vim.bo.smartindent = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.signcolumn = 'yes'
vim.wo.wrap = true
vim.wo.linebreak = true

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', '?l', ':set number!<CR>', { silent = true })
map('n', '?q', ':nohlsearch<CR>', { silent = true })
map('n', '<CR>', 'o<Esc>')

require 'paq' {
    'savq/paq-nvim';
    'nvim-treesitter/nvim-treesitter';
    'nvim-treesitter/playground';
    'neovim/nvim-lspconfig';
    'hrsh7th/nvim-cmp';
    'hrsh7th/cmp-buffer';
    'hrsh7th/cmp-path';
    'hrsh7th/cmp-nvim-lsp';
    'saadparwaiz1/cmp_luasnip';
    'L3MON4D3/LuaSnip';
    'rafamadriz/friendly-snippets';
    'marko-cerovac/material.nvim';
    'hoob3rt/lualine.nvim';
    'kyazdani42/nvim-web-devicons';
    'nvim-lua/plenary.nvim';
    'lewis6991/gitsigns.nvim';
    'folke/tokyonight.nvim';
    'nvim-telescope/telescope.nvim';
    'neomake/neomake';
}

-- treesitter
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = {'python'}, highlight = {enable = true}}

-- lsp
local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = require('cmp_nvim_lsp').default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
  end
}

local lsp = require 'lspconfig'
lsp.util.default_config = vim.tbl_deep_extend(
  'force',
  lsp.util.default_config,
  lsp_defaults
)

-- lsp servers
lsp.pylsp.setup{
    root_dir = lsp.util.root_pattern('.git', fn.getcwd()),
    settings = {
        pylsp = {
            plugins = {
                ruff = {enabled = true},
                pycodestyle = {enabled = false},
                pyflakes = {enabled = false},
                mccabe = {enabled = false}
            }
        }
    }
}

-- snippets
require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
    snippet = {
        expand = function(args)
        luasnip.lsp_expand(args.body)
        end
    },
    
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp', keyword_length = 3},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2},
    },
    
    window = {
        documentation = cmp.config.window.bordered()
    },
    formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
        local menu_icon = {
          nvim_lsp = 'λ',
          luasnip = '⋗',
          buffer = 'Ω',
          path = '🖫',
        }

        item.menu = menu_icon[entry.source.name]
        return item
    end,
  },
  mapping = {
      ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
      ['<Down>'] = cmp.mapping.select_next_item(select_opts),

      ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
      ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
  
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({select = true}),
  
      ['<C-d>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
              luasnip.jump(1)
          else
              fallback()
          end
      end, {'i', 's'}),

      ['<C-b>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
              luasnip.jump(-1)
          else
              fallback()
          end
      end, {'i', 's'}),

    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, {'i', 's'}),
  },
})

-- gitsings
require('gitsigns').setup()

-- telescope
local my_find_files = function(opts)
    opts = opts or {}
    -- we only want to do it if we have a gitignore and no .git dir
    opts.find_command = { "rg", "-g", "!*.pyc", "--files", "--no-ignore" }
    require("telescope.builtin").find_files(opts)
end

local builtin = require('telescope.builtin')
vim.keymap.set('n', 'ff', my_find_files, {})
vim.keymap.set('n', 'fg', builtin.live_grep, {})
vim.keymap.set('n', 'fb', builtin.buffers, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})

-- theme stuff
vim.g.material_style = 'deep ocean'
vim.g.tokyonight_style = 'night'
vim.cmd[[colorscheme tokyonight]]

-- lualine
require('lualine').setup{options = {theme = 'tokyonight'}}

-- cool icons
require('nvim-web-devicons').setup()

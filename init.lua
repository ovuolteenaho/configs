local cmd = vim.cmd
local fn = vim.fn

vim.o.syntax = 'on'
vim.o.errorbells = false
vim.o.smartcase = true
vim.o.showmode = false
vim.bo.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.completeopt='menuone,noinsert,noselect'
vim.bo.autoindent = true
vim.bo.smartindent = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
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

-- load the package manager
cmd 'packadd paq-nvim'

local paq = require('paq-nvim').paq

paq {'savq/paq-nvim', opt = true}
paq {'nvim-treesitter/nvim-treesitter'}
paq {'nvim-treesitter/playground'}
paq {'neovim/nvim-lspconfig'}
paq {'marko-cerovac/material.nvim'}
paq {'hoob3rt/lualine.nvim'}
paq {'kyazdani42/nvim-web-devicons'}
paq {'hrsh7th/nvim-compe'}
paq {'nvim-lua/plenary.nvim'}
paq {'lewis6991/gitsigns.nvim'}
paq {'folke/tokyonight.nvim'}
paq {'ctrlpvim/ctrlp.vim'}

local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = {'python'}, highlight = {enable = true}}

local lsp = require 'lspconfig'
lsp.pylsp.setup{root_dir = lsp.util.root_pattern('.git', fn.getcwd())}

vim.g.material_style = 'deep ocean'
vim.g.tokyonight_style = 'night'
vim.cmd[[colorscheme tokyonight]]

require('lualine').setup{options = {theme = 'tokyonight'}}

require('nvim-web-devicons').setup()

require('compe').setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}

require('gitsigns').setup()

-- Vim Options
-- set -g window-size largest
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.splitright = true

-- Download Lazy.Nvim if not exists
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath, }
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy plugins
require('lazy').setup({
    {
    'Exafunction/codeium.vim',
    event = 'BufEnter',
    cond = function() 
      return os.getenv("NEOVIM_ENABLE_CODEIUM")
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
	ensure_installed = { "lua", "python", "yaml", "bash", "json" },
        highlight = { enable = true, }
      }
    end
  },
  {
  'stevearc/oil.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup {
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
      view_options = {
        show_hidden = true
      }
    } 
  end
  },
  {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {
          'nvim-lua/plenary.nvim',
          {
              'nvim-telescope/telescope-fzf-native.nvim',
              build =
              'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
              cond = function()
                  return vim.fn.executable 'cmake' == 1
              end,
          },
      },
      config = function()
          require('telescope').setup {
              pickers = {
                  find_files = {
                      hidden = true
                  }
              },
          }
          pcall(require('telescope').load_extension, 'fzf')
          vim.keymap.set('n', '=', require('telescope.builtin').find_files,
              { desc = '[S]earch [F]iles' })
          vim.keymap.set('n', '<A-=>', require('telescope.builtin').live_grep,
              { desc = '[S]earcr by [G]rep' })
          vim.keymap.set('n', '<A-^>', require('telescope.builtin').resume,
              { desc = 'Resume previous Telescope' })
      end
  },
  {
      'dhruvasagar/vim-table-mode',
  },
  {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp'},
  {'L3MON4D3/LuaSnip'}
})

if os.getenv("NEOVIM_ENABLE_LSP") then
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  -- https://lsp-zero.netlify.app/v3.x/language-server-configuration.html
  local lsp_zero = require('lsp-zero')
  lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({buffer = bufnr})
  end)
    require'lspconfig'.bashls.setup{}
    require'lspconfig'.pyright.setup{}
end

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {})
vim.keymap.set('n', '<A-w>', '<Esc><CMD>q!<CR>', {})
vim.keymap.set('n', '<A-t>', '<CMD>vsplit | terminal<CR>', {})
vim.keymap.set('n', '<A-T>', '<CMD>tab split<CR>', {})
vim.keymap.set('v', '<A-d>', '"_d', {})
vim.keymap.set('n', '<A-d>', '"_dd', {})
vim.keymap.set('n', '<A-j>', '<C-W>j', {})
vim.keymap.set('n', '<A-k>', '<C-W>k', {})
vim.keymap.set('n', '<A-h>', '<C-W>h', {})
vim.keymap.set('n', '<A-l>', '<C-W>l', {})
vim.keymap.set('n', '<A-l>', '<C-W>l', {})
vim.keymap.set('t', '<A-j>', '<C-\\><C-n><C-w>j', {})
vim.keymap.set('t', '<A-k>', '<C-\\><C-n><C-w>k', {})
vim.keymap.set('t', '<A-h>', '<C-\\><C-n><C-w>h', {})
vim.keymap.set('t', '<A-l>', '<C-\\><C-n><C-w>l', {})
vim.keymap.set('n', '<A-1>', '1gt', {})
vim.keymap.set('n', '<A-2>', '2gt', {})
vim.keymap.set('n', '<A-3>', '3gt', {})
vim.keymap.set('t', '<A-1>', '<C-\\><C-n>1gt', {})
vim.keymap.set('t', '<A-2>', '<C-\\><C-n>2gt', {})
vim.keymap.set('t', '<A-3>', '<C-\\><C-n>3gt', {})
vim.keymap.set('n', '<A-[>', '<CMD>diffget LOCAL<CR>', {})
vim.keymap.set('n', '<A-]>', '<CMD>diffget BASE<CR>', {})
vim.keymap.set('n', '<A-\\>', '<CMD>diffget REMOTE<CR>', {})

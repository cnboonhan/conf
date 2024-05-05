-- config folder: $HOME/.config/nvim OR $HOME\AppData\Local\nvim
-- requires ripgrep, npm, git, node, python, cmake, gcc
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.autoread = true
vim.o.hlsearch = true
vim.wo.number = false
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smarttab = true
vim.o.expandtab = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 250
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.opt.path = vim.opt.path + { vim.fn.stdpath('data') .. 'mason/bin' }
vim.o.foldmethod = 'indent'
vim.o.foldlevelstart = 99
vim.o.foldnestmax = 2
vim.o.foldminlines = 0

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath, }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
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
            vim.keymap.set('n', '<A-p>', require('telescope.builtin').find_files,
                { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<A-P>', require('telescope.builtin').buffers,
                { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<A-g>', require('telescope.builtin').live_grep,
                { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<A-G>', require('telescope.builtin').lsp_workspace_symbols,
                { desc = '[S]earch Workspace Symbols' })
            vim.keymap.set('n', '<A-^>', require('telescope.builtin').resume,
                { desc = 'Resume previous Telescope' })
        end
    },
    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup({
                view = {
                    preserve_window_proportions = false,
                },
                actions = {
                    open_file = {
                        resize_window = false
                    }
                },
                filters = {
                    dotfiles = false,
                    custom = { '^.git$' }
                },
                git = {
                    ignore = true
                },
                update_focused_file = {
                    enable = true
                },
                renderer = {
                    icons = {
                        show = {
                            file = false,
                            folder = false,
                            folder_arrow = false,
                            git = false,
                            diagnostics = false,
                            bookmarks = false
                        }
                    }
                }
            })
            vim.keymap.set('n', '<A-q>',
                '<CMD>NvimTreeToggle()<CR>',
                {})
            vim.keymap.set('n', '<A-Q>', '<CMD>NvimTreeFindFile<CR>', {})
        end
    },
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function()
            require('toggleterm').setup({
                shell = "bash",
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
            })
            local customToggleTermCommand = os.getenv('NVIM_CUSTOM_TOGGLETERM') or "while true; do tgpt -i; done"
            if vim.fn.executable 'tgpt' == 1 then
                vim.cmd(string.format('2TermExec cmd="%s" open=0', customToggleTermCommand))
                vim.keymap.set("n", '<A-?>', '<CMD>2ToggleTerm direction=float<CR>',
                    { desc = "Custom Terminal" })
                vim.keymap.set("t", '<A-?>', '<Esc><CMD>2ToggleTerm direction=float<CR>',
                    { desc = "Custom Terminal" })
                vim.keymap.set("v", '<A-?>',
                    '<Esc><CMD>ToggleTermSendVisualLines 2<CR><Esc><CMD>2ToggleTerm direction=float<CR>',
                    { desc = "Custom Terminal" })
            end

            vim.keymap.set("n", '<A-t>', '<CMD>1ToggleTerm direction=horizontal<CR>',
                { desc = "Terminal" })
            vim.keymap.set("n", '<A-T>', '<CMD>1ToggleTerm direction=vertical<CR>',
                { desc = "Terminal" })
            vim.keymap.set("n", '<A-e>', '<Esc><CMD>ToggleTermSendCurrentLine 1<CR>', {})
            vim.keymap.set("v", '<A-e>', '<Esc><CMD>ToggleTermSendVisualLines 1<CR>', {})
            if vim.loop.os_uname().sysname == 'Windows' or vim.loop.os_uname().sysname == 'Windows_NT' then
                vim.keymap.set("n", '<A-E>', '<Esc><CMD>1TermExec cmd="Invoke-History"<CR>',
                    { desc = "Run previous command in terminal" })
            else
                vim.keymap.set("n", '<A-E>', '<Esc><CMD>1TermExec cmd="!!"<CR>',
                    { desc = "Run previous command in terminal" })
            end
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            vim.keymap.set('n', '<A-.>', vim.lsp.buf.code_action, { desc = 'Fix Code Diagnostic' })
            vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

            local on_attach = function(_, bufnr)
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end
                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end
                nmap('rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                nmap('gt', vim.lsp.buf.type_definition, 'Type [D]efinition')
                nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                nmap('gk', vim.lsp.buf.hover, 'Hover Documentation')
            end
            local mason_lspconfig = require 'mason-lspconfig'

            local servers = {}

            if vim.fn.executable 'npm' == 1 then
                servers['yamlls'] = {
                    yaml = {
                        schemas = {
                            kubernetes = "*.k8s.yaml",
                            ['https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json'] =
                            "*.cf.yaml"
                        }
                    }
                }

                servers['jsonls'] = {}
                servers['bashls'] = {}

                if vim.fn.executable 'python' == 1 then
                    servers['pyright'] = {}
                end

                if vim.fn.executable 'go' == 1 then
                    servers['gopls'] = {}
                end
            end

            mason_lspconfig.setup {
                ensure_installed = vim.tbl_keys(servers),
            }

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            mason_lspconfig.setup_handlers {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                        cmd = (servers[server_name] or {}).cmd,
                    }
                end
            }
            require "lsp_signature".on_attach()
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            luasnip.config.setup {}

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
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
            }
        end
    },
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            'rafamadriz/friendly-snippets',
        },
        config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
        end
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        config = function()
            require('lsp_signature').setup {
            }
        end
    },
    {
        'tpope/vim-fugitive'
    },
    {
        'rafamadriz/friendly-snippets',
    },
    {
        'dhruvasagar/vim-table-mode',
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            mode = "document_diagnostics"
        }
    }
}, {})

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {})
vim.keymap.set('n', '<A-n>', '<Esc><CMD>tabnew<CR>', {})
vim.keymap.set('v', '<A-y>', 'y<Esc><CMD>tabnew<CR><CMD>set scl=no<CR>p', {})
vim.keymap.set('n', '<A-w>', '<Esc><CMD>q!<CR>', {})
vim.keymap.set('n', '<A-z>', '<CMD>tab split<CR>', {})
vim.keymap.set('v', '<A-d>', '"_d', {})
vim.keymap.set('n', '<A-d>', '"_dd', {})
vim.keymap.set('n', '<A-j>', '<C-W>j', {})
vim.keymap.set('n', '<A-k>', '<C-W>k', {})
vim.keymap.set('n', '<A-h>', '<C-W>h', {})
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
vim.keymap.set('n', '<A-space>', '<C-^>', {})

-- useful CLI
-- delete branches except currently checked out: git branch -D (git branch --list --format "%(refname:short)")

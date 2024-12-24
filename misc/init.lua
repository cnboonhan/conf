local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo(
            {
                {"Failed to clone lazy.nvim:\n", "ErrorMsg"},
                {out, "WarningMsg"},
                {"\nPress any key to exit..."}
            },
            true,
            {}
        )
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup(
    {
        {
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
            opts = {}
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup(
                    {
                        ensure_installed = {"lua"},
                        auto_install = true,
                        highlight = {
                            enable = true
                        }
                    }
                )
            end
        },
        {
            "stevearc/oil.nvim",
            opts = {},
            -- Optional dependencies
            dependencies = {"nvim-tree/nvim-web-devicons"},
            config = function()
                require("oil").setup {
                    vim.keymap.set(
                        "n",
                        "-",
                        "<CMD>Oil<CR>",
                        {
                            desc = "Open parent directory"
                        }
                    ),
                    view_options = {
                        show_hidden = true
                    }
                }
            end
        },
        {
            "nvim-telescope/telescope.nvim",
            branch = "0.1.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
                    cond = function()
                        return vim.fn.executable "cmake" == 1
                    end
                }
            },
            config = function()
                require("telescope").setup {
                    pickers = {
                        find_files = {
                            hidden = true
                        }
                    }
                }
                pcall(require("telescope").load_extension, "fzf")
                vim.keymap.set(
                    "n",
                    "=",
                    require("telescope.builtin").find_files,
                    {
                        desc = "[S]earch [F]iles"
                    }
                )
                vim.keymap.set(
                    "n",
                    "<A-=>",
                    require("telescope.builtin").live_grep,
                    {
                        desc = "[S]earcr by [G]rep"
                    }
                )
                vim.keymap.set(
                    "n",
                    "<A-^>",
                    require("telescope.builtin").resume,
                    {
                        desc = "Resume previous Telescope"
                    }
                )
            end
        },
        {
            "yetone/avante.nvim",
            event = "VeryLazy",
            lazy = false,
            version = false,
            opts = {
                provider = "copilot",
                auto_suggestions_provider = "copilot",
                behaviour = {
                    auto_suggestions = true
                }
            },
            build = "make",
            dependencies = {
                "stevearc/dressing.nvim",
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim",
                "hrsh7th/nvim-cmp",
                "nvim-tree/nvim-web-devicons",
                "zbirenbaum/copilot.lua",
                {
                    "HakonHarnes/img-clip.nvim",
                    event = "VeryLazy",
                    opts = {
                        default = {
                            embed_image_as_base64 = false,
                            prompt_for_file_name = false,
                            drag_and_drop = {
                                insert_mode = true
                            },
                            use_absolute_path = true
                        }
                    }
                },
                {
                    "MeanderingProgrammer/render-markdown.nvim",
                    opts = {
                        file_types = {"markdown", "Avante"}
                    },
                    ft = {"markdown", "Avante"}
                },
                {
                    "zbirenbaum/copilot.lua",
                    cmd = "Copilot",
                    event = "InsertEnter",
                    config = function()
                        require("copilot").setup({})
                    end
                },
		{'akinsho/toggleterm.nvim', version = "*", config = true, shell = bash},
                {"tpope/vim-fugitive"}
            }
        }
    }
)

vim.cmd.colorscheme("tokyonight")
vim.keymap.set("n", "<A-j>", "<C-W>j", {})
vim.keymap.set("n", "<A-k>", "<C-W>k", {})
vim.keymap.set("n", "<A-h>", "<C-W>h", {})
vim.keymap.set("n", "<A-l>", "<C-W>l", {})
vim.keymap.set('t', '<A-j>', '<C-\\><C-n><C-w>j', {})
vim.keymap.set('t', '<A-k>', '<C-\\><C-n><C-w>k', {})
vim.keymap.set('t', '<A-h>', '<C-\\><C-n><C-w>h', {})
vim.keymap.set('t', '<A-l>', '<C-\\><C-n><C-w>l', {})
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {})
vim.keymap.set('n', '<A-w>', '<Esc><CMD>q!<CR>', {})
vim.keymap.set("v", "<A-d>", '"_d', {})
vim.keymap.set("n", "<A-d>", '"_dd', {})
vim.keymap.set('n', '<A-1>', '1gt', {})
vim.keymap.set('n', '<A-2>', '2gt', {})
vim.keymap.set('n', '<A-3>', '3gt', {})
vim.keymap.set('t', '<A-1>', '<C-\\><C-n>1gt', {})
vim.keymap.set('t', '<A-2>', '<C-\\><C-n>2gt', {})
vim.keymap.set('t', '<A-3>', '<C-\\><C-n>3gt', {})
vim.keymap.set('n', '<A-t>', '<CMD>tab split<CR>', {})
vim.keymap.set('n', '<C-`>', '<CMD>ToggleTerm<CR>', {})
vim.keymap.set('n', '<A-e>', '<CMD>ToggleTermSendVisualSelection<CR>', {})

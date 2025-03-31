local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo(
      {
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out,                            "WarningMsg" },
        { "\nPress any key to exit..." }
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
            ensure_installed = { "lua", "markdown", "markdown_inline" },
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
      dependencies = { "nvim-tree/nvim-web-devicons" },
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
          build =
          "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
          cond = function()
            return vim.fn.executable "cmake" == 1
          end
        }
      },
      config = function()
        require("telescope").setup {
          pickers = {
            find_files = {
              hidden = true,
              file_ignore_patterns = {
                "node_modules",
                "venv",
                ".git"
              }
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
          "<leader>=",
          require("telescope.builtin").live_grep,
          {
            desc = "[S]earcr by [G]rep"
          }
        )
        vim.keymap.set(
          "n",
          "<leader>^",
          require("telescope.builtin").resume,
          {
            desc = "Resume previous Telescope"
          }
        )
        vim.keymap.set(
          "n",
          "<leader>b",
          require("telescope.builtin").buffers,
          {
            desc = "Open buffers"
          }
        )
      end
    },
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = false,
      opts = function()
        local provider = "copilot"
        local auto_suggestions_provider = "copilot"

        if vim.fn.getenv("ANTHROPIC_API_KEY") ~= vim.NIL then
          provider = "claude"
          auto_suggestions_provider = "claude"
        else
          provider = "copilot"
          auto_suggestions_provider = "copilot"
        end

        return {
          provider                  = provider,
          auto_suggestions_provider = auto_suggestions_provider,
          behaviour                 = {
            auto_suggestions = false
          },
          claude                    = {
            model = "claude-3-5-sonnet-20241022"
          }
        }
      end,
      build = "make",
      dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
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
            file_types = { "markdown", "Avante" }
          },
          ft = { "markdown", "Avante" }
        },
        {
          "zbirenbaum/copilot.lua",
          cmd = "Copilot",
          event = "InsertEnter",
          config = function()
            require("copilot").setup({})
          end
        }
      }
    },
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require("toggleterm").setup(
          {
            shell = "/bin/bash",
            vim.keymap.set({ "n", "t" }, "<leader>`", "<CMD>ToggleTerm<CR>", {}),
            vim.keymap.set({ "n", "t" }, "<leader>!", "<CMD>TermExec cmd='!!'<CR>", {}),
            vim.keymap.set("n", "<leader>e", function()
              require("toggleterm").send_lines_to_terminal("single_line", false, { args = vim.v.count })
            end, {}),
            vim.keymap.set("v", "<leader>e", function()
              require("toggleterm").send_lines_to_terminal("visual_selection", false, { args = vim.v.count })
              vim.cmd(":norm gv")
            end, {}),
            vim.keymap.set("n", "<leader>E", function()
              vim.cmd(":norm gcc")
              require("toggleterm").send_lines_to_terminal("single_line", false, { args = vim.v.count })
              vim.cmd(":norm gcc")
            end, {}),
            vim.keymap.set("v", "<leader>E", function()
              vim.cmd(":norm gcc")
              vim.cmd(":norm gv")
              require("toggleterm").send_lines_to_terminal("visual_selection", false, { args = vim.v.count })
              vim.cmd(":norm gv")
              vim.cmd(":norm gcc")
            end, {})
          }
        )
      end
    },
    {
      "tpope/vim-fugitive"
    },
    {
      "dhruvasagar/vim-table-mode"
    },
    {
      "stevearc/conform.nvim",
      opts = {},
      config = function()
        require("conform").setup(
          {
            format_on_save = {
              timeout_ms = 500,
              lsp_format = "ufallback"
            },
            formatters_by_ft = {
              python = { "black" },
              typescript = { "prettier" }
            }
          }
        )
      end
    },
    {
      "williamboman/mason.nvim",
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig"
      },
      config = function()
        require("mason").setup()
        require("mason-lspconfig").setup(
          {
            ensure_installed = {
              "pylsp",
              "lua_ls"

            }
          }
        )

        -- LSP settings
        local lspconfig = require("lspconfig")
        local on_attach = function(_, bufnr)
          local opts = { buffer = bufnr }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        end

        -- Configure each language server
        lspconfig.pylsp.setup(
          {
            on_attach = on_attach,
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              pylsp = {
                plugins = {
                  pycodestyle = {
                    ignore = { "E501" }
                  }
                }
              }
            }
          }
        )
        lspconfig.lua_ls.setup({})
      end
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path"
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup(
          {
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end
            },
            mapping = cmp.mapping.preset.insert(
              {
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm {
                  behavior = cmp.ConfirmBehavior.Replace,
                  select = true
                },
                ["<Tab>"] = cmp.mapping(
                  function(fallback)
                    if cmp.visible() then
                      cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                      luasnip.expand_or_jump()
                    else
                      fallback()
                    end
                  end,
                  { "i", "s" }
                ),
                ["<S-Tab>"] = cmp.mapping(
                  function(fallback)
                    if cmp.visible() then
                      cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                      luasnip.jump(-1)
                    else
                      fallback()
                    end
                  end,
                  { "i", "s" }
                )
              }
            ),
            sources = {
              { name = "nvim_lsp" },
              { name = "luasnip" },
              { name = "buffer" },
              { name = "path" }
            }
          }
        )
      end
    }
  }
)

function toggle_signcolumn()
  if vim.wo.signcolumn == "yes" then
    vim.wo.signcolumn = "no"
  else
    vim.wo.signcolumn = "yes"
  end
end

function toggle_diagnostics()
  if diagnostics_active then
    vim.cmd("LspStart")
    vim.diagnostic.show()
    vim.opt.mouse = "a"
  else
    vim.cmd("LspStop")
    vim.diagnostic.hide()
    vim.opt.mouse = ""
  end
  diagnostics_active = not diagnostics_active
end

vim.cmd.colorscheme("tokyonight")
vim.keymap.set("n", "<A-j>", "<C-W>j", {})
vim.keymap.set("n", "<A-k>", "<C-W>k", {})
vim.keymap.set("n", "<A-h>", "<C-W>h", {})
vim.keymap.set("n", "<A-l>", "<C-W>l", {})
vim.keymap.set("t", "<A-j>", "<C-\\><C-n><C-w>j", {})
vim.keymap.set("t", "<A-k>", "<C-\\><C-n><C-w>k", {})
vim.keymap.set("t", "<A-h>", "<C-\\><C-n><C-w>h", {})
vim.keymap.set("t", "<A-l>", "<C-\\><C-n><C-w>l", {})
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {})
vim.keymap.set("n", "<leader>w", "<Esc><CMD>q!<CR>", {})
vim.keymap.set("v", "<leader>d", "_d", {})
vim.keymap.set("n", "<leader>d", "_dd", {})
vim.keymap.set("n", "<leader>t", "<CMD>tabnew<CR>", {})
vim.keymap.set("n", "<leader>1", "1gt", {})
vim.keymap.set("n", "<leader>2", "2gt", {})
vim.keymap.set("n", "<leader>3", "3gt", {})
vim.keymap.set("t", "<leader>1", "<C-\\><C-n>1gt", {})
vim.keymap.set("t", "<leader>2", "<C-\\><C-n>2gt", {})
vim.keymap.set("t", "<leader>3", "<C-\\><C-n>3gt", {})
vim.keymap.set("n", "<leader>t", "<CMD>tab split<CR>", {})
vim.keymap.set("n", "<leader>q", ":noh<CR>:lua toggle_signcolumn()<CR> :lua toggle_diagnostics()<CR>", {})
vim.keymap.set('n', "<leader>[", "<CMD>diffget LOCAL<CR>", {})
vim.keymap.set('n', "<leader>]", "<CMD>diffget BASE<CR>", {})
vim.keymap.set('n', "<leader>\\", "<CMD>diffget REMOTE<CR>", {})
vim.keymap.set("n", "<leader>/", ":norm gcc<CR>")
vim.keymap.set("v", "<leader>/", ":norm gcc<CR>:norm gv<CR>")
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.timeoutlen = 200

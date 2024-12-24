FROM ubuntu:24.04

RUN apt update && apt install curl git sudo wget build-essential -y

RUN mkdir -p /root/.config/nvim
RUN <<EOF cat > /root/.config/nvim/init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
      {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
      },
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua" },
            auto_install = true,
            highlight = { enable = true },
          })
        end,
      },
      {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, 
        opts = {
          provider = "openai",
          auto_suggestions_provider = "openai",
          behaviour = {
            auto_suggestions = true,
          },
        },
        build = "make",
        dependencies = {
          "stevearc/dressing.nvim",
          "nvim-lua/plenary.nvim",
          "MunifTanjim/nui.nvim",
          --- The below dependencies are optional,
          "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
          "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
          "zbirenbaum/copilot.lua", -- for providers='copilot'
          {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
              default = {
                embed_image_as_base64 = false,
                prompt_for_file_name = false,
                drag_and_drop = {
                  insert_mode = true,
                },
                use_absolute_path = true,
              },
            },
          },
          {
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
              file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
          },
        },
      }
})

vim.cmd.colorscheme("tokyonight")
vim.keymap.set('n', '<A-j>', '<C-W>j', {})
vim.keymap.set('n', '<A-k>', '<C-W>k', {})
vim.keymap.set('n', '<A-h>', '<C-W>h', {})
vim.keymap.set('n', '<A-l>', '<C-W>l', {})
vim.keymap.set('v', '<A-d>', '"_d', {})
vim.keymap.set('n', '<A-d>', '"_dd', {})
EOF

RUN wget https://github.com/neovim/neovim/releases/download/v0.10.3/nvim-linux64.tar.gz
RUN tar -xvf nvim-linux64.tar.gz
RUN cp -r nvim-linux64/bin/* /usr/bin/
RUN cp -r nvim-linux64/lib/* /usr/lib/
RUN cp -r nvim-linux64/share/* /usr/share/
RUN rm nvim-linux64.tar.gz

ENV XDG_CONFIG_HOME=/root/.config
ENV XDG_DATA_HOME=/root/.local/share
RUN chmod -R o+rwx /root

CMD ["sleep", "infinity"]

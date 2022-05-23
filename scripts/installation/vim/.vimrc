set nocompatible
colo elflord
syntax on 
filetype plugin on
let mapleader=","

set wildmenu
set hidden
set mouse=a
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent breakindent
set incsearch ignorecase smartcase hlsearch 
set backspace=indent,eol,start
set clipboard=unnamedplus

" Allow persistent clipboard
autocmd VimLeave * call system('echo ' . shellescape(getreg('+')) . 
  \ ' | xclip -selection clipboard')

" Allow undo persistence across vim instances
if !isdirectory("/tmp/.vim-undo-dir")
  call mkdir("/tmp/.vim-undo-dir", "", 0700)
endif
set undodir=/tmp/.vim-undo-dir
set undofile
nnoremap <C-e> <C-w>

" Basic shortcuts
nnoremap <leader>l :set relativenumber! nu! nonu<CR>
nmap <leader><leader> :noh<CR>

" Paste without setting paste/nopaste
set pastetoggle=<leader>v

" More advanced stuff
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/tagbar'
Plug 'w0rp/ale'
call plug#end()

" ALE
let g:ale_linters = {'python': ['flake8'], 'sh': ['shellcheck']}
let g:ale_fixers = {'python': ['autopep8'], 'sh': ['shellcheck']}
let g:ale_python_flake8_options = '--ignore=A003,D400,D205,D107,D102,E111,E114,E226,F841,E402,E501'
nmap <leader>z :ALEToggle<CR>
nmap <leader>Z :ALEFix<CR>

" fzf.vim
nnoremap <leader>F :Rg!<space>
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>B :call fzf#vim#files(getcwd(), {'options':'--query=' . expand('%:t:r')})<CR>

" NERDTREE / TAGBAR 
let NERDTreeShowHidden=1
let g:NERDTreeDirArrowExpandable = '↠'
let g:NERDTreeDirArrowCollapsible = '↡'
let g:NERDTreeWinPos = 'right'
nmap <leader>q :NERDTreeToggle<CR>
nmap <leader>Q :TagbarToggle<CR>

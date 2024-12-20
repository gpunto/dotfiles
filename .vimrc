set clipboard=unnamedplus
set autoindent
set number 
set relativenumber 
set title 
set wildmenu 
set cc=100
set ruler
set scrolloff=3
set expandtab
set tabstop=2
set shiftwidth=2
set ignorecase
set smartcase
set incsearch
set hlsearch

nnoremap <SPACE> <Nop>
let mapleader=" "

noremap! <A-BS> <C-w>
noremap! <S-A-BS> <C-u>
noremap U <C-r>
nnoremap J gJ
nnoremap <leader>h :nohlsearch<CR>
xnoremap <leader>p "_dP

filetype plugin indent on
syntax on

set clipboard=unnamedplus
set autoindent
set number 
set relativenumber 
set title 
set wildmenu 
set cc=100
set ruler
set scrolloff=10
set expandtab
set tabstop=2
set shiftwidth=2
set ignorecase
set incsearch
set hlsearch

nnoremap <SPACE> <Nop>
let mapleader=" "

:noremap! <A-BS> <C-w>
:noremap! <S-A-BS> <C-u>
:noremap U <C-r>

nnoremap "p :reg <bar> exec 'normal! "'.input('>').'p'<CR>

filetype plugin indent on
syntax on

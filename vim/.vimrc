set nocompatible

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'christoomey/vim-tmux-navigator'
Plug 'sheerun/vim-polyglot'
Plug 'paulssonkalle/vim-monokai-pro'
Plug 'vim-airline/vim-airline'
Plug 'paulssonkalle/airline-monokai-pro'

call plug#end()

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
colorscheme monokai_pro
set number
set relativenumber
filetype plugin indent on
set expandtab tabstop=2 softtabstop=2 shiftwidth=2
let g:monokai_airline = 1
let g:airline_theme = 'monokai_pro'
set noshowmode

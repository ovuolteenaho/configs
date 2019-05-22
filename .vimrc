" Syntax related stuff
syntax enable
filetype indent on

" UI related stuff
set number
set wildmenu
set showmatch

" Airline related stuff
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme='light'
set ttimeoutlen=10

" Search related stuff
set incsearch
set hlsearch
set ignorecase
set smartcase

" Tab related settings
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4

" Key binding stuff
nnoremap j gj
nnoremap k gk
nnoremap <silent> ?l :set number!<CR>
nnoremap <silent> ?q :nohlsearch<CR>
nnoremap <CR> o<Esc>

" Fix backspace
set backspace=indent,eol,start

" Plugins with Vundle.vim
set nocompatible
filetype off
set rtp+=/home/vagrant/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'w0rp/ale'
Plugin 'Valloric/YouCompleteMe'
Plugin 'airblade/vim-gitgutter'
Plugin 'kien/ctrlp.vim'

call vundle#end()

filetype plugin indent on

" Git branch in statusline
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}

" YouCompleteMe related stuff
let g:ycm_min_num_of_chars_for_completion = 4
let g:ycm_python_binary_path = '/home/vagrant/.pyenv/shims/python3'
set encoding=utf-8

" ALE related stuff
let g:ale_linters = {
            \ 'python': ['flake8'],
            \}
let g:airline#extensions#ale#enabled = 1

" Gitgutter related stuff
set updatetime=250
let g:gitgutter_sign_added = '●'
let g:gitgutter_sign_modified = '●'
let g:gitgutter_sign_removed = '●'
highlight GitGutterAdd ctermfg=white
highlight GitGutterChange ctermfg=green
highlight GitGutterDelete ctermfg=red

" Ctrlp related stuff
let g:ctrlp_map = '<c-p>'
let g:ctlrp_cmd = 'CtrlP'

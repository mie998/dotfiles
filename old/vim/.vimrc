if has('vim_starting')
   set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" NeoBundle plugins
NeoBundle 'easymotion/vim-easymotion'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-commentary'

call neobundle#end()
NeoBundleCheck

syntax enable
filetype plugin indent on

set fenc=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd

set number
set cursorline
set virtualedit=onemore
set smartindent
set visualbell
set showmatch
set laststatus=2
set wildmode=list:longest

nnoremap j gj
nnoremap k gk
nnoremap H 10h
nnoremap J 10j
nnoremap K 10k
nnoremap L 10l

" Set molokai theme ref: http://pyoonn.hatenablog.com/entry/2014/10/04/225321
autocmd colorscheme molokai highlight Visual ctermbg=8
colorscheme molokai
set background=dark

set list listchars=tab:\▸\-
set expandtab
set tabstop=4
set shiftwidth=4

set ignorecase
set smartcase
set noincsearch
set wrapscan
set hlsearch

let &t_ti .= "\e[1 q"
let &t_SI .= "\e[5 q"
let &t_EI .= "\e[1 q"
let &t_te .= "\e[0 q"

let mapleader="\<Space>"
nmap <Esc><Esc> :nohlsearch<CR><Esc>
set whichwrap=b,s,[,],<,>
inoremap <silent> jj <Esc>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <Esc> I
inoremap <C-e> <Esc> A

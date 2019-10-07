
syntax on
filetype plugin on

if has('vim_starting')
   set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundle 'easymotion/vim-easymotion'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-commentary'

call neobundle#end()
NeoBundleCheck

""" Options """
set fenc=utf-8
set hidden
set autoread
set showcmd
" Indentation
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set list listchars=tab:\▸\-
set expandtab
set shiftround
set smarttab
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%
" Views
set title
set number
set relativenumber
set cursorline
set showmatch
set laststatus=2
set showtabline=2
set statusline=%F%m\ %<[%{&fenc!=''?&fenc:&enc}]\ [%Y]\ [ln:%l,col:%v]
set smartindent
set virtualedit=onemore
set visualbell
set wildmode=list:longest
" Controls
set mouse=a
set whichwrap=b,s,h,l,<,>,[,],~
" Search
set hlsearch
set incsearch
set smartcase
set ignorecase
set wrapscan
" Split
set splitbelow
set splitright
" Backspace
set backspace=indent,eol,start
" Menu
set wildmenu
set wildmode=longest:full,full

" .viminfo
set viminfo+=n~/.local/share/vim/viminfo

""" Keymaps """
nnoremap <silent>j      gj
nnoremap <silent>k      gk
nnoremap <silent><Down> gj
nnoremap <silent><Up>   gk
nnoremap j gj
nnoremap k gk
nnoremap H 10h
nnoremap J 10j
nnoremap K 10k
nnoremap L 10l
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

augroup MyKeyMaps
    autocmd!
    autocmd FileType html inoremap <buffer></ </<C-x><C-o>
augroup END

""" molokai theme
" 参考: http://pyoonn.hatenablog.com/entry/2014/10/04/225321
autocmd colorscheme molokai highlight Visual ctermbg=8
colorscheme molokai
set background=dark

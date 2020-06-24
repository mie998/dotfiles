." setting
" ファイルタイプ検出
filetype plugin indent on
"文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd


" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest

" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" vim高速移動
nnoremap H 10h
nnoremap J 10j
nnoremap K 10k
nnoremap L 10l
" シンタックスハイライトの有効化
syntax enable

" moloakiはビジュアルモードが見づらいのでそれだけ色を変更
" 参考: http://pyoonn.hatenablog.com/entry/2014/10/04/225321
autocmd colorscheme molokai highlight Visual ctermbg=8
" カラースキーム
colorscheme molokai
" ダーク系のカラースキームを使う
set background=dark

" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=4
" 行頭でのTab文字の表示幅
set shiftwidth=4


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" インクリメンタルサーチをしない
set noincsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch

" キーバインド
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>
" カーソルの回り込みを許可
set whichwrap=b,s,[,],<,>
"j連打でエスケープ"
inoremap <silent> jj <Esc>
" 入力モードでのカーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
" insert mode では emacs系キーバインド
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <Esc> I
inoremap <C-e> <Esc> A


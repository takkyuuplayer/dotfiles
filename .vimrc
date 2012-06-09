syntax on

"-------------------------------------------------
" vundur
"-------------------------------------------------
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neocomplcache-snippets-complete'
Bundle 'thinca/vim-ref'
Bundle 'thinca/vim-quickrun'
" Tab補完
Bundle 'SuperTab'
" :w sudo:%
Bundle 'sudo.vim'
Bundle 'mattn/zencoding-vim'
Bundle 'tpope/vim-fugitive'
filetype on
filetype plugin indent on     " required!

" neocomplcache
" -------------------------------------
let g:neocomplcache_enable_at_startup = 1
" 大文字小文字区別の有効化
let g:neocomplcache_smartcase = 1
" キャメルケース補完の有効化
let g:neocomplcache_enablecamelcasecompletion = 1
" アンダーバー補完の有効化
let g:neocomplcache_enableunderbarcompletion = 1
" 補完対象キーワードの最小長
let g:neocomplcache_min_syntax_length = 3
" プラグイン毎の補完関数を呼び出す文字数
let g:neocomplcache_plugincompletionlength = {
  \ 'keyword_complete' : 2,
  \ 'syntax_complete' : 2
  \ }
" ファイルタイプ毎の辞書ファイルの場所
let g:neocomplcache_dictionary_filetype_lists = { 
  \ 'default' : '', 
  \ }
" 補完候補が表示されている場合は確定。そうでない場合は改行
inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"
" 補完をキャンセル
inoremap <expr><C-e>  neocomplcache#close_popup()

"-------------------------------------------------
" quick run
"-------------------------------------------------
"augroup QuickRunPHPUnit
"  autocmd!
"  autocmd BufWinEnter,BufNewFile *Test.php set filetype=php.unit
"augroup END

" 初期化
"let g:quickrun_config = {}
" PHPUnit
"let g:quickrun_config['php.unit'] = {'command': 'phpunit'}

"-------------------------------------------------
" setting
"-------------------------------------------------
"indent
set autoindent
"set nosmartindent
"ファイル保存ダイアログの初期ディレクトリをバッファファイル位置に設定
set browsedir=buffer 
"クリップボードをWindowsと連携
set clipboard=unnamed
"Vi互換をオフ
set nocompatible
"タブの代わりに空白文字を挿入する
set expandtab
"変更中のファイルでも、保存しないで他のファイルを表示
set hidden
"インクリメンタルサーチを行う
set incsearch
"listで表示される文字のフォーマットを指定する
set list
set listchars=tab:>-,trail:^
"set listchars=eol:$,tab:>\ ,extends:<
"行番号を表示する
set number
"シフト移動幅
set shiftwidth=4
"閉じ括弧が入力されたとき、対応する括弧を表示する
set showmatch
"検索時に大文字を含んでいたら大/小を区別
set smartcase
"行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする。
set smarttab
"ファイル内の <Tab> が対応する空白の数
set tabstop=4
"カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
"検索をファイルの先頭へループしない
set nowrapscan
"カーソルライン
set cursorline
"highlight search
set hlsearch
"Status Line
set laststatus=2
set statusline=%f\ [%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
"tanew, sp autocomplete
set wildmode=list:longest
"backup files"
set nobackup
set noswapfile
"alert
set novisualbell

"----------------------------------------------------
" テンプレート補完
"----------------------------------------------------
autocmd BufNewFile * silent! 0r $HOME/.vim/template/%:e.txt

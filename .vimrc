syntax on
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis

"-------------------------------------------------
" Auto Reload
"-------------------------------------------------
" Set augroup.
augroup MyAutoCmd
    autocmd!
augroup END

if !has('gui_running') && !(has('win32') || has('win64'))
    autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
else
    autocmd MyAutoCmd BufWritePost $MYVIMRC source $MYVIMRC |
                \if has('gui_running') | source $MYGVIMRC
    autocmd MyAutoCmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC
endif

"-------------------------------------------------
" NeoBundle
"-------------------------------------------------
set nocompatible               " be iMproved
filetype off                   " required!
filetype plugin indent off     " required!

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#rc(expand('~/.vim/bundle/'))
endif
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Sixeight/unite-grep'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
" Tab補完
NeoBundle 'SuperTab'
" :w sudo:%
NeoBundle 'sudo.vim'
NeoBundle 'mattn/zencoding-vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'soh335/vim-symfony'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'vim-scripts/autodate.vim'
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

" unite.vim
"-------------------------------------------------
"call unite#custom_default_action('file', 'tabopen')
nnoremap <silent> <C-O><C-O> :<C-U>Unite -buffer-name=files file<CR>
nnoremap <silent> <C-O><C-F> :<C-U>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <C-O><C-N> :<C-U>Unite -buffer-name=files file/new<CR>
nnoremap <silent> <C-O><C-H> :<C-U>Unite -buffer-name=files file_mru<CR>
nnoremap <silent> <C-O><C-G> :<C-U>Unite -buffer-name=files buffer<CR>

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
set ignorecase
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
"backspace
set backspace=indent,eol,start
"Windows <CR>
set ffs=unix
" <F2> to paste mode.
set pastetoggle=<F2>

"----------------------------------------------------
" key mapping
"----------------------------------------------------
noremap  
noremap!  
noremap <BS> 
noremap! <BS> 
nmap <silent> <Esc><Esc> :nohlsearch<CR><Esc>
nmap <silent> <C-{><C-{> :nohlsearch<CR><C-{>

"----------------------------------------------------
" テンプレート補完
"----------------------------------------------------
autocmd BufNewFile *.sh silent! 0r $HOME/.vim/templates/sh.txt

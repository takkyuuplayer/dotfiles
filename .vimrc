
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

"-------------------------------------------------
" setting
"-------------------------------------------------

"新しい行のインデントを現在行と同じにする
"set autoindent
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
set listchars=eol:$,tab:>\ ,extends:<
"行番号を表示する
set number
"シフト移動幅
set shiftwidth=4
"閉じ括弧が入力されたとき、対応する括弧を表示する
set showmatch
"検索時に大文字を含んでいたら大/小を区別
set smartcase
"新しい行を作ったときに高度な自動インデントを行う
"set smartindent
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

"----------------------------------------------------
" テンプレート補完
"----------------------------------------------------
autocmd BufNewFile * silent! 0r $HOME/.vim/template/%:e.txt

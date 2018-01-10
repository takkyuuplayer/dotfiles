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
" dein.vim
"-------------------------------------------------

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if &compatible
  set nocompatible
endif

let s:toml_file = expand('~/.vim/dein.toml')
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [$MYVIMRC, s:toml_file])
  call dein#add(s:dein_repo_dir)
  call dein#load_toml(s:toml_file, {'lazy': 0})
  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on

"-------------------------------------------------
" plugin
"-------------------------------------------------

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

" neosnippet
"-------------------------------------------------
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
let g:neosnippet#enable_snipmate_compatibility = 1
let s:vim_snippets_dir = s:dein_dir . '/repos/github.com/honza/vim-snippets/snippets'

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif


" quick run
"-------------------------------------------------
"初期化
let g:quickrun_config = {}

"vimproc
let g:quickrun_config['_'] = {}
let g:quickrun_config['_']['runner'] = 'vimproc'
let g:quickrun_config['_']['runner/vimproc/updatetime'] = 100

""phpunit
augroup QuickRunPHPUnit
  autocmd!
  autocmd BufWinEnter,BufNewFile *Test.php set filetype=php.unit
augroup END
let g:quickrun_config['php.unit'] = {}
"let g:quickrun_config['php.unit']['outputter/buffer/split'] = 'vertical 35'
let g:quickrun_config['php.unit']['command'] = './vendor/bin/phpunit'
let g:quickrun_config['php.unit']['cmdopt'] = ''
let g:quickrun_config['php.unit']['exec'] = '%c %o %s'

"prove
augroup QuickRunProve
    autocmd!
    autocmd BufWinEnter,BufNewFile *.t set filetype=perl.unit
augroup END
let g:quickrun_config['perl.unit'] = {}
let g:quickrun_config['perl.unit']['command'] = 'carton'
let g:quickrun_config['perl.unit']['cmdopt'] = 'exec -- perl -Ilib'
let g:quickrun_config['perl.unit']['exec'] = '%c %o %s'

"perl debug
let g:quickrun_config['perl'] = {}
let g:quickrun_config['perl']['command'] = 'carton'
let g:quickrun_config['perl']['cmdopt'] = 'exec -- perl -Ilib'
let g:quickrun_config['perl']['exec'] = '%c %o %s'

"gosh
let g:quickrun_config['scm'] = {}
let g:quickrun_config['scm']['command'] = 'gosh'
let g:quickrun_config['scm']['cmdopt'] = ''
let g:quickrun_config['scm']['exec'] = '%c %o %s'

"coffee
let g:quickrun_config['coffee'] = {}
let g:quickrun_config['coffee']['command'] = 'coffee'
let g:quickrun_config['coffee']['cmdopt'] = ''
let g:quickrun_config['coffee']['exec'] = '%c %o %s'

"javascript
let g:quickrun_config['javascript'] = {}
let g:quickrun_config['javascript']['command'] = './node_modules/.bin/babel-node'
let g:quickrun_config['javascript']['cmdopt'] = ''
let g:quickrun_config['javascript']['exec'] = '%c %o %s'

"mocha
augroup QuickRunMocha
  autocmd!

  " javascript
  autocmd BufWinEnter,BufNewFile *.spec.js,*.spec.jsx,*.spec.es6 silent! set filetype=javascript.unit
  let g:quickrun_config['javascript.unit'] = {}
  let g:quickrun_config['javascript.unit']['command'] = './node_modules/.bin/mocha'
  let g:quickrun_config['javascript.unit']['cmdopt'] = ''
  let g:quickrun_config['javascript.unit']['exec'] = '%c %o %s'

  " type script
  autocmd BufWinEnter,BufNewFile *.spec.ts set filetype=typescript.unit
  let g:quickrun_config['typescript.unit'] = {}
  let g:quickrun_config['typescript.unit']['command'] = './node_modules/.bin/mocha'
  let g:quickrun_config['typescript.unit']['cmdopt'] = '--compilers ts:espower-typescript/guess'
  let g:quickrun_config['typescript.unit']['exec'] = '%c %o %s'
augroup END


" unite.vim
"-------------------------------------------------
"call unite#custom_default_action('file', 'tabopen')
nnoremap <silent> <C-O><C-O> :<C-U>Unite -buffer-name=files file bookmark file/new<CR>
nnoremap <silent> <C-O><C-F> :<C-U>UniteWithBufferDir -buffer-name=files file bookmark file/new<CR>
nnoremap <silent> <C-O><C-N> :<C-U>Unite -buffer-name=files file/new<CR>
nnoremap <silent> <C-O><C-H> :<C-U>Unite -buffer-name=files file_mru<CR>
nnoremap <silent> <C-O> :<C-U>Unite -buffer-name=files file_mru<CR>
nnoremap <silent> <C-O><C-G> :<C-U>Unite -buffer-name=files buffer<CR>

" ale
"-------------------------------------------------
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'php': [],
\}
let g:ale_set_highlights = 0

" NERDTree
"-------------------------------------------------
nnoremap <silent><C-e> :NERDTreeToggle<CR>

" go-vim
"-------------------------------------------------
let g:go_fmt_command = "goimports"

"-------------------------------------------------
" setting
"-------------------------------------------------
set backspace=indent,eol,start
set browsedir=buffer
set clipboard-=autoselect
set cursorline
set expandtab
set ffs=unix
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:>_,trail:^
set nobackup
set nocompatible
set noswapfile
set novisualbell
set nowrapscan
set number
set pastetoggle=<F2>
set shiftwidth=4
set showmatch
set smartcase
set smarttab
set statusline=%f\ [%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set tabstop=4
set whichwrap=b,s,h,l,<,>,[,]
set wildmode=list:longest

""-------------------------------------------------------------------------------
" Mapping <jump-tag>
"-------------------------------------------------------------------------------
" コマンド       ノーマルモード 挿入モード コマンドラインモード ビジュアルモード
" map/noremap           @            -              -                  @
" nmap/nnoremap         @            -              -                  -
" imap/inoremap         -            @              -                  -
" cmap/cnoremap         -            -              @                  -
" vmap/vnoremap         -            -              -                  @
" map!/noremap!         -            @              @                  -
"-------------------------------------------------------------------------------
" perl like express
nnoremap / /\v
vnoremap / /\v
noremap  
noremap!  
noremap <BS> 
noremap! <BS> 
nmap <silent> <Esc><Esc> :nohlsearch<CR><Esc>
nmap <silent> <C-{><C-{> :nohlsearch<CR><C-{>
" in normal mode, ; -> :
nnoremap ; :
map ,pb <Esc>:%! pbcopy;pbpaste<CR>
map ,pbv <Esc>:'<,'>! pbcopy;pbpaste<CR>

"----------------------------------------------------
" テンプレート補完
"----------------------------------------------------
autocmd BufNewFile,BufReadPost *.rb,*.coffee silent! setl shiftwidth=2 tabstop=2
autocmd BufNewFile *.tx silent! setl ft=html
au BufNewFile,BufRead *.tx set filetype=html
au BufNewFile,BufRead cpanfile,*.psgi set filetype=perl

autocmd BufNewFile *.pm call s:pm_template()
au! BufWritePost *.pm call s:check_package_name()

"----------------------------------------------------
" Additional Functions
"----------------------------------------------------

" perl package name
function! s:pm_template()
    let path = substitute(expand('%'), '.*lib/', '', 'g')
    let path = substitute(path, '[\\/]', '::', 'g')
    let path = substitute(path, '\.pm$', '', 'g')

    call append(0, 'package ' . path . ';')
    call append(1, 'use common::sense;')
    call append(2, '')
    call append(3, '')
    call append(4, '')
    call append(5, '1;')
    call cursor(6, 0)
    " echomsg path
endfunction

function! s:get_package_name()
    let mx = '^\s*package\s\+\([^ ;]\+\)'
    for line in getline(1, 5)
        if line =~ mx
            return substitute(matchstr(line, mx), mx, '\1', '')
        endif
    endfor
    return ""
endfunction

function! s:check_package_name()
    let path = substitute(expand('%:p'), '\\', '/', 'g')
    let name = substitute(s:get_package_name(), '::', '/', 'g') . '.pm'
    if path[-len(name):] != name
        echohl WarningMsg
        echomsg "ぱっけーじめいと、ほぞんされているぱすが、ちがうきがします！"
        echomsg "ちゃんとなおしてください＞＜"
        echohl None
    endif
endfunction

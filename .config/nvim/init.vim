syntax on
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis

"-------------------------------------------------
" Global Settings
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
set splitbelow
set splitright
set statusline=%f\ [%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set tabstop=4
set tags=.git/tags;~
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
"map <C-]> <Esc>g<C-]>
" 行頭へ
inoremap <C-a> <Esc>^a
noremap <C-a> <Esc>^a
" 行末へ
inoremap <C-e> <Esc>$a
noremap <C-e> <Esc>$a

augroup FileTyping
    autocmd!
    autocmd BufNewFile,BufRead *.coffee set filetype=coffee
    autocmd BufNewFile,BufRead *.crontab set filetype=crontab
    autocmd BufNewFile,BufRead *.go set filetype=go
    autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
    autocmd BufNewFile,BufRead *.md set filetype=markdown
    autocmd BufNewFile,BufRead *.psgi set filetype=perl
    autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
    autocmd BufNewFile,BufRead *.twig set filetype=html
    autocmd BufNewFile,BufRead *.tx set filetype=html
    autocmd BufNewFile,BufRead cpanfile set filetype=perl

    autocmd BufNewFile,BufRead *.spec.js set filetype=javascript.unit
    autocmd BufNewFile,BufRead *.spec.jsx set filetype=javascript.unit
    autocmd BufNewFile,BufRead *.t set filetype=perl.unit
    autocmd BufNewFile,BufRead *_spec.rb set filetype=ruby.spec
    autocmd BufNewFile,BufRead *_test.rb set filetype=ruby.unit
    autocmd BufNewFile,BufRead *_test.go set filetype=go.unit
    autocmd BufNewFile,BufRead *Test.php set filetype=php.unit
augroup END

" disable default plugins
"-------------------------------------------------
let g:loaded_2html_plugin      = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
let g:loaded_logiPat           = 1
let g:loaded_man               = 1
let g:loaded_matchit           = 1
let g:loaded_matchparen        = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_rrhelper          = 1
let g:loaded_shada_plugin      = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_tarPlugin         = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zipPlugin         = 1

"-------------------------------------------------
" plugin (manager: dein.vim)
"-------------------------------------------------
let s:dein_dir = has('nvim') ? expand('~/.cache/dein/nvim') : expand('~/.cache/dein/vim')
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

" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
" }}}

filetype plugin indent on

" denite.vim
"-------------------------------------------------
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> a
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> o
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> I
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> A
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> O
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
  nnoremap <silent><buffer><expr> <Tab>
  \ denite#do_map('choose_action')
endfunction

nnoremap <silent> <C-O><C-F> :<C-U>DeniteBufferDir file file:new<CR>
nnoremap <silent> <C-O><C-G> :<C-U>Denite buffer<CR>
nnoremap <silent> <C-O><C-H> :<C-U>Denite file_mru<CR>
nnoremap <silent> <C-O><C-O> :<C-U>Denite file file:new<CR>

" deoplete.vim
"-------------------------------------------------
let g:deoplete#enable_at_startup = 1

" quick run
"-------------------------------------------------
nnoremap <silent> \r :<C-U>QuickRun<CR>
let g:quickrun_config = {}
let g:quickrun_config._ = {
      \ 'outputter' : 'error',
      \ 'outputter/error/success' : 'buffer',
      \ 'outputter/error/error'   : 'quickfix',
      \ 'outputter/buffer/split'  : ':righttop 8sp',
      \ 'outputter/buffer/close_on_empty' : 1,
      \ }

"vimproc
let g:quickrun_config['_'] = {}
let g:quickrun_config['_']['runner'] = 'vimproc'
let g:quickrun_config['_']['runner/vimproc/updatetime'] = 100

""phpunit
let g:quickrun_config['php.unit'] = {}
let g:quickrun_config['php.unit']['command'] = 'phpunit'
let g:quickrun_config['php.unit']['cmdopt'] = '' "'--debug --verbose'
let g:quickrun_config['php.unit']['exec'] = '%c %o %s'

"prove
let g:quickrun_config['perl.unit'] = {}
let g:quickrun_config['perl.unit']['command'] = 'carton'
let g:quickrun_config['perl.unit']['cmdopt'] = 'exec -- perl -Ilib'
let g:quickrun_config['perl.unit']['exec'] = '%c %o %s'

"perl
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
let g:quickrun_config['javascript.jsx'] = {}
let g:quickrun_config['javascript.jsx']['command'] = 'babel-node'
let g:quickrun_config['javascript.jsx']['cmdopt'] = ''
let g:quickrun_config['javascript.jsx']['exec'] = '%c %o %s'

"jest
let g:quickrun_config['javascript.unit'] = {}
let g:quickrun_config['javascript.unit']['command'] = './node_modules/.bin/jest'
let g:quickrun_config['javascript.unit']['cmdopt'] = ''
let g:quickrun_config['javascript.unit']['exec'] = '%c %o %s'

"ruby
let g:quickrun_config['ruby.spec'] = {}
let g:quickrun_config['ruby.spec']['command'] = 'bundle'
let g:quickrun_config['ruby.spec']['cmdopt'] = 'exec -- rspec'
let g:quickrun_config['ruby.spec']['exec'] = '%c %o %s'

let g:quickrun_config['ruby.unit'] = {}
let g:quickrun_config['ruby.unit']['command'] = 'bundle'
let g:quickrun_config['ruby.unit']['cmdopt'] = 'exec -- ruby'
let g:quickrun_config['ruby.unit']['exec'] = '%c %o %s'

"go
let g:quickrun_config['go.unit'] = {}
let g:quickrun_config['go.unit']['command'] = 'go'
let g:quickrun_config['go.unit']['cmdopt'] = 'test -v'
let g:quickrun_config['go.unit']['exec'] = '%c %o %s'

" vim-lsp
"-------------------------------------------------
autocmd BufWritePre <buffer> LspDocumentFormatSync
map ,ct <Esc>:LspDocumentFormat<CR>
map ,ctv <Esc>:LspDocumentRangeFormat<CR>
noremap <C-]> <Esc>:LspDefinition<CR>


" vim-gist
"-------------------------------------------------
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_post_private = 1

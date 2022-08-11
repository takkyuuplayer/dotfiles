vim.bo.autoindent = true
vim.bo.autoread = true
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.smartindent = true
vim.bo.tabstop = 2

vim.o.fileencodings='utf-8,iso-2022-jp,euc-jp,sjis'
vim.o.helplang = 'ja,en'
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.list=true
vim.o.pastetoggle='<F2>'
vim.o.smartcase = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.updatetime = 300
vim.o.visualbell = false
vim.o.writebackup = false

vim.wo.cursorline = true
vim.wo.number = true
vim.wo.signcolumn = 'yes'

vim.g.mapleader = ','

local function map(mode, lhs, rhs, opts)
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts and opts or { noremap = true })
end

map('', '/', "/\\v") -- perl like search
map('n', ';', ':')
map('', '<esc><esc>', ':nohlsearch<cr><esc>', { noremap = true, silent = true })
map('', '<C-{><C-{>', ':nohlsearch<cr><esc>', { noremap = true, silent = true })

if os.execute('uname -a | grep Darwin') ~= '' then
  map('', '<leader>pb', '<Esc>:%! pbcopy;pbpaste<CR>')
  map('', '<leader>pbv', "<Esc>:'<,'>%! pbcopy;pbpaste<CR>")
end

-- https://stackoverflow.com/questions/630884/opening-vim-help-in-a-vertical-split-window
vim.cmd('autocmd FileType help wincmd L')

-- https://wonwon-eater.com/neovim-susume-plugin-manager/
local dein_dir = vim.fn.expand('~/.cache/nvim/dein')
local dein_repo_dir = dein_dir..'/repos/github.com/Shougo/dein.vim'

vim.o.runtimepath = dein_repo_dir..','..vim.o.runtimepath

-- dein install check
if (vim.fn.isdirectory(dein_repo_dir) == 0) then
  os.execute('git clone https://github.com/Shougo/dein.vim '..dein_repo_dir)
end

-- begin settings
if (vim.fn['dein#load_state'](dein_dir) == 1) then
  local rc_dir = vim.fn.expand('~/.config/nvim')
  local toml = rc_dir..'/dein.toml'
  vim.fn['dein#begin'](dein_dir)
  vim.fn['dein#load_toml'](toml, { lazy = 0 })
  vim.fn['dein#end']()
  vim.fn['dein#save_state']()
end

-- plugin install check
if (vim.fn['dein#check_install']() ~= 0) then
  vim.fn['dein#install']()
end

-- plugin remove check
local removed_plugins = vim.fn['dein#check_clean']()
if vim.fn.len(removed_plugins) > 0 then
  vim.fn.map(removed_plugins, "delete(v:val, 'rf')")
  vim.fn['dein#recache_runtimepath']()
end

vim.cmd('filetype plugin indent on')

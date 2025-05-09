vim.bo.autoindent = true
vim.bo.autoread = true
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.smartindent = true
vim.bo.tabstop = 2

vim.o.fileencodings = 'utf-8,iso-2022-jp,euc-jp,sjis'
vim.o.helplang = 'ja,en'
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.list = true
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
vim.wo.statusline = "%f [%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L %P"

vim.g.mapleader = ','

local function map(mode, lhs, rhs, opts)
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts and opts or { noremap = true })
end

map('', '/', "/\\v") -- perl like search
map('n', ';', ':')
map('', '<esc><esc>', ':nohlsearch<cr><esc>', { noremap = true, silent = true })
map('', '<C-{><C-{>', ':nohlsearch<cr><esc>', { noremap = true, silent = true })

-- pastetoggle https://stackoverflow.com/questions/76687544/emulate-pastetoggle-in-neovim
map('n', '<f2>', ':set paste!<cr>', { noremap = true, silent = true })
map('i', '<f2> <esc>', ':set paste!<cr>i', { noremap = true, silent = true })

if os.execute('uname -a | grep Darwin') ~= '' then
  map('', '<leader>pb', '<Esc>:%! pbcopy;pbpaste<CR>')
  map('', '<leader>pbv', "<Esc>:'<,'>%! pbcopy;pbpaste<CR>")
end

-- https://stackoverflow.com/questions/630884/opening-vim-help-in-a-vertical-split-window
vim.cmd('autocmd FileType help wincmd L')

-- https://wonwon-eater.com/neovim-susume-plugin-manager/
local dein_dir = vim.fn.expand('~/.cache/nvim/dein')
local dein_repo_dir = dein_dir .. '/repos/github.com/Shougo/dein.vim'

vim.o.runtimepath = dein_repo_dir .. ',' .. vim.o.runtimepath

-- dein install check
if (vim.fn.isdirectory(dein_repo_dir) == 0) then
  os.execute('git clone https://github.com/Shougo/dein.vim ' .. dein_repo_dir)
end

-- begin settings
if (vim.fn['dein#load_state'](dein_dir) == 1) then
  local rc_dir = vim.fn.expand('~/.config/nvim')
  local toml = rc_dir .. '/dein.toml'
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

-- plugin update check
local update_interval_days = 7
local last_update_file = vim.fn.expand("~/.cache/nvim/dein_last_update")

local function should_update()
  local stat = vim.loop.fs_stat(last_update_file)
  if not stat then
    return true
  end

  local last = stat.mtime.sec
  local now = os.time()
  return now - last > update_interval_days * 24 * 60 * 60
end

local function mark_updated()
  local fd = assert(io.open(last_update_file, "w"))
  fd:write("") -- 空ファイルとして保存（タイムスタンプが重要）
  fd:close()
end

if should_update() then
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.cmd("call dein#update()")
      mark_updated()
    end,
  })
end

vim.cmd('filetype plugin indent on')

-- https://zenn.dev/botamotch/articles/21073d78bc68bf
-- 1. LSP Sever management
require('mason').setup()
require('mason-lspconfig').setup_handlers({ function(server)
  local opt = {
    -- Function executed when the LSP server startup
    on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true }

      if client.server_capabilities.hoverProvider then
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      end

      if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("Format", { clear = true }),
          buffer = bufnr,
          callback = function() vim.lsp.buf.format() end
        })
      end

      if client.server_capabilities.documentHighlightProvider then
        local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", {})

        vim.opt.updatetime = 1000

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = bufnr,
          group = group,
          callback = function()
            vim.lsp.buf.document_highlight()
          end,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
          buffer = bufnr,
          group = group,
          callback = function()
            vim.lsp.buf.clear_references()
          end,
        })
      end
    end,
    capabilities = require('cmp_nvim_lsp').default_capabilities()
  }
  require('lspconfig')[server].setup(opt)
end })

-- 2. build-in LSP function
-- keyboard shortcut
vim.keymap.set('n', '<leader>K', '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', '<leader>gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
vim.keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
vim.keymap.set('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
vim.keymap.set('n', '<leader>gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', '<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', '<leader>ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', '<leader>g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', '<leader>g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
-- LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)

-- 3. completion (hrsh7th/nvim-cmp)
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ['<C-l>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  }),
  experimental = {
    ghost_text = true,
  },
})
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "path" },
    { name = "cmdline" },
  },
})

-- 4. my own

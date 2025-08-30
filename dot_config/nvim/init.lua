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

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Japanese documentation
  { "vim-jp/vimdoc-ja" },

  -- Theme
  {
    "ayu-theme/ayu-vim",
    config = function()
      vim.cmd([[
        set termguicolors
        let ayucolor="dark"
        colorscheme ayu
      ]])
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = 'auto',
          component_separators = {'', ''},
          section_separators = {'', ''},
          disabled_filetypes = {}
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch'},
          lualine_c = {
            {
              'filename',
              path = 1,
              'g:coc_status',
            }
          },
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {{'filename', path = 1}},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = {}
      }
    end,
  },

  -- Testing
  {
    "vim-test/vim-test",
    dependencies = { "kassio/neoterm" },
    config = function()
      vim.cmd([[
        nmap <silent> <leader>tn <cmd>update<cr><cmd>exec v:count.'Tclear'<cr><cmd>TestNearest<CR>
        nmap <silent> <leader>tf <cmd>update<cr><cmd>exec v:count.'Tclear'<cr><cmd>TestFile<CR>

        let g:neoterm_default_mod='vert botright'
        let g:neoterm_keep_term_open = 0
        let g:neoterm_autoscroll = 1
        let g:test#strategy = 'neoterm'
      ]])
    end,
  },
  { "kassio/neoterm" },

  -- File explorer
  {
    "lambdalisue/fern.vim",
    config = function()
      vim.cmd([[
        let g:fern#default_hidden = 1
        nnoremap <leader>ef <cmd>Fern . -toggle -reveal=% -drawer<cr>
        nnoremap <leader>eo <cmd>Fern . -toggle -reveal=. -drawer<cr>
      ]])
    end,
  },

  -- Fuzzy finder
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.cmd([[
        nnoremap <leader>p <cmd>Telescope find_files hidden=true theme=get_dropdown<cr>
        nnoremap <leader>gr <cmd>Telescope live_grep theme=get_dropdown<cr>
        nnoremap <leader>b <cmd>Telescope buffers theme=get_dropdown<cr>
        nnoremap <leader>h <cmd>Telescope oldfiles theme=get_dropdown<cr>
        nnoremap <leader>gb <cmd>Telescope git_branches theme=get_dropdown<cr>
      ]])
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    build = "make",
    config = function()
      require('telescope').setup{
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = false,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      }
      require('telescope').load_extension('fzf')
    end,
  },

  -- Utility plugins
  { "vim-scripts/sudo.vim" },
  { "travisjeffery/vim-auto-mkdir" },
  { "vim-scripts/YankRing.vim" },
  { "nathanaelkane/vim-indent-guides" },

  -- Git integration
  { "tpope/vim-fugitive" },
  {
    "tpope/vim-rhubarb",
    config = function()
      vim.api.nvim_set_keymap('', '<leader>gh', "<Esc>:0GBrowse<CR>", { noremap = true })
    end,
  },

  -- AI assistance
  { "github/copilot.vim" },

  -- LSP and completion
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/vim-vsnip" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-cmdline" },
  { "jose-elias-alvarez/null-ls.nvim" },
})

vim.cmd('filetype plugin indent on')

-- https://zenn.dev/botamotch/articles/21073d78bc68bf
-- 1. LSP Sever management
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {}, -- Install servers automatically if needed
})

-- Setup LSP servers
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
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
end

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

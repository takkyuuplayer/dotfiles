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

local map = vim.keymap.set

map('', '/', "/\\v") -- perl like search
map('n', ';', ':')
map('', '<esc><esc>', ':nohlsearch<cr><esc>', { silent = true })
map('', '<C-{><C-{>', ':nohlsearch<cr><esc>', { silent = true })

-- pastetoggle https://stackoverflow.com/questions/76687544/emulate-pastetoggle-in-neovim
map('n', '<f2>', ':set paste!<cr>', { silent = true })
map('i', '<f2> <esc>', ':set paste!<cr>i', { silent = true })

if vim.fn.has('mac') == 1 then
  map('', '<leader>pb', '<Esc>:%! pbcopy;pbpaste<CR>')
  map('', '<leader>pbv', "<Esc>:'<,'>%! pbcopy;pbpaste<CR>")
end

-- https://stackoverflow.com/questions/630884/opening-vim-help-in-a-vertical-split-window
vim.cmd('autocmd FileType help wincmd L')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
      vim.g.ayucolor = 'dark'
      vim.cmd.colorscheme('ayu')
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
      vim.g.neoterm_default_mod = 'vert botright'
      vim.g.neoterm_keep_term_open = 0
      vim.g.neoterm_autoscroll = 1
      vim.g['test#strategy'] = 'neoterm'

      map('n', '<leader>tn', "<cmd>update<cr><cmd>exec v:count.'Tclear'<cr><cmd>TestNearest<CR>", { silent = true })
      map('n', '<leader>tf', "<cmd>update<cr><cmd>exec v:count.'Tclear'<cr><cmd>TestFile<CR>", { silent = true })
    end,
  },
  -- File explorer
  {
    "lambdalisue/fern.vim",
    config = function()
      vim.g['fern#default_hidden'] = 1

      map('n', '<leader>ef', '<cmd>Fern . -toggle -reveal=% -drawer<cr>')
      map('n', '<leader>eo', '<cmd>Fern . -toggle -reveal=. -drawer<cr>')
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
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

      map('n', '<leader>p', '<cmd>Telescope find_files hidden=true theme=get_dropdown<cr>')
      map('n', '<leader>gr', '<cmd>Telescope live_grep theme=get_dropdown<cr>')
      map('n', '<leader>b', '<cmd>Telescope buffers theme=get_dropdown<cr>')
      map('n', '<leader>h', '<cmd>Telescope oldfiles theme=get_dropdown<cr>')
      map('n', '<leader>gb', '<cmd>Telescope git_branches theme=get_dropdown<cr>')
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    build = "make",
    config = function()
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
      map('', '<leader>gh', '<Esc>:0GBrowse<CR>')
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
})

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
  if client.server_capabilities.hoverProvider then
    map('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, silent = true })
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
map('n', '<leader>K', vim.lsp.buf.hover)
map('n', '<leader>gf', vim.lsp.buf.format)
map('n', '<leader>gr', vim.lsp.buf.references)
map('n', '<leader>gd', vim.lsp.buf.definition)
map('n', '<C-]>', vim.lsp.buf.definition)
map('n', '<leader>gD', vim.lsp.buf.declaration)
map('n', '<leader>gi', vim.lsp.buf.implementation)
map('n', '<leader>gt', vim.lsp.buf.type_definition)
map('n', '<leader>gn', vim.lsp.buf.rename)
map('n', '<leader>ga', vim.lsp.buf.code_action)
map('n', '<leader>ge', vim.diagnostic.open_float)
map('n', '<leader>g]', vim.diagnostic.goto_next)
map('n', '<leader>g[', vim.diagnostic.goto_prev)
-- Diagnostic display config
vim.diagnostic.config({ virtual_text = false })

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

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- 4. my own

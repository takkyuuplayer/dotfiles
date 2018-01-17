setl shiftwidth=4
setl tabstop=4
map ,ct <Esc>:%! phpcbf<CR>
map ,ctv <Esc>:'<,'>! phpcbf<CR>

:NeoSnippetSource ~/.cache/dein/repos/github.com/honza/vim-snippets/snippets/codeigniter.snippets
let g:pdv_template_dir = $HOME . "/.cache/dein/repos/github.com/tobyS/pdv/templates_snip"
nnoremap <buffer> <C-p> :call pdv#DocumentCurrentLine()<CR>

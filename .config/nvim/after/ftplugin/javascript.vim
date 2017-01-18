setl shiftwidth=2
setl tabstop=2

map ,ct <Esc>:%! $(npm bin)/eslint-fix<CR>
map ,ctv <Esc>:'<,'>! $(npm bin)/eslint-fix<CR>

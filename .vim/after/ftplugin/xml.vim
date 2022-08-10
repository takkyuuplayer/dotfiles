setl shiftwidth=2
setl tabstop=2

map ,ct <Esc>:%!xmllint -format -<CR>
map ,ctv <Esc>:'<,'>!xmllint --format -<CR>


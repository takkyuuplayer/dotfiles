setl shiftwidth=2
setl tabstop=2

map ,ct  :call JsonBeautify()<cr>
map <buffer> ,ctv :call RangeJsonBeautify()<cr>



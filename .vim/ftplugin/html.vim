setl shiftwidth=2
setl tabstop=2

map ,ct  :call HtmlBeautify()<cr>
map <buffer> ,ctv :call RangeHtmlBeautify()<cr>

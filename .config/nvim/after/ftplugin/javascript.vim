setl shiftwidth=2
setl tabstop=2

map ,ct  :call JsBeautify()<cr>
map <buffer> ,ctv :call RangeJsBeautify()<cr>


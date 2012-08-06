if exists("b:current_syntax")
  finish
endif
 
if !exists("main_syntax")
  let main_syntax = 'quickrun'
endif
 
 
"大文字と小文字を区別する
syntax case match
 
"正規表現で一致
syntax match phpUnitOk /OK.*/
syntax match phpUnitFailures /FAILURES.*/
 
"group-nameをハイライトの指定と関連付け
highlight phpUnitOk term=reverse ctermbg=Green guibg=White
highlight phpUnitFailures term=reverse ctermbg=Red guibg=White
 
"unlet b:current_syntax
let b:current_syntax = 'quickrun'
 
if main_syntax == 'quickrun'
  unlet main_syntax
endif

augroup QuickRunPHPUnit
  autocmd!
  autocmd BufWinEnter,BufNewFile *_test.v set filetype=vlang.unit
augroup END

let g:quickrun_config['vlang'] = {}
let g:quickrun_config['vlang']['command'] = 'v'
let g:quickrun_config['vlang']['cmdopt'] = 'run'
let g:quickrun_config['vlang']['exec'] = '%c %o %s'

let g:quickrun_config['vlang.unit'] = {}
let g:quickrun_config['vlang.unit']['command'] = 'v'
let g:quickrun_config['vlang.unit']['cmdopt'] = 'test'
let g:quickrun_config['vlang.unit']['exec'] = '%c %o %s'


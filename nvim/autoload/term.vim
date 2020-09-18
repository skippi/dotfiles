func! term#keepwin() abort
  let buf = expand('#')
  if !empty(buf) && buflisted(buf) && bufnr(buf) != bufnr('%') && winnr('$') > 1
    execute 'autocmd BufWinLeave <buffer> split' buf
  endif
endfunc

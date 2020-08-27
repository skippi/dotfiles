nnoremap <buffer> <Space>d :Mkdir %
nnoremap <buffer> <Space>e :e %

augroup Dirvish
  autocmd!
  autocmd BufEnter,FocusGained <buffer> edit
augroup END

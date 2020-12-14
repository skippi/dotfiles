set textwidth=78

augroup text
  au! 
  au BufWritePre <buffer> :%s/\s\+$//e
augroup END

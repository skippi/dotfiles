set expandtab shiftwidth=2 tabstop=2
set textwidth=78

augroup text
  au! <buffer>
  au BufWritePre <buffer> :%s/\s\+$//e
augroup END

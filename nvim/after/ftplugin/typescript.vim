set expandtab shiftwidth=2 tabstop=2

nmap <silent> gd <Plug>(coc-definition)*``
nmap <silent> gD <Plug>(coc-definition)*``

aug typescript
  au!
  au BufLeave <buffer> norm! mT
aug END

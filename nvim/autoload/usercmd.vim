func! usercmd#map() abort
  if !get(g:, 'usercmd', 0) | return | endif
  for i in range(97, 122)
    exe "cnoremap <buffer>" nr2char(i) nr2char(i - 32)
  endfor
endfunc

func! usercmd#unmap() abort
  if !get(g:, 'usercmd', 0) | return | endif
  for i in range(97, 122)
    exe "sil! cunmap <buffer>" nr2char(i)
  endfor
  let g:usercmd = 0
endfunc

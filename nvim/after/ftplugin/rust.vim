compiler cargo
set formatexpr=rust#formatexpr()
setlocal path=,,src/**,test/**

func! rust#formatexpr() abort
  let b:winview = winsaveview()
  let buffer = join(getline(1, '$'), "\n")
  let lines = systemlist("rustfmt", buffer)
  if v:shell_error
    echohl WarningMsg | echo "rustfmt: invalid file syntax" | echohl None
    return
  endif
  :%d_
  call setline(1, lines)
  call winrestview(b:winview)
endfunc

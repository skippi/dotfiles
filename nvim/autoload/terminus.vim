function! terminus#ToggleTerm()
  let l:termname = "term://" . &shell
  let exists = bufexists(l:termname)
  if exists > 0
    execute "buffer " . l:termname
  else
    terminal
    execute "keepalt file " . l:termname
  endif
endfunction

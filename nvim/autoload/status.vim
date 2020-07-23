function! status#filepath()
  return expand('%:~:.')
endfunction

function! status#gitbranch()
  if exists('*FugitiveHead') && winwidth('.') > 75
    let bmark = '┣ '
    let branch = FugitiveHead()
    return strlen(branch) ? bmark . branch : ''
  endif
  return ''
endfunction

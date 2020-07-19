function! list#DeleteEntry() abort
  let l:view = winsaveview()
  let l:entry_idx = get(getqflist({'idx': 0}), 'idx')
  mark `
  call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}), 'r')
  execute "cc" max([1, l:entry_idx - 1])
  wincmd p
  normal! ``
  call winrestview(l:view)
endfunction

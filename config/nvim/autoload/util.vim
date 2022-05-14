function! util#mark_file_context() abort
  let ext = expand("%:e")
  if empty(ext) | return | endif
  exe "mark" toupper(ext[0])
endfunction

function! proc#pskill_sink(str) abort
  sil exe "!taskkill /f /pid" matchstr(a:str, '\<\d\+\>')
endfunction

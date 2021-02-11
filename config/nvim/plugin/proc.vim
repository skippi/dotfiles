command! PsKill call fzf#run({
      \ 'source': 'tasklist /fo table /nh',
      \ 'sink': funcref('proc#pskill_sink'),
      \ 'window': g:fzf_layout.window})

function! proc#pskill_sink(str) abort
  sil exe "!taskkill /f /pid" matchstr(a:str, '\<\d\+\>')
endfunction

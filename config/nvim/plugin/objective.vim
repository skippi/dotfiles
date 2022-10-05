onoremap <silent> ao :<C-u>call chunk#visual_a()<CR>
onoremap <silent> io :<C-u>call chunk#visual_i()<CR>
vnoremap <silent> ao <ESC>:call chunk#visual_a()<CR><ESC>gv
vnoremap <silent> io <ESC>:call chunk#visual_i()<CR><ESC>gv

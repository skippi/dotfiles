onoremap <silent> ao :<C-u>call chunk#visual_a()<CR>
onoremap <silent> io :<C-u>call chunk#visual_i()<CR>
vnoremap <silent> ao <ESC>:call chunk#visual_a()<CR><ESC>gv
vnoremap <silent> io <ESC>:call chunk#visual_i()<CR><ESC>gv

onoremap <silent> ae :<C-u>normal vae<CR>
onoremap <silent> ie :<C-u>normal vie<CR>
vnoremap <silent> ae <ESC>m':<C-u>keepjumps normal! vGoggV<CR>
vnoremap <silent> ie <ESC>m':<C-u>keepjumps normal! vGoggV<CR>

onoremap <silent> aj :<c-u>normal v$o0<CR>
onoremap <silent> ij :<c-u>normal vg_o^<CR>
vnoremap <silent> aj $o0
vnoremap <silent> ij g_o^

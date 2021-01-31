resize 5

nnoremap <buffer><expr> <Left> '<Cmd>sil! ' . v:count1 . 'colder<CR>'
nnoremap <buffer><expr> <Right> '<Cmd>sil! ' . v:count1 . 'cnewer<CR>'

if getwininfo(win_getid())[0].quickfix
  wincmd J
endif

nmap <buffer> <M-h> <Plug>(dirvish_up)
nmap <buffer> <M-j> j
nmap <buffer> <M-k> k
nmap <buffer> <M-l> <CR>
nnoremap <buffer> d! <Cmd>call <SID>rmshdo(1)<CR>
nnoremap <buffer> dd <Cmd>call <SID>rmshdo(0)<CR>
nnoremap <buffer> gd :call mkdir(expand("%") . "", "p")<bar>Dirvish %<C-Left><C-Left><C-Left><Right>
nnoremap <buffer> gn :sil !type NUL > %
vnoremap <buffer> d :call <SID>rmshdo(0, "v")<CR>

func! s:rmshdo(bang, ...) abort
  let mode = get(a:, 1, "n")
  let prefix = (mode == "v") ? "'<,'>" : ""
  let prefix = prefix . (a:bang ? "MShdo!" : "MShdo")
  if has("win32")
    exe prefix "rd /s/q {} & del /f/s/q {}"
  else
    exe prefix "rm -rf {}"
  endif
endfunc

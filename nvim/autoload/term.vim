func! term#on_open() abort
  if (&ft !~ "nnn")
    tnoremap <buffer> <ESC> <C-\><C-n>
  endif
endfunc

func! term#on_close() abort
  if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "coc") 
    call nvim_feedkeys("\<ESC>", 'n', v:true)
  endif
endfunc

" Preserve window after term close
" The splits mess up if noequalalways
func! term#keepwin() abort
  let buf = expand('#')
  if !empty(buf) && buflisted(buf) && bufnr(buf) != bufnr('%') && winnr('$') > 1
    exe 'autocmd BufWinLeave <buffer> sp' buf
  endif
endfunc

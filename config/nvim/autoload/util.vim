function! util#mark_file_context() abort
  let ext = expand("%:e")
  if empty(ext) | return | endif
  exe "mark" toupper(ext[0])
endfunction

func! util#grepfunc(type, ...) abort
  let sel_save = &selection
  let reg_save = @@
  let &selection = "inclusive"
  if a:0
    sil exe "noa norm! gvy"
  elseif a:type == "line"
    sil exe "noa norm! '[V']y"
  else
    sil exe "noa norm! `[v`]y"
  endif
  if exists('g:vscode')
    call VSCodeCall('workbench.action.findInFiles', {"query": @/})
  else
    echom @@
    let pattern = '"' . escape(@@, '%#"') . '"'
    let command = "sil!gr! -F " . pattern
    exe command
  endif
  let &selection = sel_save
  let @@ = reg_save
endfunc

function! util#yankpastfunc(type, ...) abort
  if a:0
    silent exe "normal! gvy"
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  else
    silent exe "normal! `[v`]y"
  endif
  silent exe "normal! `]"
endfunction

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
    let pattern = '"' . escape(@@, '%#"') . '"'
    let command = "sil!gr! -F " . pattern
    exe command
  endif
  let &selection = sel_save
  let @@ = reg_save
endfunc

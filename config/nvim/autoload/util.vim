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
    let pattern = '"' . escape(@@, '%#"') . '"'
    let command = "sil!gr! -F " . pattern
    exe command
  endif
  let &selection = sel_save
  let @@ = reg_save
endfunc

function! util#ismatchtext(regex) abort
  let text = getline('.')[:col('.') - 2]
  return match(text, '\v' . a:regex) != -1
endfunction

function! util#toggleqf() abort
  let tabnr = tabpagenr()
  let windows = filter(getwininfo(), 'v:val.quickfix && v:val.tabnr == tabnr')
  if empty(windows) && !empty(getqflist())
    cwindow
    wincmd p
  else
    cclose
  endif
endfunction

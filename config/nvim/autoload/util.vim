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
    call util#grep_with_tagstack('-F "' . escape(@@, '%#"') . '"')
  endif
  let &selection = sel_save
  let @@ = reg_save
endfunc

function! util#grep_with_tagstack(query) abort
  let pos = [bufnr()] + getcurpos()[1:]
  exe 'silent grep' a:query
  call settagstack(winnr(), 
        \ {'items': [{'bufnr': pos[0], 'tagname': a:query, 'from': pos}]},
        \ 'a')
endfunction

nnoremap <Plug>(room_rename) :set opfunc=<SID>renamefunc<CR>g@
vnoremap <Plug>(room_rename) <ESC>:call <SID>renamefunc(visualmode(), 1)<CR>
func! s:renamefunc(type, ...) abort
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@
  if a:0
    silent exe "noautocmd norm! gvy"
  elseif a:type == "line"
    silent exe "noautocmd norm! '[V']y"
  else
    silent exe "noautocmd norm! `[v`]y"
  endif
  if exists('g:vscode')
    let subtext = input("symbolname")
    if !empty(subtext)
      execute ":'[,']s//" . subtext . "/g"
      set opfunc=room#dotsubfunc
    endif
  else
    call feedkeys(":'[,']s///g\|set opfunc=room#dotsubfunc\<C-Left>\<Left>\<Left>\<Left>\<Left>\<Left>\<Left>\<Left>")
  endif
  let &selection = sel_save
  let @@ = reg_save
endfunc

func! room#dotsubfunc(type, ...) abort
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@
  if a:0
    silent exe "noautocmd norm! gvy"
  elseif a:type == "line"
    silent exe "noautocmd norm! '[V']y"
  else
    silent exe "noautocmd norm! `[v`]y"
  endif
  '[,']&&
  let &selection = sel_save
  let @@ = reg_save
endfunc

nnoremap <Plug>(room_grep) :set operatorfunc=<SID>grepfunc<CR>g@
vnoremap <Plug>(room_grep) :<C-u>call <SID>grepfunc(visualmode())<CR>
func! s:grepfunc(type) abort
  if a:type ==# 'v'
    noautocmd normal! `<v`>y
  elseif a:type ==# 'char'
    noautocmd normal! `[v`]y
  else
    return
  endif
  if exists('g:vscode')
    call VSCodeCall('workbench.action.findInFiles', {"query": @@})
  else
    silent! exec "grep! " . shellescape(escape(@@, "%#"))
    cwindow
  endif
endfunc

nnoremap <silent> <Plug>(room_lift) :let room_view = winsaveview()<CR>*N:call winrestview(room_view)<CR>
vnoremap <silent> <Plug>(room_lift) y:let room_view = winsaveview()<CR>/\V<C-r>0<CR>N:call winrestview(room_view)<CR>

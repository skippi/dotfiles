nnoremap <Plug>(room_rename) <Cmd>set opfunc=<SID>renamefunc<CR>g@
vnoremap <Plug>(room_rename) <ESC><Cmd>call <SID>renamefunc(visualmode(), 1)<CR>
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

nnoremap <Plug>(room_grep) <Cmd>set opfunc=<SID>grepfunc<CR>g@
vnoremap <Plug>(room_grep) <ESC><Cmd>call <SID>grepfunc(visualmode(), 1)<CR>
func! s:grepfunc(type, ...) abort
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
  let @/ = @@
  if exists('g:vscode')
    call VSCodeCall('workbench.action.findInFiles', {"query": @/})
  else
    let pattern = '"' . escape(@/, '%#"') . '"'
    let command = "sil!gr! -F " . pattern
    exe command
  endif
  if &hls
    set hls
  endif
  redraw!
  let &selection = sel_save
  let @@ = reg_save
endfunc

nnoremap <Plug>(room_lift) <Cmd>set opfunc=<SID>liftfunc<CR>g@
vnoremap <Plug>(room_lift) <ESC><Cmd>call <SID>liftfunc(visualmode(), 1)<CR>
func! s:liftfunc(type, ...) abort
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
  let @/ = @@
  if &hls
    set hls
  endif
  redraw!
  let &selection = sel_save
  let @@ = reg_save
endfunc

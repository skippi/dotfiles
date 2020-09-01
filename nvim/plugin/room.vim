vnoremap <Plug>(room-rename-visual) ym':set operatorfunc=<SID>RenameVisualOperator<CR>g@
function! s:RenameVisualOperator(type) abort
  normal! `'
  call s:do_rename('\V' . escape(@@, '\/'))
endfunction

nnoremap <Plug>(room-rename-cword) m':set operatorfunc=<SID>RenameCWordOperator<CR>g@
function! s:RenameCWordOperator(type) abort
  normal! `'
  call s:do_rename(expand("<cword>"))
endfunction

nnoremap <Plug>(room-rename-cWORD) m':set operatorfunc=<SID>RenameCWORDOperator<CR>g@
function! s:RenameCWORDOperator(type) abort
  normal! `'
  call s:do_rename('\V' . escape(expand("<cWORD>"), '\/'))
endfunction

nnoremap <Plug>(room-rename-id) m':set operatorfunc=<SID>RenameIdentifierOperator<CR>g@
function! s:RenameIdentifierOperator(type) abort
  normal! `'
  call s:do_rename('\<' . expand("<cword>") . '\>')
endfunction

nnoremap <Plug>(room-rename-repeat) m':set operatorfunc=<SID>RenameRepeatOperator<CR>g@
function! s:RenameRepeatOperator(type) abort
  normal! `'
  execute ":'[,']&&"
endfunction

if exists('g:vscode')
  function! s:do_rename(pattern)
    execute ":'[,']s/" . a:pattern . "/" . input("Replace") . "/g"
  endfunction
else
  function! s:do_rename(pattern)
    call feedkeys(":'[,']s/" . a:pattern . "//g\<Left>\<Left>")
    " silent! call repeat#set(":'[,']&&\<CR>")
  endfunction
endif

nnoremap <Plug>(room-grep) :set operatorfunc=<SID>GrepOperator<CR>g@
vnoremap <Plug>(room-grep) :<C-u>call <SID>GrepOperator(visualmode())<CR>
function! s:GrepOperator(type) abort
  if a:type ==# 'v'
    noautocmd normal! `<v`>y
  elseif a:type ==# 'char'
    noautocmd normal! `[v`]y
  else
    return
  endif
  if exists('g:vscode')
    call VSCodeCall('workbench.action.findInFiles', {"query": @@})
    " call VSCodeNotify('workbench.action.focusPreviousGroup')
  else
    silent! exec "grep! " . shellescape(escape(@@, "%#"))
    cwindow
  endif
endfunction

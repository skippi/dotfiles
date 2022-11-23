lua require('impatient')
lua require('plugins')
lua require('init')

set statusline=
set statusline+=%(\ %{toupper(mode(0))}%)
set statusline+=%(\ @%{FugitiveHead()}%)
set statusline+=%(\ %<%f%)
set statusline+=\ %h%m%r%w
set statusline+=%=
set statusline+=%([%n]%)
set statusline+=%(%<\ [%{&ff}]\ %y\ %l:%c\ %p%%\ %)

set wildignore+=*/.elixir_ls/*
set wildignore+=*/node_modules/*
set wildignore+=Session.vim

func s:edit_file_by_offset(offset) abort
  let dir = expand("%:h")
  if !isdirectory(dir) | return | endif
  let files = readdir(dir, { f -> !isdirectory(dir . '/' . f) })
  let idx = index(files, expand("%:t")) + a:offset
  if !(0 <= idx && idx < len(files))
    echohl ErrorMsg | echo "No more items" | echohl None
    return
  endif
  exe "edit" dir . '/' . get(files, idx)
endfunc

nnoremap [<M-q> <Cmd>exe "sil!uns colder" v:count1<CR>
nnoremap ]<M-q> <Cmd>exe "sil!uns cnewer" v:count1<CR>

" search and replace
nnoremap <Space><Space> :'{,'}s\M\<<C-r><C-w>\>g<Left><Left>
xnoremap <Space><Space> "zy:'{,'}s\M<C-r>zg<Left><Left>
xnoremap & <Esc><Cmd>'<,'>&<CR>
xnoremap g& <Esc><Cmd>'<,'>&&<CR>

" operating system
nnoremap [f <Cmd>call <SID>edit_file_by_offset(-v:count1)<CR>
nnoremap ]f <Cmd>call <SID>edit_file_by_offset(v:count1)<CR>

" PSReadLine bug
tnoremap <M-c> <M-c>
tnoremap <M-h> <M-h>

nnoremap <expr> <M-[> '<Cmd>tabmove -' . v:count1 . '<CR>'
nnoremap <expr> <M-]> '<Cmd>tabmove +' . v:count1 . '<CR>'

for key in ["<Left>", "<Right>", "<C-Left>", "<C-Right>"]
  exe "inoremap" key "<C-g>U" . key
endfor

noremap <expr> <C-L>
      \ (v:count ? '<Cmd>edit<CR>' : '')
      \ . '<Cmd>noh<CR>'
      \ . (has('diff') ? '<Cmd>diffupdate<CR>' : '')
      \ . '<Cmd>redraw<CR>'

command! EditCode sil exe "!code -nwg" expand("%:p") . ":" . line('.') . ":" . col('.') "."
command! EditIdea sil exe "!idea64" expand("%:p") . ":" . line('.')
command! EditEmacs sil exe '!emacsclientw -a "" +' . line('.') . ":" . col('.') bufname("%")
command! HighlightTest sil so $VIMRUNTIME/syntax/hitest.vim | set ro
command! -bang Kwbd call kwbd#run(<bang>0)

aug terminal
  au!
  au TermOpen term://* tnoremap <buffer> <ESC> <C-\><C-n>
  au TermClose term://* exe "Kwbd"
aug END

for tabnr in range(1, 9)
  exe 'noremap <M-' . tabnr . '> <Esc>' . tabnr . 'gt'
  exe 'noremap! <M-' . tabnr . '> <Esc>' . tabnr . 'gt'
  exe 'tnoremap <M-' . tabnr . '> <C-\><C-n>' . tabnr . 'gt'
endfor

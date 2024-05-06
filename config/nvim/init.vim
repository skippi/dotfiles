lua require('plugins')
lua require('init')

set statusline=
set statusline+=%(\ %{toupper(mode(0))}%)
set statusline+=%(\ @%{FugitiveHead()}%)
set statusline+=%(\ %<%f%)
set statusline+=\ %{v:lua.require('dap').status()!=''?'[!]':''}%h%m%r%w
set statusline+=%=
set statusline+=%([%n]%)
set statusline+=%(%<\ [%{&ff}]\ %y\ %l:%c\ %p%%\ %)

set wildignore+=*/.elixir_ls/*
set wildignore+=*/node_modules/*
set wildignore+=Session.vim

" search and replace
nnoremap <Space>r :'{,'}s\M\<<C-r><C-w>\>g<Left><Left>
xnoremap <Space>r "zy:'{,'}s\M<C-r>zg<Left><Left>
xnoremap & <Esc><Cmd>'<,'>&<CR>
xnoremap g& <Esc><Cmd>'<,'>&&<CR>

" PSReadLine bug
tnoremap <M-c> <M-c>
tnoremap <M-h> <M-h>

for key in ["<Left>", "<Right>", "<C-Left>", "<C-Right>"]
  exe "inoremap" key "<C-g>U" . key
endfor

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

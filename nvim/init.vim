let $RTP = stdpath('config')
let g:sneak#label = 1
let g:sneak#label_esc = "\\"
let g:sneak#use_ic_scs = 1
let g:textobj_sandwich_no_default_key_mappings = 1
let mapleader = "\<Space>"

if has('win32')
  let g:python3_host_prog = 'python'
else
  let g:python3_host_prog = 'python3'
endif

if exists('g:vscode')
  source $RTP/vscode.vim
else
  source $RTP/neovim.vim
endif

silent! call operator#sandwich#set('all', 'all', 'highlight', 0)
runtime macros/sandwich/keymap/surround.vim

set hidden
set ignorecase smartcase
set noswapfile
set timeoutlen=500
set undofile
set updatetime=100

" noshowcmd is BUGGED, do NOT enable it. Screen tears on linux.
" set noshowcmd

" Fixes windows backspace not doing <BS> behavior Apparently on windows term, the backspace key is mapped to <C-h>
nmap <C-h> <BS>

" Disable on windows to prevent memory leak
if has('win32')
  nnoremap <C-z> <Nop>
endif

nmap <silent> <Space>r <Plug>(room_rename)
nmap <silent> <Space>rr vg_o^<Plug>(room_rename)
nmap <silent> gs <Plug>(room_grep)
nmap <silent> gw <C-w>
nmap <silent> gm <Plug>(room_lift)
nnoremap <Space><Space> :'{,'}s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <silent> ,, #``cgN
nnoremap <silent> ,; *``cgn
nnoremap <silent> <C-p> <C-i>
nnoremap <silent> <Space> <Nop>
nnoremap <silent> <Space>P "+P
nnoremap <silent> <Space>Y "+yg_
nnoremap <silent> <Space>p "+p
nnoremap <silent> <Space>y "+y
nnoremap <silent> U <C-r>
nnoremap <silent> Y y$
nnoremap <silent> gj <Cmd>noh<CR>
noremap <silent> ' `
noremap <silent> [[ ?{<CR>w99[{
noremap <silent> [] k$][%?}<CR>
noremap <silent> ][ /}<CR>b99]}
noremap <silent> ]] j0[[%/{<CR>
noremap <silent> gh ^
noremap <silent> gl g_
noremap <silent> j gj
noremap <silent> k gk
vmap <Space>r <Plug>(room_rename)
vmap gm <Plug>(room_lift)
vmap gs <Plug>(room_grep)
vnoremap <Space><Space> y:'{,'}s/\V<C-r>=escape(@",'/\')<CR>//gc<Left><Left><Left>
vnoremap <silent> ,, y?\V<C-R>=escape(@",'/\')<CR><CR>``cgN
vnoremap <silent> ,; y/\V<C-R>=escape(@",'/\')<CR><CR>``cgn
vnoremap <silent> <Space>P "+P
vnoremap <silent> <Space>p "+p
vnoremap <silent> <Space>y "+y

augroup File
  au!
  au TextYankPost * silent! lua require("vim.highlight").on_yank()
augroup END

let g:lion_create_maps = 0
let g:lion_squeeze_spaces = 1
let g:sneak#label = 1
let g:sneak#label_esc = "\\"
let g:sneak#use_ic_scs = 1
let g:textobj_sandwich_no_default_key_mappings = 1
let mapleader = "\<Space>"

if exists('g:vscode')
  execute 'source ' . stdpath('config') . '/vscode.vim'
else
  execute 'source ' . stdpath('config') . '/neovim.vim'
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

augroup File
  autocmd!
  autocmd BufWritePre * silent! lua require("buffer").trim_whitespace()
  autocmd TextYankPost * silent! lua require("vim.highlight").on_yank()
augroup END

" Fixes windows backspace not doing <BS> behavior
" Apparently on windows term, the backspace key is mapped to <C-h>
nmap <C-h> <BS>

nmap <silent> <Space><Space> <Plug>(room-rename-id)ip
nmap <silent> <Space>rW <Plug>(room-rename-cWORD)
nmap <silent> <Space>ri <Plug>(room-rename-id)
nmap <silent> <Space>rw <Plug>(room-rename-cword)
nmap <silent> gs <Plug>(room-grep)
nmap <silent> gw <C-w>
nnoremap <silent> ,, #``cgn
nnoremap <silent> ,; *``cgn
nnoremap <silent> <C-p> <C-i>
nnoremap <silent> <Space> <Nop>
nnoremap <silent> <Space>P "+P
nnoremap <silent> <Space>Y "+yg_
nnoremap <silent> <Space>h :noh<CR>
nnoremap <silent> <Space>p "+p
nnoremap <silent> <Space>y "+y
nnoremap <silent> Q <Nop>
nnoremap <silent> U <C-r>
nnoremap <silent> Y y$
nnoremap <silent> gj :<C-u>put =repeat(nr2char(10),v:count)<Bar>execute "'[-1"<CR>
nnoremap <silent> gk :<C-u>put!=repeat(nr2char(10),v:count)<Bar>execute "']+1"<CR>
noremap / ms/
noremap <silent> ' `
noremap <silent> gh ^
noremap <silent> gl g_
noremap <silent> j gj
noremap <silent> k gk
noremap ? ms?
vmap <silent> <Space>r <Plug>(room-rename-visual)
vmap <silent> gs <Plug>(room-grep)
vnoremap <silent> <Space>P "+P
vnoremap <silent> <Space>p "+p
vnoremap <silent> <space>y "+y

nmap <silent> <Space>aL <Plug>LionLeft
nmap <silent> <Space>al <Plug>LionRight
vmap <silent> <Space>aL <Plug>VLionLeft
vmap <silent> <Space>al <Plug>VLionRight

let mapleader = "\<Space>"

call plug#begin(stdpath('data') . '/plugged')
Plug 'justinmk/vim-sneak'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'
call plug#end()

filetype plugin indent on

let g:lion_squeeze_spaces = 1
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

set hidden
set ignorecase smartcase
set noruler
set noswapfile
set timeoutlen=500
set undofile
set updatetime=100
set wildmode=list:longest,full

augroup File
  autocmd!
  autocmd BufWritePre * silent! lua require("buffer").trim_whitespace()
  autocmd TextYankPost * silent! lua require("vim.highlight").on_yank()
augroup END

" Fixes windows backspace not doing <BS> behavior
" Apparently on windows term, the backspace key is mapped to <C-h>
nmap <C-h> <BS>

nmap gw <C-w>
nmap gws :Split<CR>
nmap gwv :Vsplit<CR>gwp
nnoremap <BS> :call VSCodeCall('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup') <bar> call VSCodeCall('list.select')<CR>
nnoremap <C-p> <C-i>
nnoremap <Space> <Nop>
nnoremap <Tab> :Find<CR>
nnoremap U <C-r>
nnoremap Y y$
noremap ' `
noremap / ms/
noremap 0 ^
noremap ? ms?
noremap j gj
noremap k gk

nmap <silent> <Space>rW <Plug>(room-rename-cWORD)
nmap <silent> <Space>re :call VSCodeCall('editor.action.rename')<CR>
nmap <silent> <Space>ri <Plug>(room-rename-id)
nmap <silent> <Space>rw <Plug>(room-rename-cword)
nmap <silent> dsF ds)db
nmap <silent> dsf diwds)
nmap <silent> gD :call VSCodeCall('editor.action.goToImplementation')<CR>
nmap <silent> gd :call VSCodeCall('editor.action.revealDefinition')<CR>
nmap <silent> gr :call VSCodeCall('editor.action.goToReferences')<CR>
nmap <silent> gs <Plug>(room-grep)
nnoremap <silent> ,, #``cgn
nnoremap <silent> ,; *``cgn
nnoremap <silent> ,ve :exec ":Edit! " . stdpath('config') . "/vscode.vim"<CR>
nnoremap <silent> ,vf :exec ":Edit! " . stdpath('config') . '/ftplugin/' . &filetype . '.vim'<CR>
nnoremap <silent> ,vs :exec ":source " . stdpath('config') . "/vscode.vim"<CR>:echom "init.vim reloaded"<CR>
nnoremap <silent> <Space>P "+P
nnoremap <silent> <Space>Y "+yg_
nnoremap <silent> <Space>fd :Quit<CR>
nnoremap <silent> <Space>fe :call VSCodeCall('workbench.view.explorer')<CR>
nnoremap <silent> <Space>fl :Edit %<CR>
nnoremap <silent> <Space>fo :Find<CR>
nnoremap <silent> <Space>h :noh<CR>
nnoremap <silent> <Space>p "+p
nnoremap <silent> <Space>q :Quit<CR>
nnoremap <silent> <Space>w :Write<CR>
nnoremap <silent> <Space>y "+y
nnoremap <silent> g/ :call VSCodeCall('workbench.action.findInFiles')<CR>
vmap <silent> <Space>r <Plug>(room-rename-visual)
vmap <silent> gs <Plug>(room-grep)
vnoremap <silent> <Space>P "+P
vnoremap <silent> <Space>p "+p
vnoremap <silent> <Space>y "+y

nnoremap <silent> <Space>le :call VSCodeCall('leetCodeExplorer.focus')<CR>
nnoremap <silent> <Space>lf :call VSCodeCall('leetcode.searchProblem') <bar> sleep 200m <bar> call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>ls :call VSCodeCall('leetcode.submitSolution') <bar> sleep 200m <bar> call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>lt :call VSCodeCall('leetcode.testSolution') <bar> sleep 200m <bar> call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>

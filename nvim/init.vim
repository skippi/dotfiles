let mapleader = "\<Space>"

call plug#begin(stdpath('data') . '/plugged')
" Function
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'ludovicchabant/vim-gutentags'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'puremourning/vimspector'
Plug 'romainl/vim-qf'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'
" Languages
Plug 'LnL7/vim-nix'
Plug 'axvr/org.vim'
Plug 'bfrg/vim-cpp-modern'
Plug 'derekwyatt/vim-scala'
Plug 'elixir-editors/vim-elixir'
Plug 'habamax/vim-godot'
Plug 'neovimhaskell/haskell-vim'
Plug 'rust-lang/rust.vim'
Plug 'vim-python/python-syntax'
" Visual
Plug 'itchyny/lightline.vim'
Plug 'tomasiser/vim-code-dark'
call plug#end()

syntax on
filetype plugin indent on

let $FZF_DEFAULT_COMMAND = 'rg --files --follow --hidden --glob !.git'
let g:dirvish_mode = ':sort ,^.*[\/],'
let g:fzf_layout = { 'window': { 'width': 0.5461, 'height': 0.6, 'yoffset': 0.5, 'border': 'sharp' } }
let g:gutentags_cache_dir = stdpath('data') . '/tags'
let g:gutentags_ctags_extra_args = ['--tag-relative=yes', '--fields=+ailmnS']
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_write = 1
let g:lightline = {}
let g:lightline.active = {}
let g:lightline.active.left = [['mode'], ['gitbranch', 'filepath', 'modified']]
let g:lightline.colorscheme = 'codedark'
let g:lightline.component_function = { 'gitbranch': 'status#gitbranch', 'filepath': 'status#filepath' }
let g:lion_squeeze_spaces = 1
let g:prosession_dir = stdpath('data') . '/session'
let g:python_highlight_all = 1
let g:scala_use_default_keymappings = 0
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

let g:gutentags_ctags_exclude = [
      \ '*-lock.json',
      \ '*.Master',
      \ '*.bak',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.cache',
      \ '*.class',
      \ '*.csproj',
      \ '*.csproj.user',
      \ '*.css',
      \ '*.exe', '*.dll',
      \ '*.git', '*.svg', '*.hg',
      \ '*.json',
      \ '*.less',
      \ '*.lock',
      \ '*.map',
      \ '*.md',
      \ '*.min.*',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.pdb',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ '*.pyc',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.scss',
      \ '*.sln',
      \ '*.swp', '*.swo',
      \ '*.tmp',
      \ '*.zip',
      \ '*/tests/*',
      \ '*build*.js',
      \ '*bundle*.js',
      \ '*sites/*/files/*',
      \ '.*rc*',
      \ 'bin',
      \ 'bower_components',
      \ 'build',
      \ 'bundle',
      \ 'cache',
      \ 'compiled',
      \ 'cscope.*',
      \ 'dist',
      \ 'docs',
      \ 'example',
      \ 'node_modules',
      \ 'tags*',
      \ 'vendor',
      \ ]

silent! colorscheme codedark

set fileformat=unix
set fileformats=unix,dos
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set hidden
set ignorecase smartcase
set inccommand=nosplit
set lazyredraw
set mouse=
set noequalalways
set noruler
set nosplitright
set noswapfile
set path+=src/**,test/**
set splitbelow
set termguicolors
set timeoutlen=500
set undofile
set updatetime=100
set wildmode=list:longest,full

" noshowcmd is BUGGED, do NOT enable it. Screen tears on linux.
" set noshowcmd

" Fixes windows backspace not doing <BS> behavior
" Apparently on windows term, the backspace key is mapped to <C-h>
nmap <C-h> <BS>

nnoremap <BS> <C-^>
nnoremap <C-p> <C-i>
nnoremap <Space> <Nop>
nnoremap <Tab> :ls<CR>:b<Space>
nnoremap U <C-r>
nnoremap Y y$
nnoremap gw <C-w>
noremap ' `
noremap / ms/
noremap 0 ^
noremap ? ms?
noremap j gj
noremap k gk

nmap <silent> ,q <Plug>(qf_qf_toggle)
nmap <silent> <Space>rW <Plug>(room-rename-cWORD)
nmap <silent> <Space>re <Plug>(coc-rename)
nmap <silent> <Space>ri <Plug>(room-rename-id)
nmap <silent> <Space>rw <Plug>(room-rename-cword)
nmap <silent> dsF ds)db
nmap <silent> dsf diwds)
nmap <silent> gD <Plug>(coc-implementation)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gs <Plug>(room-grep)
nnoremap <expr> <A-CR> GuiWindowFullScreen(!g:GuiWindowFullScreen)
nnoremap <silent> ,, #``cgn
nnoremap <silent> ,; *``cgn
nnoremap <silent> ,cd :cd %:p:h<CR>:echom ":cd " . expand("%:p:h")<CR>
nnoremap <silent> ,ve :edit $MYVIMRC<CR>
nnoremap <silent> ,vf :exec ":e " . stdpath('config') . '/ftplugin/' . &filetype . '.vim'<CR>
nnoremap <silent> ,vs :source $MYVIMRC<CR>:echom "init.vim reloaded"<CR>
nnoremap <silent> <Space>P "+P
nnoremap <silent> <Space>Y "+yg_
nnoremap <silent> <Space>fd :<C-u>Kwbd<CR>
nnoremap <silent> <Space>fe :Dirvish<CR>
nnoremap <silent> <Space>fl :e %<CR>
nnoremap <silent> <Space>fo :Files<CR>
nnoremap <silent> <Space>gb :GBlame<cr>
nnoremap <silent> <Space>gd :Gdiff<CR>
nnoremap <silent> <Space>gl :Glog<CR>
nnoremap <silent> <Space>gs :Gedit :<CR>
nnoremap <silent> <Space>h :noh<CR>
nnoremap <silent> <Space>ld :CocList diagnostics<CR>
nnoremap <silent> <Space>ls :CocList symbols<CR>
nnoremap <silent> <Space>oc :Code<CR>
nnoremap <silent> <Space>oe :Emacs<CR>
nnoremap <silent> <Space>og :Chrome<CR>
nnoremap <silent> <Space>p "+p
nnoremap <silent> <Space>q :q<CR>
nnoremap <silent> <Space>to :call terminus#ToggleTerm()<CR>
nnoremap <silent> <Space>w :w<CR>
nnoremap <silent> <Space>y "+y
nnoremap g/ :silent!<Space>grep!<Space>""<Left>
nnoremap z/ :g//#<Left><Left>
vmap <silent> <Space>r <Plug>(room-rename-visual)
vmap <silent> gs <Plug>(room-grep)
vnoremap <silent> <Space>P "+P
vnoremap <silent> <Space>p "+p
vnoremap <silent> <Space>y "+y

cnoremap <expr> <CR> ccr#run()

" Abbreviation
cnoreabbrev <expr> make (getcmdtype() ==# ':' && getcmdline() ==# 'make') ? 'Make' : 'make'
cnoreabbrev <expr> git (getcmdtype() ==# ':' && getcmdline() ==# 'git') ? 'Git' : 'git'

command! -nargs=* Make silent make <args> | cwindow 3
command! Chrome silent !chrome "file://%:p"
command! Emacs silent exec "!start /B emacsclientw +" . line('.') . ":" . col('.') . " " . bufname("%")
command! Idea silent exec "!start /B idea64 " . bufname("%") . ":" . line('.')
command! Code silent exec "!start /B code --goto " . bufname("%") . ":" . line('.') . ":" . col('.')
command! Kwbd call kwbd#run(1)

augroup File
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
  autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
  autocmd BufWritePre * silent! lua require("buffer").trim_whitespace()
  autocmd TextYankPost * silent! lua require("vim.highlight").on_yank()
augroup END

augroup Terminal
  autocmd!
  " Automatically quit terminal after exit
  autocmd TermClose term://*
        \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "coc") |
        \   call nvim_input('<CR>')  |
        \ endif
  " Remap <ESC> to allow terminal escaping
  autocmd TermOpen * tnoremap <buffer> <ESC> <C-\><C-n>
  autocmd FileType fzf tunmap <buffer> <ESC>
augroup END

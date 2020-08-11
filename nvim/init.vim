let mapleader = "\<Space>"

call plug#begin(stdpath('data') . '/plugged')
Plug 'LnL7/vim-nix'
Plug 'bfrg/vim-cpp-modern'
Plug 'derekwyatt/vim-scala'
Plug 'elixir-editors/vim-elixir'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'ludovicchabant/vim-gutentags'
Plug 'machakann/vim-sandwich'
Plug 'michaeljsmith/vim-indent-object'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'neovimhaskell/haskell-vim'
Plug 'puremourning/vimspector'
Plug 'romainl/vim-qf'
Plug 'rust-lang/rust.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'vim-python/python-syntax'
Plug 'wellle/targets.vim'
Plug 'habamax/vim-godot'
if has('win32')
  Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install'}
endif
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif
call plug#end()

runtime macros/sandwich/keymap/surround.vim

syntax on
filetype plugin indent on

let $FZF_DEFAULT_COMMAND = 'rg --files --follow --hidden --glob !.git'
let g:dirvish_mode = ':sort ,^.*[\/],'
let g:fzf_layout = { 'window': { 'width': 0.5461, 'height': 0.6, 'yoffset': 0.5, 'border': 'sharp' } }
let g:lightline = {}
let g:lightline.active = {}
let g:lightline.active.left = [['mode'], ['gitbranch', 'filepath', 'modified']]
let g:lightline.colorscheme = 'codedark'
let g:lightline.component_function = { 'gitbranch': 'status#gitbranch', 'filepath': 'status#filepath' }
let g:gutentags_cache_dir = stdpath('data') . '/tags'
let g:gutentags_ctags_extra_args = ['--tag-relative=yes', '--fields=+ailmnS']
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_write = 1
let g:prosession_dir = stdpath('data') . '/session'
let g:python_highlight_all = 1
let g:scala_use_default_keymappings = 0
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]

silent! colorscheme codedark

augroup File
  autocmd!
  autocmd BufEnter,FocusGained * :checktime
  autocmd BufReadPost * :call <SID>RestoreLastCursorPosition()
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

set autoread
set background=dark
set backspace=indent,eol,start
set expandtab tabstop=2 shiftwidth=2
set fileformat=unix
set fileformats=unix,dos
set foldlevelstart=99
set foldmethod=indent
set foldnestmax=20
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set hidden
set ignorecase smartcase
set inccommand=split
set incsearch
set lazyredraw
set mouse=
set nobackup
set noequalalways
set noruler
set noswapfile
set path+=src/**,test/**
set scrolloff=0
set smarttab
set splitbelow
set splitright
set termguicolors
set undofile
set updatetime=100
set wildmenu
set wildmode=list:longest,full

" noshowcmd is BUGGED, do NOT enable it. Screen tears on linux.
" set noshowcmd

" Fixes windows backspace not doing <BS> behavior
" Apparently on windows term, the backspace key is mapped to <C-h>
nmap <C-h> <BS>

nnoremap <BS> <C-^>
nnoremap <C-p> <C-i>
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
nmap <silent> con <Plug>(coc-rename)
nmap <silent> gD <Plug>(coc-implementation)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nnoremap <expr> <A-CR> GuiWindowFullScreen(!g:GuiWindowFullScreen)
nnoremap <silent> ,, #``cgn
nnoremap <silent> ,; *``cgn
nnoremap <silent> ,bd :<C-u>Kwbd<CR>
nnoremap <silent> ,cd :cd %:p:h<CR>:echom ":cd " . expand("%:p:h")<CR>
nnoremap <silent> ,f :Files<CR>
nnoremap <silent> ,ga :Gcommit --amend -v -q<CR>
nnoremap <silent> ,gb :Gblame<CR>
nnoremap <silent> ,gc :Gcommit -v -q<CR>
nnoremap <silent> ,gd :Gdiff<CR>
nnoremap <silent> ,gl :Glog<CR>
nnoremap <silent> ,gs :Gedit<Space>:<CR>
nnoremap <silent> ,gw :Gwrite<CR><CR>
nnoremap <silent> ,ve :edit $MYVIMRC<CR>
nnoremap <silent> ,vs :source $MYVIMRC<CR>:echom "init.vim reloaded"<CR>
nnoremap <silent> <F5> :e %<CR>
nnoremap <silent> <Space>P "+P
nnoremap <silent> <Space>Y "+yg_
nnoremap <silent> <Space>h :noh<CR>
nnoremap <silent> <Space>ld :CocList diagnostics<CR>
nnoremap <silent> <Space>ls :CocList symbols<CR>
nnoremap <silent> <Space>p "+p
nnoremap <silent> <Space>q :q<CR>
nnoremap <silent> <Space>w :w<CR>
nnoremap <silent> <Space>y "+y
nnoremap <silent> gV `[v`]
nnoremap <silent> goe :Dirvish<CR>
nnoremap <silent> got :call terminus#ToggleTerm()<CR>
nnoremap coe :%s/\<<C-r>=expand('<cword>')<CR>\>//g<Left><Left>
nnoremap cop :'{,'}s/\<<C-r>=expand('<cword>')<CR>\>//g<Left><Left>
nnoremap g/ :silent!<Space>grep!<Space>""<Left>
nnoremap gy :g//#<Left><Left>
vnoremap <silent> <Space>P "+P
vnoremap <silent> <Space>p "+p
vnoremap <silent> <Space>y "+y

" Habit Breaks
noremap <C-r> <Nop>
noremap <C-w> <Nop>
noremap <Space>bd <Nop>
noremap <Space>t <Nop>
noremap <Space>ve <Nop>
noremap <Space>vs <Nop>
noremap ` <Nop>

" Text Object
onoremap <silent> ae :<C-u>normal vae<CR>
onoremap <silent> ie :<C-u>normal vie<CR>
xnoremap <silent> ae GoggV
xnoremap <silent> ie :<C-u>let z = @/\|1;/^./kz<CR>G??<CR>:let @/ = z<CR>V'z

onoremap <silent> a_ :<C-u>normal va_<CR>
onoremap <silent> i_ :<C-u>normal vi_<CR>
xnoremap <silent> a_ $o0
xnoremap <silent> i_ g_o^

" Abbreviation
cnoreabbrev <expr> make (getcmdtype() ==# ':' && getcmdline() ==# 'make') ? 'Make' : 'make'
cnoreabbrev <expr> git (getcmdtype() ==# ':' && getcmdline() ==# 'git') ? 'Git' : 'git'

command! -nargs=* Make silent make <args> | cwindow 3
command! Kwbd call kwbd#run(1)

cnoremap <expr> <CR> ccr#run()

function! GrepOperator(type) abort
  if a:type ==# 'v'
    noautocmd normal! `<v`>y
  elseif a:type ==# 'char'
    noautocmd normal! `[v`]y
  else
    return
  endif
  silent! execute "grep! " . shellescape(@@) " ."
  cwindow
endfunction
nnoremap <silent> gs :set operatorfunc=GrepOperator<CR>g@
vnoremap <silent> gs :<C-u>call GrepOperator(visualmode())<CR>

function! s:RestoreLastCursorPosition() abort
  if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    normal! `"
  endif
endfunction

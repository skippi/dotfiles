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
set fileformat=unix
set fileformats=unix,dos
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
set timeoutlen=500
set undofile
set updatetime=100
set wildmenu
set wildmode=list:longest,full

" noshowcmd is BUGGED, do NOT enable it. Screen tears on linux.
" set noshowcmd

" vim.unimpaired maps cop unless this is specified for god knows what reason
nnoremap co <Nop>

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
nnoremap <silent> ,vf :exec ":e " . stdpath('config') . '/ftplugin/' . &filetype . '.vim'<CR>
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
nnoremap <silent> goc :GC<CR>
nnoremap <silent> goe :Dirvish<CR>
nnoremap <silent> got :call terminus#ToggleTerm()<CR>
nnoremap coe :%s/\<<C-r>=expand('<cword>')<CR>\>//g<Left><Left>
nnoremap cop :'{,'}s/\<<C-r>=expand('<cword>')<CR>\>//g<Left><Left>
nnoremap g/ :silent!<Space>grep!<Space>""<Left>
nnoremap z/ :g//#<Left><Left>
vnoremap <silent> <Space>P "+P
vnoremap <silent> <Space>p "+p
vnoremap <silent> <Space>y "+y

nnoremap <silent> gs :set operatorfunc=GrepOperator<CR>g@
vnoremap <silent> gs :<C-u>call GrepOperator(visualmode())<CR>

cnoremap <expr> <CR> ccr#run()

" Text Object
onoremap <silent> ao :<C-u>call chunk#visual_a()<CR>
onoremap <silent> io :<C-u>call chunk#visual_i()<CR>
vnoremap <silent> ao <ESC>:call chunk#visual_a()<CR><ESC>gv
vnoremap <silent> io <ESC>:call chunk#visual_i()<CR><ESC>gv

onoremap <silent> ae :<C-u>normal vae<CR>
onoremap <silent> ie :<C-u>normal vie<CR>
xnoremap <silent> ae GoggV
xnoremap <silent> ie :<C-u>let z = @/\|1;/^./kz<CR>G??<CR>:let @/ = z<CR>V'z

onoremap <silent> aj :<c-u>normal vai<cr>
onoremap <silent> ij :<c-u>normal vii<cr>
xnoremap <silent> aj $o0
xnoremap <silent> ij g_o^

" Abbreviation
cnoreabbrev <expr> make (getcmdtype() ==# ':' && getcmdline() ==# 'make') ? 'Make' : 'make'
cnoreabbrev <expr> git (getcmdtype() ==# ':' && getcmdline() ==# 'git') ? 'Git' : 'git'

command! -nargs=* Make silent make <args> | cwindow 3
command! GC silent !chrome "file://%:p"
command! Kwbd call kwbd#run(1)

function! GrepOperator(type) abort
  if a:type ==# 'v'
    noautocmd normal! `<v`>y
  elseif a:type ==# 'char'
    noautocmd normal! `[v`]y
  else
    return
  endif
  silent! exec "grep! " . shellescape(escape(@@, "%#"))
  cwindow
endfunction

function! s:RestoreLastCursorPosition() abort
  if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    normal! `"
  endif
endfunction

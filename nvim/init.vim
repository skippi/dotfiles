let mapleader = "\<Space>"

call plug#begin(stdpath('data') . '/plugged')
Plug 'LnL7/vim-nix'
Plug 'derekwyatt/vim-scala'
Plug 'elixir-editors/vim-elixir'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
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
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
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
  autocmd BufRead,BufNewFile *.sbt set filetype=scala
  autocmd BufReadPost * :call RestoreLastCursorPosition()
  autocmd BufWritePre * silent! lua require("buffer").trim_whitespace()
  autocmd FileType netrw setl bufhidden=wipe
  autocmd FileType text setlocal textwidth=78
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

augroup Dirvish
  autocmd!
  autocmd BufEnter dirvish :edit<CR>
  autocmd FileType dirvish nnoremap <buffer> <Space>e :e %
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

nmap <BS> <C-^>
nmap <silent> ,q <Plug>(qf_qf_toggle)
nmap <silent> con <Plug>(coc-rename)
nmap <silent> gD <Plug>(coc-implementation)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> goe :Dirvish<CR>
nmap <silent> gr <Plug>(coc-references)
nnoremap ' `
nnoremap / ms/
nnoremap 0 ^
nnoremap <C-p> <C-i>
nnoremap <Tab> :ls<CR>:b<Space>
nnoremap <expr> <A-CR> GuiWindowFullScreen(!g:GuiWindowFullScreen)
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
nnoremap <silent> <Space>p "+p
nnoremap <silent> <Space>q :q<CR>
nnoremap <silent> <Space>w :w<CR>
nnoremap <silent> <Space>y "+y
nnoremap <silent> gV `[v`]
nnoremap <silent> got :call terminus#ToggleTerm()<CR>
nnoremap ? ms?
nnoremap U <C-r>
nnoremap Y y$
nnoremap coh :%s///g<Left><Left>
nnoremap g/ :g//#<Left><Left>
nnoremap gs :Grep<Space>
nnoremap gw <C-w>
nnoremap j gj
nnoremap k gk
vnoremap <silent> <Space>P "+P
vnoremap <silent> <Space>p "+p
vnoremap <silent> <Space>y "+y
xnoremap coh :s///g<Left><Left>

" Habit Breaks
nnoremap <C-r> <Nop>
nnoremap <C-w> <Nop>
nnoremap <Space>bd <Nop>
nnoremap <Space>t <Nop>
nnoremap <Space>ve <Nop>
nnoremap <Space>vs <Nop>
nnoremap ` <Nop>

" Auto Expansion
imap (<S-CR> (<CR>
imap [<S-CR> [<CR>
imap {<S-CR> {<CR>
inoremap (<CR> (<CR>)<C-o>O
inoremap [<CR> [<CR>]<C-o>O
inoremap {<CR> {<CR>}<C-o>O

" Text Object
onoremap <silent> ao :<C-u>call AChunkTextObject()<CR>
onoremap <silent> io :<C-u>call InnerChunkTextObject()<CR>
vnoremap <silent> ao <ESC>:call AChunkTextObject()<CR><ESC>gv
vnoremap <silent> io <ESC>:call InnerChunkTextObject()<CR><ESC>gv

xnoremap ie :<C-u>let z = @/\|1;/^./kz<CR>G??<CR>:let @/ = z<CR>V'z
onoremap ie :<C-u>normal vie<CR>
xnoremap ae GoggV
onoremap ae :<C-u>normal vae<CR>

xnoremap il g_o^
onoremap il :<C-u>normal vil<CR>
xnoremap al $o0
onoremap al :<C-u>normal val<CR>

" Abbreviation
cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'
cnoreabbrev <expr> make (getcmdtype() ==# ':' && getcmdline() ==# 'make') ? 'Make' : 'make'
cnoreabbrev <expr> git (getcmdtype() ==# ':' && getcmdline() ==# 'git') ? 'Git' : 'git'

command! -nargs=+ -complete=file_in_path -bar Grep silent! grep! <args> | redraw! | cwindow 3
command! -nargs=+ -complete=file_in_path -bar LGrep silent! lgrep! <args> | redraw! | lwindow 3
command! -nargs=* Make silent make <args> | cwindow 3
command! Kwbd call kwbd#run(1)

cnoremap <expr> <CR> ccr#run()

augroup MakeExtensions
  autocmd!
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost l* nested lwindow
augroup END

function! AChunkTextObject() abort
  let [minline, maxline] = s:OutlineAChunk(line("."), indent("."))
  call setpos(".", [0, minline, 0, 0])
  normal! V
  call setpos(".", [0, maxline, 0, 0])
  normal! $
endfunction

function! InnerChunkTextObject() abort
  let [minline, maxline] = s:OutlineInnerChunk(line("."), indent("."))
  call setpos(".", [0, minline, 0, 0])
  normal! V
  call setpos(".", [0, maxline, 0, 0])
  normal! $
endfunction

function! s:OutlineAChunk(lineno, indent) abort
  if IsLineEmpty(a:lineno)
    let [minline, maxline] = s:OutlineInnerChunk(a:lineno, a:indent)
    let [_, maxline] = s:OutlineInnerChunk(maxline + 1, indent(maxline + 1))
  else
    let [minline, maxline] = s:OutlineInnerChunk(a:lineno, a:indent)
    if IsLineEmpty(maxline + 1) && maxline + 1 <= line("$")
      let [_, maxline] = s:OutlineInnerChunk(maxline + 1, indent(maxline + 1))
    elseif IsLineEmpty(minline + 1) && minline - 1 >= 1
      let [minline, _] = s:OutlineInnerChunk(minline - 1, indent(minline - 1))
    endif
  endif
  return [minline, maxline]
endfunction

function! s:OutlineInnerChunk(lineno, indent) abort
  if IsLineEmpty(a:lineno)
    return s:OutlineIf(function("IsLineEmpty"), a:lineno)
  else
    return s:OutlineIf({ lineno -> indent(lineno) >= a:indent && !IsLineEmpty(lineno) },
          \ a:lineno)
  endif
endfunction

function! s:OutlineIf(condition, lineno) abort
  let minline = AdvanceLineWhile(a:condition, a:lineno, -1)
  let maxline = AdvanceLineWhile(a:condition, a:lineno, +1)
  return [minline, maxline]
endfunction

function! AdvanceLineWhile(condition, initial, step)
  let result = a:initial
  let lastline = line("$")
  while result > 1 && result < lastline && a:condition(result + a:step)
    let result = result + a:step
  endwhile
  return result
endfunction

function! RestoreLastCursorPosition() abort
  if 1 <= line("'\"") && line("'\"") <= line("$") && &filetype != "gitcommit"
    normal! `"
  endif
endfunction

function! IsLineEmpty(lineno) abort
  return getline(a:lineno) !~ '[^\s]'
endfunction

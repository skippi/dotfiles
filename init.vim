function! AutoInstallVimPlug()
  let l:plug_path = stdpath('data') . '/site/autoload/plug.vim'
  if !filereadable(l:plug_path)
    silent execute '!curl -fLo ' . l:plug_path . ' --create-dirs
      \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfunction

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

set expandtab
set guifont=Consolas:h11
set hidden
set mouse=
set shiftwidth=2
set t_Co=256
set t_ut=
set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab

call AutoInstallVimPlug()

call plug#begin(stdpath('data') . '/plugged')
  " Language
  Plug 'dunstontc/vim-vscode-theme'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neovimhaskell/haskell-vim'
  Plug 'rust-lang/rust.vim'

  " Util
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'LnL7/vim-nix'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'

  " UI
  Plug 'tomasiser/vim-code-dark'
  Plug 'vim-airline/vim-airline'
call plug#end()

syntax on
filetype plugin indent on

colorscheme codedark

let mapleader = "\<Space>"
let g:airline_theme = 'codedark'
let g:netrw_winsize=25

augroup auto_file
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
  autocmd FileType text setlocal textwidth=78
augroup END

augroup auto_term
  autocmd!
  autocmd TermClose term://*
            \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
            \   call nvim_input('<CR>')  |
            \ endif
augroup END

nmap <silent> <leader>lr <Plug>(coc-rename)
nnoremap <silent> <leader>ga :Gcommit --amend -v -q<CR>
nnoremap <silent> <leader>gc :Gcommit -v -q<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gt :Gcommit -v -q %<CR>
nnoremap <silent> <leader>gw :Gwrite<CR><CR>
nnoremap <silent> <leader>r :Rg! <C-R><C-W><CR>
nnoremap <silent> <leader>t :split<bar>term<CR>i
nnoremap <leader>ve :exe 'e! $MYVIMRC'<CR>
nnoremap <leader>vs :source $MYVIMRC<CR>
tnoremap <Esc> <C-\><C-n>

" Fzf
nnoremap <silent> <leader><leader> :GFiles<CR>
nnoremap <silent> <leader>fi       :Files<CR>
nnoremap <silent> <leader>C        :Colors<CR>
nnoremap <silent> <leader><CR>     :Buffers<CR>
nnoremap <silent> <leader>fl       :Lines<CR>
nnoremap <silent> <leader>ag       :Ag! <C-R><C-W><CR>
nnoremap <silent> <leader>m        :History<CR>


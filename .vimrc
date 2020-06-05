" An example for a vimrc file.

" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2017 Sep 20
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

function! AutoInstallVimPlug()
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfunction

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

if has('syntax') && has('eval')
  packadd! matchit
endif

call AutoInstallVimPlug()

call plug#begin('$HOME/vimfiles/plugged')
  " Language
  Plug 'dunstontc/vim-vscode-theme'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neovimhaskell/haskell-vim'

  " Util
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'LnL7/vim-nix'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'

  " UI
  Plug 'tomasiser/vim-code-dark'
  Plug 'vim-airline/vim-airline'
call plug#end()

syntax on
filetype plugin indent on

set expandtab
set guifont=Consolas:h11
set mouse=
set renderoptions=type:directx,gamma:1.5,contrast:0.5,geom:1,renmode:5,taamode:1,level:0.5
set shiftwidth=2
set t_Co=256
set t_ut=
set tabstop=2

colorscheme codedark

let mapleader = "\<Space>"
let g:airline_theme = 'codedark'
let g:netrw_winsize=25

autocmd BufWritePre * %s/\s\+$//e

nnoremap <silent> <leader>ga :Gcommit --amend -v -q<CR>
nnoremap <silent> <leader>gc :Gcommit -v -q<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gs :Git status<CR>
nnoremap <silent> <leader>gt :Gcommit -v -q %<CR>
nnoremap <silent> <leader>gw :Gwrite<CR><CR>
nnoremap <silent> <leader>t :term<CR>
nnoremap <leader>ve :e! ~/.vimrc<CR>
nnoremap <leader>vr :source ~/.vimrc<CR>

" Fzf
nnoremap <silent> <leader><leader> :GFiles<CR>
nnoremap <silent> <leader>fi       :Files<CR>
nnoremap <silent> <leader>C        :Colors<CR>
nnoremap <silent> <leader><CR>     :Buffers<CR>
nnoremap <silent> <leader>fl       :Lines<CR>
nnoremap <silent> <leader>ag       :Ag! <C-R><C-W><CR>
nnoremap <silent> <leader>m        :History<CR>


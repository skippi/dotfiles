" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2017 Sep 20
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

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

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif
set shell=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe\ -executionpolicy\ bypass

call plug#begin('$HOME/vimfiles/plugged')
  " Color Schemes
  Plug 'tomasiser/vim-code-dark'
  Plug 'dunstontc/vim-vscode-theme'

  " Languages
  Plug 'elixir-editors/vim-elixir'
  Plug 'slashmill/alchemist.vim'

  " UI
  Plug 'vim-airline/vim-airline'
call plug#end()

set enc=utf-8
set expandtab
set guifont=Consolas:h11
set renderoptions=type:directx,gamma:1.5,contrast:0.5,geom:1,renmode:5,taamode:1,level:0.5
set shiftwidth=2
set t_Co=256
set t_ut=
set tabstop=2

let g:netrw_winsize=25

colorscheme codedark

let g:airline_theme = 'codedark'

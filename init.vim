function! AutoInstallVimPlug()
  let l:plug_path = stdpath('data') . '/site/autoload/plug.vim'
  if !filereadable(l:plug_path)
    silent execute '!curl -fLo ' . l:plug_path . ' --create-dirs
    \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
endfunction

" https://vim.fandom.com/wiki/Deleting_a_buffer_without_closing_the_window
function s:Kwbd(kwbdStage)
if(a:kwbdStage == 1)
  if(&modified)
    let answer = confirm("This buffer has been modified.  Are you sure you want to delete it?", "&Yes\n&No", 2)
    if(answer != 1)
      return
    endif
  endif
  if(!buflisted(winbufnr(0)))
    bd!
    return
  endif
  let s:kwbdBufNum = bufnr("%")
  let s:kwbdWinNum = winnr()
  windo call s:Kwbd(2)
  execute s:kwbdWinNum . 'wincmd w'
  let s:buflistedLeft = 0
  let s:bufFinalJump = 0
  let l:nBufs = bufnr("$")
  let l:i = 1
  while(l:i <= l:nBufs)
    if(l:i != s:kwbdBufNum)
      if(buflisted(l:i))
        let s:buflistedLeft = s:buflistedLeft + 1
      else
        if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
          let s:bufFinalJump = l:i
        endif
      endif
    endif
    let l:i = l:i + 1
  endwhile
  if(!s:buflistedLeft)
    if(s:bufFinalJump)
      windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
    else
      enew
      let l:newBuf = bufnr("%")
      windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
    endif
    execute s:kwbdWinNum . 'wincmd w'
  endif
  if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
    execute "bd! " . s:kwbdBufNum
  endif
  if(!s:buflistedLeft)
    set buflisted
    set bufhidden=delete
    set buftype=
    setlocal noswapfile
  endif
else
  if(bufnr("%") == s:kwbdBufNum)
    let prevbufvar = bufnr("#")
    if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
      b #
    else
      bn
    endif
  endif
endif
endfunction

command! Kwbd call s:Kwbd(1)

let mapleader = "\<Space>"

call AutoInstallVimPlug()

call plug#begin(stdpath('data') . '/plugged')
if has('unix')
  Plug 'antoinemadec/coc-fzf'
endif
Plug 'LnL7/vim-nix'
Plug 'dunstontc/vim-vscode-theme'
Plug 'elixir-editors/vim-elixir'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
" {{{
nnoremap <silent> <leader>md :MarkdownPreviewStop<CR>
nnoremap <silent> <leader>me :MarkdownPreview<CR>
" }}}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" {{{
let $FZF_DEFAULT_COMMAND = 'rg --files --follow'
let g:fzf_layout = { 'window': { 'width': 0.5461, 'height': 0.6, 'yoffset': 0.5, 'border': 'sharp' } }
" }}}
Plug 'junegunn/fzf.vim'
" {{{
  nnoremap <silent> <leader>/ :exec 'Rg ' . input('Rg/')<CR>
  nnoremap <silent> <leader><CR> :Buffers<CR>
  nnoremap <silent> <leader><leader> :Files<CR>
  nnoremap <silent> <leader>fh :History<CR>
  nnoremap <silent> <leader>fl :BLines<CR>
  nnoremap <silent> <leader>fs :exec 'Rg ' . expand('<cword>')<CR>
  vnoremap <silent> <leader>/ y:Rg <C-r>"<CR>
  vnoremap <silent> <leader>fl y:BLines <C-r>"<CR>
" }}}
Plug 'justinmk/vim-sneak'
" {{{
  let g:sneak#label = 1
  let g:sneak#use_ic_scs = 1
" }}}
Plug 'kassio/neoterm'
" {{{
  nnoremap <silent> <leader>t :Ttoggle<CR>
" }}}
Plug 'machakann/vim-sandwich'
Plug 'michaeljsmith/vim-indent-object'
Plug 'morhetz/gruvbox'
" {{{
  let g:gruvbox_contrast_dark = 'soft'
  let g:gruvbox_contrast_light = 'soft'
" }}}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" {{{
  nmap <silent> <leader>ld :CocDiagnostics<CR>
  nmap <silent> <leader>lg <Plug>(coc-definition)
  nmap <silent> <leader>li <Plug>(coc-implementation)
  nmap <silent> <leader>lr <Plug>(coc-rename)
  nmap <silent> <leader>lu <Plug>(coc-references)
  nmap <silent> <leader>le <Plug>(coc-declaration)
" }}}
Plug 'neovimhaskell/haskell-vim'
Plug 'puremourning/vimspector'
Plug 'rust-lang/rust.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
" {{{
  nnoremap <silent> <leader>ga :Gcommit --amend -v -q<CR>
  nnoremap <silent> <leader>gb :Gblame<CR>
  nnoremap <silent> <leader>gc :Gcommit -v -q<CR>
  nnoremap <silent> <leader>gd :Gdiff<CR>
  nnoremap <silent> <leader>gl :Glog<CR>
  nnoremap <silent> <leader>gs :Gstatus<CR>
  nnoremap <silent> <leader>gt :Gcommit -v -q %<CR>
  nnoremap <silent> <leader>gw :Gwrite<CR><CR>
" }}}
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
" {{{
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#ignore_bufadd_pat = 'defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline#extensions#tabline#left_sep = ' '
" }}}
Plug 'wellle/targets.vim'
Plug 'wsdjeg/vim-fetch'
call plug#end()

syntax on
filetype plugin indent on

colorscheme codedark

augroup auto_file
  autocmd!
  " Refresh file if modified externally
  autocmd BufEnter,FocusGained * :checktime
  " Goto last edit position automatically
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  " Automatically remove unwanted spaces
  autocmd BufWritePre * %s/\s\+$//e
  autocmd FileType text setlocal textwidth=78
augroup END

" Remap <ESC> to allow terminal escaping
augroup term_escape_map
  autocmd!
  autocmd termopen * tnoremap <buffer> <esc> <c-\><c-n>
  autocmd filetype fzf tunmap <buffer> <esc>
augroup END

" Automatically quit terminal after exit
augroup exit_term
  autocmd!
  autocmd TermClose term://*
        \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
        \   call nvim_input('<CR>')  |
        \ endif
augroup END

runtime macros/sandwich/keymap/surround.vim

set autoread
set expandtab
set foldlevelstart=99
set foldmethod=indent
set foldnestmax=20
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set hidden
set ignorecase
set incsearch
set mouse=
set nobackup
set nonumber
set norelativenumber
set noswapfile
set path=,,
set scrolloff=0
set shiftwidth=2
set smartcase
set splitbelow
set splitright
set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
set termguicolors
set undofile
set updatetime=100

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

" Fixes windows backspace not doing <BS> behavior
" Apparently on windows term, the backspace key is mapped to <C-h>
nmap <C-h> <BS>

nnoremap 0 ^
nnoremap <silent> <BS> <C-^>
nnoremap <silent> <leader>ba :bufdo bd<CR>
nnoremap <silent> <leader>bd :Kwbd<CR>
nnoremap <silent> <leader>cd :cd %:p:h<CR>:echom "cd -> " . expand("%:p:h")<CR>
nnoremap <silent> <leader>e :Ex<CR>
nnoremap <silent> <leader>h :noh<CR>
nnoremap <silent> <leader>q :q<CR>
nnoremap <silent> <leader>ve :e $MYVIMRC<CR>
nnoremap <silent> <leader>vs :source $MYVIMRC<CR>:echom "init.vim reloaded"<CR>
nnoremap <silent> <leader>w :w<CR>
nnoremap gp `[v`]
nnoremap j gj
nnoremap k gk
noremap Y y$

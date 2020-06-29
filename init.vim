function! AutoInstallVimPlug()
  let l:plug_path = stdpath('data') . '/site/autoload/plug.vim'
  if !filereadable(l:plug_path)
    silent execute '!curl -fLo ' . l:plug_path . ' --create-dirs
      \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfunction

set autoread
set iskeyword-=_
set expandtab
set hidden
set mouse=
set nonumber norelativenumber
set shiftwidth=2
set so=0
set t_Co=256
set t_ut=
set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
set termguicolors

let $FZF_DEFAULT_COMMAND = 'rg --files --follow'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#ignore_bufadd_pat = 'defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline_theme = 'codedark'
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let mapleader = "\<Space>"

call AutoInstallVimPlug()

call plug#begin(stdpath('data') . '/plugged')
Plug 'LnL7/vim-nix'
Plug 'dunstontc/vim-vscode-theme'
Plug 'elixir-editors/vim-elixir'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
" {{{
  nnoremap <silent> <leader>md :MarkdownPreviewStop<CR>
  nnoremap <silent> <leader>me :MarkdownPreview<CR>
" }}}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" {{{
  nnoremap <silent> <leader>/ :exec 'Rg ' . input('Rg/')<CR>
  nnoremap <silent> <leader><leader> :Files<CR>
  nnoremap <silent> <leader>fb :Buffers<CR>
  nnoremap <silent> <leader>fh :History<CR>
  nnoremap <silent> <leader>fl :BLines<CR>
  nnoremap <silent> <leader>fs :exec 'Rg ' . expand('<cword>')<CR>
  vnoremap <silent> / y/<C-r>"<CR>
  vnoremap <silent> <leader>fl y:BLines <C-r>"<CR>
" }}}
Plug 'kassio/neoterm'
" {{{
  nnoremap <silent> <leader>t :Ttoggle<CR>
  augroup term_escape
    autocmd!
    autocmd termopen * tnoremap <buffer> <esc> <c-\><c-n>
    autocmd filetype fzf tunmap <buffer> <esc>
  augroup END
" }}}
Plug 'michaeljsmith/vim-indent-object'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" {{{
  nmap <silent> <leader>ld :CocDiagnostics<CR>
  nmap <silent> <leader>lg <Plug>(coc-definition)
  nmap <silent> <leader>lr <Plug>(coc-rename)
  nmap <silent> <leader>lp <Plug>(coc-references)
  nmap <silent> <leader>li <Plug>(coc-implementation)
" }}}
Plug 'neovimhaskell/haskell-vim'
Plug 'rust-lang/rust.vim'
Plug 'takac/vim-hardtime'
" {{{
  let g:hardtime_default_on = 1
  let g:hardtime_timeout = 1000
" }}}
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
" {{{
  nnoremap <silent> <leader>ga :Gcommit --amend -v -q<CR>
  nnoremap <silent> <leader>gc :Gcommit -v -q<CR>
  nnoremap <silent> <leader>gd :Gdiff<CR>
  nnoremap <silent> <leader>gl :Glog<CR>
  nnoremap <silent> <leader>gs :Gstatus<CR>
  nnoremap <silent> <leader>gt :Gcommit -v -q %<CR>
  nnoremap <silent> <leader>gw :Gwrite<CR><CR>
" }}}
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
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

augroup auto_term
  autocmd!
  autocmd TermClose term://*
            \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
            \   call nvim_input('<CR>')  |
            \ endif
augroup END

map 0 ^
nmap j gj
nmap k gk
nnoremap <silent> <leader>ba :bufdo bd<CR>
nnoremap <silent> <leader>bd :bd<CR>
nnoremap <silent> <leader>h :noh<CR>
nnoremap <silent> <leader>e :Ex<CR>
nnoremap <silent> <leader>q :q<CR>
nnoremap <silent> <leader>ve :e $MYVIMRC<CR>
nnoremap <silent> <leader>vs :source $MYVIMRC<CR>:echo "init.vim reloaded"<CR>
nnoremap <silent> <leader>w :w<CR>

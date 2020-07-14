let mapleader = "\<Space>"

call plug#begin(stdpath('data') . '/plugged')
Plug 'LnL7/vim-nix'
Plug 'elixir-editors/vim-elixir'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'itchyny/lightline.vim'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
Plug 'machakann/vim-sandwich'
Plug 'michaeljsmith/vim-indent-object'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'neovimhaskell/haskell-vim'
Plug 'puremourning/vimspector'
Plug 'rust-lang/rust.vim'
Plug 'skbolton/embark'
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'vn-ki/coc-clap'
Plug 'wellle/targets.vim'
Plug 'wsdjeg/vim-fetch'
call plug#end()

syntax on
filetype plugin indent on

let g:lightline = {}
let g:lightline.active = {}
let g:lightline.active.left = [['mode'], ['gitbranch', 'filename', 'modified']]
let g:lightline.colorscheme = 'codedark'
let g:lightline.component_function = { 'gitbranch': 'LightLineGitBranch' }
let g:clap_insert_mode_only = v:true
let g:clap_layout = { 'relative': 'editor' }
let g:clap_popup_input_delay = 50
let g:clap_provider_grep_delay = 50
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_contrast_light = 'medium'
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

colorscheme codedark

augroup File
  autocmd!
  autocmd BufEnter,FocusGained * :checktime
  autocmd BufReadPost * :call RestoreLastCursorPosition()
  autocmd BufWritePre * lua require("buffer").trim_whitespace()
  autocmd FileType netrw setl bufhidden=wipe
  autocmd FileType text setlocal textwidth=78
augroup END

augroup Terminal
  autocmd!
  " Automatically quit terminal after exit
  autocmd TermClose term://*
        \ if (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
        \   call nvim_input('<CR>')  |
        \ endif
  " Remap <ESC> to allow terminal escaping
  autocmd TermOpen * tnoremap <buffer> <ESC> <C-\><C-n>
augroup END

runtime macros/sandwich/keymap/surround.vim

set autoread
set background=dark
set backspace=indent,eol,start
if has("win32")
  set clipboard=unnamed
endif
set expandtab
set expandtab tabstop=2 shiftwidth=2
set foldlevelstart=99
set foldmethod=indent
set foldnestmax=20
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set hidden
set ignorecase smartcase
set incsearch
set mouse=
set nobackup
set noruler
set noswapfile
set path+=src/**,test/**
set scrolloff=0
set shiftwidth=2
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

" File
nmap <BS> <C-^>
nmap <silent> con <Plug>(coc-rename)
nmap <silent> glr <Plug>(coc-references)
nmap <silent> god <Plug>(coc-definition)
nmap <silent> goi <Plug>(coc-implementation)
nnoremap ' `
nnoremap / ms/
nnoremap 0 ^
nnoremap <C-p> <C-i>
nnoremap <Tab> :ls<CR>:b<Space>
nnoremap <silent> ,ga :Gcommit --amend -v -q<CR>
nnoremap <silent> ,gb :Gblame<CR>
nnoremap <silent> ,gc :Gcommit -v -q<CR>
nnoremap <silent> ,gd :Gdiff<CR>
nnoremap <silent> ,gl :Glog<CR>
nnoremap <silent> ,gs :Gstatus<CR>
nnoremap <silent> ,gw :Gwrite<CR><CR>
nnoremap <silent> ,ve :edit $MYVIMRC<CR>
nnoremap <silent> ,vs :source $MYVIMRC<CR>:echom "init.vim reloaded"<CR>
nnoremap <silent> <F5> :e %<CR>
nnoremap <silent> <Space>bd :<C-u>Kwbd<CR>
nnoremap <silent> <Space>cd :cd %:p:h<CR>:echom ":cd " . expand("%:p:h")<CR>
nnoremap <silent> <Space>h :noh<CR>
nnoremap <silent> <Space>q :q<CR>
nnoremap <silent> <Space>w :w<CR>
nnoremap <silent> gV `[v`]
nnoremap <silent> gld :CocList diagnostics<CR>
nnoremap <silent> gli :Clap files ++finder=rg --files --follow<CR>
nnoremap <silent> gls :CocList symbols<CR>
nnoremap <silent> goe :Ex<CR>
nnoremap <silent> got :call <SID>ToggleTerm("term://primary")<CR>
nnoremap ? ms?
nnoremap U <C-r>
nnoremap Y y$
nnoremap coh :%s///g<Left><Left>
nnoremap g/ :g//#<Left><Left>
nnoremap gs :Grep<Space>
nnoremap gw <C-w>
nnoremap j gj
nnoremap k gk
xnoremap coh :s///g<Left><Left>

" Habit Breaks
nnoremap <C-r> <Nop>
nnoremap <C-w> <Nop>
nnoremap <Space>ve <Nop>
nnoremap <Space>vs <Nop>
nnoremap ` <Nop>

" Auto Expansion
inoremap {<CR> {<CR>}<C-o>O
inoremap [<CR> [<CR>]<C-oi>O

" Text Object
onoremap <silent> ao :<C-u>call AChunkTextObject()<CR>
onoremap <silent> io :<C-u>call InnerChunkTextObject()<CR>
vnoremap <silent> ao <ESC>:call AChunkTextObject()<CR><ESC>gv
vnoremap <silent> io <ESC>:call InnerChunkTextObject()<CR><ESC>gv

xnoremap i% :<C-u>let z = @/\|1;/^./kz<CR>G??<CR>:let @/ = z<CR>V'z
onoremap i% :<C-u>normal vi%<CR>
xnoremap a% GoggV
onoremap a% :<C-u>normal va%<CR>

function! VisualNumber()
	call search('\d\([^0-9\.]\|$\)', 'cW')
	normal v
	call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call VisualNumber()<CR>
onoremap in :<C-u>normal vin<CR>

xnoremap il g_o^
onoremap il :<C-u>normal vil<CR>
xnoremap al $o0
onoremap al :<C-u>normal val<CR>

" Abbreviation
cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'
cnoreabbrev <expr> make (getcmdtype() ==# ':' && getcmdline() ==# 'make') ? 'Make' : 'make'
cnoreabbrev <expr> bd "Kwbd"

command! -nargs=+ -complete=file_in_path -bar Grep silent! grep! <args> | redraw! | cwindow 3
command! -nargs=+ -complete=file_in_path -bar LGrep silent! lgrep! <args> | redraw! | lwindow 3
command! -nargs=* Make silent make <args> | cwindow 3

" Credits to romainl
function! CommandLineCompletionCR()
    let cmdline = getcmdline()
    if cmdline =~ '\v\C^(ls|files|buffers)'
        " like :ls but prompts for a buffer command
        return "\<CR>:b\<Space>"
    elseif cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
        " like :g//# but prompts for a command
        return "\<CR>:"
    elseif cmdline =~ '\v\C^(dli|il)'
        " like :dlist or :ilist but prompts for a count for :djump or :ijump
        return "\<CR>:" . cmdline[0] . "j  " . split(cmdline, " ")[1] . "\<S-Left>\<Left>"
    " elseif cmdline =~ '\v\C^(cli|lli)'
    "     " like :clist or :llist but prompts for an error/location number
    "     return "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
    " SEARCH CLIPBOARD BREAKS IT
    elseif cmdline =~ '\C^old'
        " like :oldfiles but prompts for an old file to edit
        set nomore
        return "\<CR>:sil se more|e #<"
    elseif cmdline =~ '\C^changes'
        " like :changes but prompts for a change to jump to
        set nomore
        return "\<CR>:sil se more|norm! g;\<S-Left>"
    elseif cmdline =~ '\C^ju'
        " like :jumps but prompts for a position to jump to
        set nomore
        return "\<CR>:sil se more|norm! \<C-o>\<S-Left>"
    elseif cmdline =~ '\C^marks'
        " like :marks but prompts for a mark to jump to
        return "\<CR>:norm! `"
    elseif cmdline =~ '\C^undol'
        " like :undolist but prompts for a change to undo
        return "\<CR>:u "
    else
        return "\<CR>"
    endif
endfunction
cnoremap <expr> <CR> CommandLineCompletionCR()

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

function! s:ToggleTerm(termname)
  let exists = bufexists(a:termname)
  if exists > 0
    execute "buffer " . a:termname
  else
    terminal
    execute "keepalt file " . a:termname
  endif
endfunction

function! LightLineGitBranch()
  if exists('*fugitive#head') && winwidth('.') > 75
    let bmark = '┣ '
    let branch = fugitive#head()
    return strlen(branch) ? bmark . branch : ''
  endif
  return ''
endfunction

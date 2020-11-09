let $FZF_DEFAULT_COMMAND = 'rg --files --follow --hidden --glob !.git'
let g:coc_global_extensions = ['coc-tsserver', 'coc-python']
let g:fzf_layout = { 'window': { 'width': 0.5461, 'height': 0.6, 'yoffset': 0.5, 'border': 'sharp' } }
let g:netrw_altfile = 1
let g:netrw_fastbrowse = 0
let g:user_emmet_leader_key = '<C-z>'

call plug#begin(stdpath('data') . '/plugged')
" Function
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'machakann/vim-sandwich'
Plug 'mattn/emmet-vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'wellle/targets.vim'
" Language
Plug 'elixir-editors/vim-elixir'
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'peitalin/vim-jsx-typescript'
" Visual
Plug 'tomasiser/vim-code-dark'
call plug#end()

silent! colorscheme codedark

set cmdwinheight=7
set fileformat=unix
set fileformats=unix,dos
set grepprg=rg\ --follow\ --hidden\ --vimgrep\ --glob\ !.git
set inccommand=nosplit
set lazyredraw
set mouse=
set nojoinspaces
set noruler
set splitbelow
set splitright
set termguicolors
set wildmode=list:longest,full

set statusline=
set statusline+=%(\ %{toupper(mode(0))}%)
set statusline+=%(\ @%{fugitive#head()}%)
set statusline+=%(\ %<%f%)
set statusline+=\ %h%m%r%w
set statusline+=%=
set statusline+=%([%n]%)
set statusline+=%(%<\ [%{&ff}]\ %y\ %l:%c\ %p%%\ %)

nnoremap - <Cmd>call nnn#bufopen()<CR>
nnoremap <BS> <C-^>
nnoremap <Space>fd <Cmd>Kwbd<CR>
nnoremap <Space>fo <Cmd>Files<CR>
nnoremap <Space>gD <Cmd>Gvdiffsplit HEAD<CR>
nnoremap <Space>gb <Cmd>G blame<CR>
nnoremap <Space>gd <Cmd>Gvdiffsplit<CR>
nnoremap <Space>gl <Cmd>Gclog<CR>
nnoremap <Space>gs <Cmd>G<CR>
nnoremap <Space>q <Cmd>q<CR>
nnoremap <Space>w <Cmd>w<CR>
nnoremap <Tab> :ls<CR>:b<Space>
nnoremap _ <Cmd>call nnn#open(".")<CR>
nnoremap g/ :sil!gr!<Space>
nnoremap gd <Cmd>call <SID>fsearchdecl(expand("<cword>"))<CR>
nnoremap z/ :g//#<Left><Left>

nmap q] <Plug>(coc-definition)*``
nmap qc <Plug>(coc-rename)
nmap qi <Plug>(coc-implementation)
nmap qr <Plug>(coc-references)
nnoremap Q q
nnoremap q <Nop>
nnoremap q/ q/
nnoremap q: q:
nnoremap q? q?
nnoremap qfp <Cmd>%!python -m black --fast -q -<CR>
nnoremap qlp <Cmd>Flake8%<CR>

nnoremap <l <Cmd>exe 'lolder' v:count1<CR>
nnoremap <q <Cmd>exe 'colder' v:count1<CR>
nnoremap >l <Cmd>exe 'lnewer' v:count1<CR>
nnoremap >q <Cmd>exe 'cnewer' v:count1<CR>
nnoremap [q <Cmd>exe v:count1 . 'cprev'<CR>
nnoremap ]q <Cmd>exe v:count1 . 'cnext'<CR>

inoremap (<CR> (<CR>)<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap {<CR> {<CR>}<Esc>O

nnoremap <expr> <C-L> (v:count ? '<Cmd>edit<CR>' : '')
      \ . '<Cmd>noh<CR>'
      \ . (has('diff') ? '<Cmd>diffupdate<CR>' : '')
      \ . '<Cmd>redraw<CR>'

cnoremap <expr> <CR> ccr#run()

command! Echrome sil !chrome "file://%:p"
command! Ecode sil exe "!code -nwg" expand("%:p") . ":" . line('.') . ":" . col('.') "."
command! Edata sil exe "e" stdpath('data')
command! Eftp sil exe "e" stdpath('config') . '/after/ftplugin/' . &filetype . '.vim'
command! Eidea sil exe "!idea64" expand("%:p") . ":" . line('.')
command! Einit sil exe "e" stdpath('config') . '/init.vim'
command! Emacs sil exe '!emacsclientw -a "" +' . line('.') . ":" . col('.') bufname("%")
command! Esyn sil exe "e $RTP/after/syntax/" . &filetype . ".vim"
command! Hitest sil so $VIMRUNTIME/syntax/hitest.vim | set ro
command! Kwbd call kwbd#run()

command! -nargs=* Flake8 call <SID>flake8(<q-args>)
func! s:flake8(args) abort
  let oldmake = &l:makeprg
  let olderr = &l:errorformat
  let &l:makeprg = get(g:, "flake8_path", "flake8")
  setlocal errorformat=%f:%l:%c:\ %t%n\ %m
  exe "sil mak!" a:args
  let &l:makeprg = oldmake
  let &l:errorformat = olderr
endfunc

command! -nargs=0 Syn call s:syn()
func! s:syn()
  for id in synstack(line("."), col("."))
    echo synIDattr(id, "name")
  endfor
endfunc

func! s:fsearchdecl(name) abort
  if empty(a:name)
    echohl ErrorMsg
    echom "No identifier under cursor"
    echohl None
    return
  endif
  let @/ = '\V\<' . a:name . '\>'
  norm [[{
  let row = search(@/, 'cW')
  while row && s:iscomment(".", ".")
    let row = search(@/, 'cW')
  endwhile
  if &hls
    set hls
  endif
  redraw
endfunc

func! s:iscomment(line, col) abort
  return synIDattr(synIDtrans(synID(line(a:line), col(a:col), 1)), "name") == "Comment"
endfunc

aug nnn_hijack
  au!
  au VimEnter * if exists('#FileExplorer') | exe 'au! FileExplorer *' | endif
  au BufEnter * if isdirectory(expand('%'))
        \ | let w:nnn_open_dir = expand('%')
        \ | exe 'Kwbd'
        \ | call nnn#open(w:nnn_open_dir) | endif
aug END

nnoremap <Space>; <Cmd>let g:usercmd=1<CR>:
augroup usercmd
  au!
  au CmdlineEnter * call usercmd#map()
  au CmdlineChanged,CmdlineLeave * call usercmd#unmap()
augroup END

augroup general 
  au!
  au FocusGained,BufEnter * silent! checktime
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit'|
        \   exe "normal! g`\""|
        \ endif
augroup END

augroup quickfix
  au!
  au QuickFixCmdPost [^l]* cwindow
  au QuickFixCmdPost l* lwindow
augroup END

augroup terminal
  au!
  au TermOpen term://* if (&ft !~ "nnn") | tnoremap <buffer> <ESC> <C-\><C-n> | endif
  au TermClose term://*
        \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "coc") |
        \   exe "Kwbd" |
        \ endif
augroup END

aug wsl_preload
  au!
  au VimEnter * if has('win32') | call jobstart("wsl") | endif
aug END

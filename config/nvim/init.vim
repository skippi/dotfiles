let $FZF_DEFAULT_COMMAND = 'rg --files --follow --hidden --glob !.git'
let $RTP = stdpath('config')
let g:coc_global_extensions = ['coc-tsserver', 'coc-python']
let g:fzf_layout = { 'window': { 'width': 0.5461, 'height': 0.6, 'yoffset': 0.5, 'border': 'sharp' } }
let g:netrw_altfile = 1
let g:netrw_fastbrowse = 0
let g:qf_auto_open_loclist = 0
let g:qf_auto_open_quickfix = 0
let g:textobj_sandwich_no_default_key_mappings = 1
let g:dispatch_no_maps = 1
let g:user_emmet_leader_key = '<C-z>'

call plug#begin(stdpath('data') . '/plugged')
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'machakann/vim-sandwich'
Plug 'mattn/emmet-vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'romainl/vim-qf'
Plug 'sheerun/vim-polyglot'
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-sleuth'
Plug 'wellle/targets.vim'
call plug#end()

silent! call operator#sandwich#set('all', 'all', 'highlight', 0)
runtime macros/sandwich/keymap/surround.vim

silent! colorscheme codedark

set cmdwinheight=7
set fileformat=unix
set fileformats=unix,dos
set grepprg=rg\ --follow\ --hidden\ --vimgrep\ --glob\ !.git
set hidden
set ignorecase
set inccommand=nosplit
set lazyredraw
set mouse=
set nojoinspaces
set noruler
set noswapfile
set smartcase
set splitbelow
set splitright
set termguicolors
set timeoutlen=500
set undofile
set updatetime=100
set wildcharm=<C-z>
set wildmode=list:full

set statusline=
set statusline+=%(\ %{toupper(mode(0))}%)
set statusline+=%(\ @%{fugitive#head()}%)
set statusline+=%(\ %<%f%)
set statusline+=\ %h%m%r%w
set statusline+=%=
set statusline+=%([%n]%)
set statusline+=%(%<\ [%{&ff}]\ %y\ %l:%c\ %p%%\ %)

set path=,,**

set wildignore+=*.beam
set wildignore+=*/.elixir_ls/*
set wildignore+=*/_build/*
set wildignore+=*/node_modules/*

" windows <BS> fix
nmap <C-h> <BS>

" disable <C-z> win32 memory leak
if has('win32')
  nnoremap <C-z> <Nop>
endif

map [[ ?{<CR>w99[{
map [] k$][%?}<CR>
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
nnoremap - <Cmd>call nnn#bufopen()<CR>
nnoremap <BS> <C-^>
nnoremap <C-p> <C-i>
nnoremap <Tab> :ls<CR>:b<Space>
nnoremap U <C-r>
nnoremap Y y$
nnoremap _ <Cmd>call nnn#open(".")<CR>
noremap ' `
noremap <expr> j (v:count ? 'm`' . v:count . 'j' : 'gj')
noremap <expr> k (v:count ? 'm`' . v:count . 'k' : 'gk')

nnoremap <Space> <Nop>
nnoremap <Space><Space> :'{,'}s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Space>P "+P
nnoremap <Space>Y "+yg_
nnoremap <Space>d <Cmd>Kwbd<CR>
nnoremap <Space>e :Emru<Space>
nnoremap <Space>f :find *
nnoremap <Space>gD <Cmd>Gvdiffsplit HEAD<CR>
nnoremap <Space>gb <Cmd>G blame<CR>
nnoremap <Space>gd <Cmd>Gvdiffsplit<CR>
nnoremap <Space>gl <Cmd>Gclog<CR>
nnoremap <Space>gs <Cmd>G<CR>
nnoremap <Space>p "+p
nnoremap <Space>q <Cmd>q<CR>
nnoremap <Space>w <Cmd>w<CR>
nnoremap <Space>y "+y
nnoremap <expr> <Space>; <SID>setusercmd(':')
noremap <expr> <Space>/ <SID>setfuzzy('/')
noremap <expr> <Space>? <SID>setfuzzy('?')

nnoremap d<CR> <Cmd>Dispatch<CR>
nnoremap d<Space> :Dispatch<Space>

nnoremap m, #``cgN
nnoremap m; *``cgn
nnoremap m<CR> <Cmd>Make<CR>
nnoremap m<Space> :Make<Space>
nnoremap m? <Cmd>Copen!<CR>
vnoremap m, "hy?\V<C-R>=escape(@h,'/\')<CR><CR>``cgN
vnoremap m; "hy/\V<C-R>=escape(@h,'/\')<CR><CR>``cgn

map gs <Plug>(room_grep)
nnoremap g. :sil!gr!<Up><CR>
nnoremap g/ :sil!gr!<Space>
noremap gd <Cmd>call <SID>fsearchdecl(expand("<cword>"))<CR>
noremap gh ^
noremap gl g_
noremap gw <C-w>

nnoremap z/ :g//#<Left><Left>

nmap q] <Plug>(coc-definition)*``
nmap qc <Plug>(coc-rename)
nmap qi <Plug>(coc-implementation)
nmap qq <Plug>(qf_qf_toggle)
nmap qr <Plug>(coc-references)
nnoremap Q q
nnoremap q <Nop>
nnoremap q/ q/
nnoremap q: q:
nnoremap q? q?

nnoremap [q <Cmd>exe v:count1 . 'cprev'<CR>
nnoremap ]q <Cmd>exe v:count1 . 'cnext'<CR>

nnoremap '# <Cmd>Esyn<CR>
nnoremap '$ <Cmd>Einit<CR>
nnoremap '@ <Cmd>Eftp<CR>

inoremap (<CR> (<CR>)<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap {<CR> {<CR>}<Esc>O

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <expr> <C-L> (v:count ? '<Cmd>edit<CR>' : '')
      \ . '<Cmd>noh<CR>'
      \ . (has('diff') ? '<Cmd>diffupdate<CR>' : '')
      \ . '<Cmd>redraw<CR>'

cnoremap <expr> <CR> ccr#run()
cnoremap <expr> <Tab> getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-z>"
cnoremap <expr> <S-Tab> getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>?<C-r>/" : "<S-C-z>"

command! Scratch vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
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

command! -nargs=0 Syn
      \ for id in synstack(line("."), col(".")) |
      \   echo synIDattr(id, "name") |
      \ endfor

command! -nargs=1 -complete=customlist,<sid>mrucomplete Emru edit <args>
func! s:mrucomplete(lead, cmdline, pos)
  let matches = filter(copy(v:oldfiles), 'v:val =~ a:lead && v:val !~ "^fugitive"')
  return map(copy(matches), {_, m -> fnamemodify(m, ':~:.')})
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

func! s:setfuzzy(cmd)
  aug fuzztemp
    au!
    au CmdlineLeave * exe "sil! cunmap <buffer> <Space>" | au! fuzztemp
  aug END
  cnoremap <buffer> <Space> .*
  return a:cmd
endfunc

func! s:setusercmd(cmd) abort
  aug usercmd
    au!
    au CmdlineChanged,CmdlineLeave * 
          \ for i in range(97, 122) |
          \   exe "sil! cunmap <buffer>" nr2char(i) |
          \ endfor |
          \ au! usercmd
  aug END
  for i in range(97, 122) |
    exe "cnoremap <buffer>" nr2char(i) nr2char(i - 32) |
  endfor
  return a:cmd
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

aug qf_open
  au!
  au QuickFixCmdPost grep cwindow
  au QuickFixCmdPost lgrep lwindow
aug END

aug general 
  au!
  au FocusGained,BufEnter * silent! checktime
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit'|
        \   exe "normal! g`\""|
        \ endif
aug END

aug terminal
  au!
  au TermOpen term://* if (&ft !~ "nnn") | tnoremap <buffer> <ESC> <C-\><C-n> | endif
  au TermClose term://*
        \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "coc") |
        \   exe "Kwbd" |
        \ endif
aug END

aug wsl_preload
  au!
  au VimEnter * if has('win32') | call jobstart("wsl") | endif
aug END

aug file
  au!
  au TextYankPost * silent! lua require("vim.highlight").on_yank()
aug END

aug oldfiles
  au!
  au BufWinEnter * call <SID>pusholdfiles(expand("<afile>:p"))
  au BufDelete,BufWipeout * call <SID>popoldfiles(expand("<afile>:p"))
aug END

func! s:pusholdfiles(fname) abort
  if empty(a:fname) || !filereadable(a:fname) || !&buflisted
    return
  endif
  let v:oldfiles = [a:fname] + filter(v:oldfiles, {_, f -> f !=# a:fname})
endfunc

func! s:popoldfiles(fname) abort
  if empty(a:fname) || filereadable(a:fname)
    return
  endif
  call filter(v:oldfiles, {_, f -> f !=# a:fname})
endfunc

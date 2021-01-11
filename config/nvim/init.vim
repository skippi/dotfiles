let $FZF_DEFAULT_COMMAND = 'rg --files --follow --hidden --glob !.git'
let $RTP = stdpath('config')
let g:completion_auto_change_source = 1
let g:completion_confirm_key = ""
let g:completion_enable_snippet = "vim-vsnip"
let g:completion_sorting = "length"
let g:completion_timer_cycle = 40
let g:dirvish_mode = ':sort ,^.*[\/],'
let g:dispatch_no_maps = 1
let g:fzf_layout = { 'window': { 'width': 0.5461, 'height': 0.6, 'yoffset': 0.5, 'border': 'sharp' } }
let g:fzf_preview_window = []
let g:netrw_altfile = 1
let g:netrw_fastbrowse = 0
let g:qf_auto_open_loclist = 0
let g:qf_auto_open_quickfix = 0
let g:qf_auto_quit = 0 " tab close bug
let g:textobj_sandwich_no_default_key_mappings = 1
let g:user_emmet_leader_key = '<C-z>'
let g:vsnip_snippet_dir = stdpath('config') . '/vsnip'

call plug#begin(stdpath('data') . '/plugged')
Plug 'AndrewRadev/splitjoin.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'machakann/vim-sandwich'
Plug 'mattn/emmet-vim'
Plug 'mfussenegger/nvim-dap'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
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
set completeopt=menuone,noinsert,noselect
set completeslash=slash
set fileformat=unix
set fileformats=unix,dos
set foldlevelstart=99
set foldmethod=indent
set grepprg=rg\ --follow\ --hidden\ --vimgrep\ --glob\ !.git
set hidden
set ignorecase
set inccommand=nosplit
set mouse=a
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

set wildignore+=*.#*,*.cbk,*.csm,*.dcp,*.dsk,*.i,*.il?,*.local,*.rsm,*.~* " C++ builder
set wildignore+=*.[Xx][Ll][Ss]
set wildignore+=*.beam
set wildignore+=*.bpi,*.bpl,*.dll,*.exe,*.hlp,*.lib,*.map,*.pdi,*.tds " Windows
set wildignore+=*.cpe
set wildignore+=*.dll
set wildignore+=*.lib
set wildignore+=*.nupkg
set wildignore+=*.o
set wildignore+=*.pdb
set wildignore+=*.pyc
set wildignore+=*.xlsm
set wildignore+=*.xlsx
set wildignore+=*/.elixir_ls/*
set wildignore+=*/_build/*
set wildignore+=*/build/*
set wildignore+=*/node_modules/*
set wildignore+=*/packages/*
set wildignore+=*/server/*
set wildignore+=Session.vim

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
nnoremap <BS> <C-^>
nnoremap <C-p> <C-i>
nnoremap <Tab> :ls<CR>:b<Space>
nnoremap P ]P
nnoremap U <C-r>
nnoremap Y y$
nnoremap p ]p
noremap ' `
noremap <expr> j (v:count ? 'm`' . v:count . 'j' : 'gj')
noremap <expr> k (v:count ? 'm`' . v:count . 'k' : 'gk')
vnoremap P ]P
vnoremap p ]p

nnoremap <Space> <Nop>

nnoremap <Space><Space> :'{,'}s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Space>F <Cmd>Files<CR>
nnoremap <Space>P "+]P
nnoremap <Space>Y "+yg_
nnoremap <Space>d <Cmd>Kwbd<CR>
nnoremap <Space>e :Emru<Space>
nnoremap <Space>f <Cmd>GFiles<CR>
nnoremap <Space>p "+]p
nnoremap <Space>q <Cmd>q<CR>
nnoremap <Space>t <Cmd>tabnew<CR>
nnoremap <Space>w <Cmd>w<CR>
nnoremap <Space>y "+y
nnoremap <Space>yp <Cmd>let @+ = expand("%:p")<CR>
vnoremap <Space>P "+]P
vnoremap <Space>p "+]p
vnoremap <Space>y "+y

nnoremap d<CR> <Cmd>Dispatch<CR>
nnoremap d<Space> :Dispatch<Space>

nnoremap m, #``cgN
nnoremap m; *``cgn
nnoremap m<CR> <Cmd>Make<CR>
nnoremap m<Space> :Make<Space>
nnoremap m= :set makeprg=
nnoremap m? <Cmd>Copen!<CR>
vnoremap m, "hy?\V<C-R>=escape(@h,'/\')<CR><CR>``cgN
vnoremap m; "hy/\V<C-R>=escape(@h,'/\')<CR><CR>``cgn

nnoremap g. <Cmd>Gvdiffsplit<CR>
nnoremap g/ :sil!gr!<Space>
nnoremap g<CR> <Cmd>G<CR>
nnoremap g<Space> :G<Space>
nnoremap g> <Cmd>Gvdiffsplit HEAD<CR>
nnoremap gL <Cmd>Gclog<CR>
nnoremap gb <Cmd>G blame<CR>
nnoremap gof <Cmd>sil !FlowCalExe\_LaunchFC.cmd<CR>
nnoremap goi <Cmd>EFlowCal<CR>
nnoremap gs <Cmd>set opfunc=util#grepfunc<CR>g@
nnoremap gy <Cmd>set operatorfunc=<SID>yankpast<CR>g@
nnoremap gyy <Cmd>set operatorfunc=<SID>yankpast<CR>g@_
noremap gd <Cmd>call <SID>fsearchdecl(expand("<cword>"))<CR>
noremap gh ^
noremap gl g_
noremap gw <C-w>
vnoremap gs <Esc><Cmd>call util#grepfunc(visualmode(), 1)<CR>
vnoremap gy <Esc><Cmd>call <SID>yankpast(visualmode(), 1)<CR>

" PSReadLine bug
tnoremap <M-c> <M-c>
tnoremap <M-h> <M-h>

nnoremap z/ :g//#<Left><Left>

nnoremap s <Nop>
nnoremap s] <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap sc <Cmd>lua vim.lsp.buf.rename()<CR>
nnoremap sd <Cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap si <Cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap sr <Cmd>lua vim.lsp.buf.references()<CR>

nmap qq <Plug>(qf_qf_toggle)
nnoremap Q q
nnoremap q <Nop>
nnoremap q/ q/
nnoremap q: q:
nnoremap q? q?

nnoremap [p P
nnoremap [q <Cmd>exe v:count1 . 'cprev'<CR>
nnoremap ]p p
nnoremap ]q <Cmd>exe v:count1 . 'cnext'<CR>

nnoremap '# <Cmd>Esyn<CR>
nnoremap '$ <Cmd>Einit<CR>
nnoremap '@ <Cmd>Eftp<CR>

inoremap (<CR> (<CR>)<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap {<CR> {<CR>}<Esc>O

imap <expr> <CR> <SID>imapcr()
imap <expr> <S-Tab> <SID>imapstab()
imap <expr> <Tab> <SID>imaptab()

nnoremap <expr> <C-L>
      \ (v:count ? '<Cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>' : '')
      \ . (v:count ? '<Cmd>edit<CR>' : '')
      \ . '<Cmd>noh<CR>'
      \ . (has('diff') ? '<Cmd>diffupdate<CR>' : '')
      \ . '<Cmd>redraw<CR>'

cnoremap <expr> <CR> ccr#run()
cnoremap <expr> <Tab> <SID>tabsearch(getcmdtype())
cnoremap <expr> <S-Tab> <SID>stabsearch(getcmdtype())

function! s:imaptab() abort
  if pumvisible() | return "\<C-n>" | endif
  if vsnip#jumpable(1) | return "\<Plug>(vsnip-jump-next)" | endif
  return "\<Tab>"
endfunction

function! s:imapstab() abort
  if pumvisible() | return "\<C-p>" | endif
  if vsnip#jumpable(1) | return "\<Plug>(vsnip-jump-prev)" | endif
  return "\<S-Tab>"
endfunction

function! s:imapcr() abort
  if !pumvisible() | return "\<CR>" | endif
  if complete_info()["selected"] == "-1" | return "\<C-e>\<CR>" | endif
  if vsnip#expandable() | return "\<Plug>(vsnip-expand)" | endif
  return "\<Plug>(completion_confirm_completion)"
endfunction

func! s:tabsearch(cmd) abort
  if a:cmd == '/' | return "\<C-g>" | endif
  if a:cmd == '?' | return "\<C-t>" | endif
  return "\<C-z>"
endfunc

func! s:stabsearch(cmd) abort
  if a:cmd == '/' | return "\<C-t>" | endif
  if a:cmd == '?' | return "\<C-g>" | endif
  return "\<S-Tab>"
endfunc

command! EFlowCal sil !StartIDE.cmd
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
command! Scratch vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile

command! -nargs=0 Syn
      \ for id in synstack(line("."), col(".")) |
      \   echo synIDattr(id, "name") |
      \ endfor

command! -nargs=1 -complete=customlist,<sid>mrucomplete Emru edit <args>
func! s:mrucomplete(lead, cmdline, pos)
  let matches = filter(copy(v:oldfiles), 'v:val =~ a:lead && v:val !~ "^fugitive"')
  return map(copy(matches), {_, m -> fnamemodify(m, ':~:.')})
endfunc

command! -nargs=* -complete=file -range -bang MShdo call <SID>mshdo(<bang>0 ? argv() : getline(<line1>, <line2>), <q-args>)
func! s:mshdo(paths, cmd) abort
  let res = dirvish#shdo(a:paths, a:cmd)
  nmap <buffer> <CR> <Cmd>sil norm Z!<CR>
  return res
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

aug cmdcase
  au!
  au CmdlineEnter * set nosmartcase
  au CmdlineLeave * set smartcase
aug END

aug terminal
  au!
  au TermOpen term://* if (&ft !~ "nnn") | tnoremap <buffer> <ESC> <C-\><C-n> | endif
  au TermClose term://*
        \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "coc") |
        \   exe "Kwbd" |
        \ endif
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

aug completion
  au!
  au BufEnter * lua require'completion'.on_attach()
aug END

augroup filemarks
  autocmd!
  autocmd BufLeave * call <SID>markext(expand("%:e"))
augroup END

function! s:markext(ext) abort
  if empty(a:ext) | return | endif
  exe "mark" toupper(a:ext[0])
endfunction

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

function! s:yankpast(type, ...) abort
  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "normal! gvy"
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  else
    silent exe "normal! `[v`]y"
  endif
  silent exe "normal! `]"
endfunction

lua << EOF
require'lspconfig'.vimls.setup{}
require'lspconfig'.pyright.setup{}
EOF

lua << EOF
local dap = require'dap'
dap.adapters.python = {
  type = 'executable';
  command = 'python';
  args = { '-m', 'debugpy.adapter' };
}
dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = 'launch';
  }
}
EOF

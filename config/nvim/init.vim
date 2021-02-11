let $RTP = stdpath('config')
let g:dispatch_no_maps = 1
let g:fzf_layout = { 'window': { 'width': 0.5461, 'height': 0.6, 'yoffset': 0.5, 'border': 'sharp' } }
let g:fzf_preview_window = []
let g:textobj_sandwich_no_default_key_mappings = 1
let g:user_emmet_leader_key = '<M-a>'
let g:vsnip_snippet_dir = stdpath('config') . '/vsnip'

call plug#begin(stdpath('data') . '/plugged')
Plug 'AndrewRadev/splitjoin.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'machakann/vim-sandwich'
Plug 'mattn/emmet-vim'
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-jdtls'
Plug 'neovim/nvim-lspconfig'
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'wellle/targets.vim'
" Language
Plug 'MTDL9/vim-log-highlighting'
Plug 'pprovost/vim-ps1'
call plug#end()

silent! call operator#sandwich#set('all', 'all', 'highlight', 0)
runtime macros/sandwich/keymap/surround.vim

silent! colorscheme codedark

set cmdwinheight=7
set completeopt=menu
set completeslash=slash
set fileformat=unix
set fileformats=unix,dos
set foldlevelstart=99
set foldmethod=indent
set grepprg=rg\ --smart-case\ --follow\ --hidden\ --vimgrep\ --glob\ !.git
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

if has('win32')
  set shellcmdflag=/s\ /v\ /c
endif

set statusline=
set statusline+=%(\ %{toupper(mode(0))}%)
set statusline+=%(\ @%{fugitive#head()}%)
set statusline+=%(\ %<%f%)
set statusline+=\ %h%m%r%w
set statusline+=%=
set statusline+=%([%n]%)
set statusline+=%(%<\ [%{&ff}]\ %y\ %l:%c\ %p%%\ %)

set path=,,**

set wildignore+=*/.elixir_ls/*
set wildignore+=*/node_modules/*
set wildignore+=Session.vim

" windows <BS> fix
nmap <C-h> <BS>

" disable <C-z> win32 memory leak
if has('win32')
  nnoremap <C-z> <Nop>
endif

nnoremap <BS> <C-^>
nnoremap <C-p> <C-i>
nnoremap <C-w>S <Cmd>sp +Scratch<CR>
nnoremap <Tab> :buffer *
nnoremap S <Cmd>Scratch<CR>
nnoremap U <C-r>
nnoremap Y y$
noremap # ?\<<C-r><C-w>\><CR>
noremap ' `
noremap * /\<<C-r><C-w>\><CR>
noremap <expr> j (v:count ? 'm`' . v:count . 'j' : 'gj')
noremap <expr> k (v:count ? 'm`' . v:count . 'k' : 'gk')

nnoremap <Space> <Nop>
nnoremap <Space><Space> :'{,'}s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Space>k <Cmd>FPsKill<CR>
nnoremap <Space>d <Cmd>Kwbd<CR>
nnoremap <Space>f <Cmd>Files<CR>
nnoremap <Space>g <Cmd>GFiles<CR>
nnoremap <Space>h <Cmd>History<CR>
nnoremap <Space>j :tjump /
nnoremap <Space>q <Cmd>q<CR>
nnoremap <Space>t <Cmd>tabnew<CR>
nnoremap <Space>w <Cmd>update<CR>
nnoremap <Space>yp <Cmd>let @+ = expand("%:p")<CR>
noremap <Space>P "+P
noremap <Space>Y "+yg_
noremap <Space>p "+p
noremap <Space>y "+y

nnoremap d<CR> <Cmd>Dispatch<CR>
nnoremap d<Space> :Dispatch<Space>

nmap m, #``cgN
nmap m; *``cgn
nnoremap m<CR> <Cmd>Make<CR>
nnoremap m<Space> :Make<Space>
nnoremap m= :set makeprg=
nnoremap m? <Cmd>Copen!<CR>
vnoremap m, y?\V<C-R>=escape(@@,'/\')<CR><CR>``cgN
vnoremap m; y/\V<C-R>=escape(@@,'/\')<CR><CR>``cgn

nmap gw <C-w>
nnoremap g. <Cmd>Gvdiffsplit<CR>
nnoremap g/ mS:sil!gr ""<Left>
nnoremap g<CR> <Cmd>G<CR>
nnoremap g<Space> :G<Space>
nnoremap g> <Cmd>Gvdiffsplit HEAD<CR>
nnoremap gL <Cmd>Gclog<CR>
nnoremap gb <Cmd>G blame<CR>
nnoremap gs mS:sil!gr "\b<C-r>=expand("<cword>")<CR>\b"<CR>
nnoremap gy <Cmd>set opfunc=util#yankpastfunc<CR>g@
nnoremap gyy <Cmd>set opfunc=util#yankpastfunc<CR>g@_
noremap g# ?<C-r><C-w><CR>
noremap g* /<C-r><C-w><CR>
noremap gd <Cmd>call <SID>fsearchdecl(expand("<cword>"))<CR>
noremap gh ^
noremap gl g_
vnoremap gs <Esc><Cmd>call util#grepfunc(visualmode(), 1)<CR>
vnoremap gy <Esc><Cmd>call util#yankpastfunc(visualmode(), 1)<CR>

" PSReadLine bug
tnoremap <M-c> <M-c>
tnoremap <M-h> <M-h>

nnoremap z/ <Cmd>BLines<CR>

noremap s <Nop>
noremap s] <Cmd>lua vim.lsp.buf.definition()<CR>
noremap sc <Cmd>lua vim.lsp.buf.rename()<CR>
noremap sd <Cmd>lua vim.lsp.buf.declaration()<CR>
noremap si <Cmd>lua vim.lsp.buf.implementation()<CR>
noremap sr <Cmd>lua vim.lsp.buf.references()<CR>

nnoremap <expr> [<M-q> '<Cmd>sil!uns' . v:count1 . 'colder<CR>'
nnoremap <expr> ]<M-q> '<Cmd>sil!uns' . v:count1 . 'cnewer<CR>'

nnoremap <expr> <t '<Cmd>tabmove -' . v:count1 . '<CR>'
nnoremap <expr> >t '<Cmd>tabmove +' . v:count1 . '<CR>'

nmap qq <Cmd>call util#toggleqf()<CR>
nnoremap Q q
nnoremap q <Nop>
nnoremap q! :Cdelete<Space>
nnoremap q/ q/
nnoremap q: q:
nnoremap q<Space> :Cget<Space>
nnoremap q? q?

nnoremap '# <Cmd>Esyn<CR>
nnoremap '$ <Cmd>Einit<CR>
nnoremap '@ <Cmd>Eftp<CR>

inoremap (<CR> (<CR>)<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap {<CR> {<CR>}<Esc>O
inoremap {; {<CR>};<Esc>O

imap <expr> <CR> <SID>imapcr()
imap <expr> <S-Tab> <SID>imapstab()
imap <expr> <Tab> <SID>imaptab()
smap <expr> <CR> <SID>imapcr()
smap <expr> <S-Tab> <SID>imapstab()
smap <expr> <Tab> <SID>imaptab()

inoremap <expr> <C-]> pumvisible() ? "\<C-]>" : "\<C-x><C-]>"
inoremap <expr> <C-_> pumvisible() ? "\<C-f>" : "\<C-x><C-f>"
inoremap <expr> <C-l> pumvisible() ? "\<C-l>" : "\<C-x><C-l>"
inoremap <expr> <C-o> pumvisible() ? "\<C-n>" : "\<C-x><C-o>"
snoremap <expr> <C-]> pumvisible() ? "\<C-]>" : "\<C-x><C-]>"
snoremap <expr> <C-_> pumvisible() ? "\<C-f>" : "\<C-x><C-f>"
snoremap <expr> <C-l> pumvisible() ? "\<C-l>" : "\<C-x><C-l>"
snoremap <expr> <C-o> pumvisible() ? "\<C-n>" : "\<C-x><C-o>"

imap <expr> ; vsnip#expandable() ? '<Plug>(vsnip-expand)' : ';'
smap <expr> ; vsnip#expandable() ? '<Plug>(vsnip-expand)' : ';'

nnoremap <expr> <C-L>
      \ (v:count ? '<Cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>' : '')
      \ . (v:count ? '<Cmd>edit<CR>' : '')
      \ . '<Cmd>noh<CR>'
      \ . (has('diff') ? '<Cmd>diffupdate<CR>' : '')
      \ . '<Cmd>redraw<CR>'

cnoremap <C-r><C-t> <C-r>=expand("%:t")<CR>
cnoremap <expr> <CR> ccr#run()
cnoremap <expr> <S-Tab> <SID>stabsearch(getcmdtype())
cnoremap <expr> <Tab> <SID>tabsearch(getcmdtype())

function! s:imaptab() abort
  if pumvisible() | return "\<C-n>" | endif
  if vsnip#jumpable(1) | return "\<Plug>(vsnip-jump-next)" | endif
  if util#ismatchtext('\k+$') | return "\<C-n>" | endif
  return "\<Tab>"
endfunction

function! s:imapstab() abort
  if pumvisible() | return "\<C-p>" | endif
  if vsnip#jumpable(1) | return "\<Plug>(vsnip-jump-prev)" | endif
  if util#ismatchtext('\k+$') | return "\<C-p>" | endif
  return "\<S-Tab>"
endfunction

function! s:imapcr() abort
  if !pumvisible() | return "\<CR>" | endif
  if complete_info()["selected"] == "-1" | return "\<C-e>\<CR>" | endif
  return "\<C-y>"
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
command! Scratch enew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
command! TrimWS %s\s\+$//e

command! FPsKill call fzf#run({
      \ 'source': 'tasklist /fo table /nh',
      \ 'sink': funcref('proc#pskill_sink'),
      \ 'window': g:fzf_layout.window})

command! -nargs=0 Syn
      \ for id in synstack(line("."), col(".")) |
      \   echo synIDattr(id, "name") |
      \ endfor

command! -nargs=1 -bang Cget
      \ let s:pat = string(<f-args>) |
      \ call setqflist(filter(getqflist(), 'v:val.text =~ ' . s:pat . ' || bufname(v:val.bufnr) =~ ' . s:pat)) |
      \ call setqflist([], 'a', {'title': 'Cget ' . s:pat}) |
      \ if <bang>v:true |
      \   sil!uns cfirst |
      \ endif |
      \ unlet s:pat

command! -nargs=1 -bang Cdelete 
      \ let s:pat = string(<f-args>) |
      \ call setqflist(filter(getqflist(), 'v:val.text !~ ' . s:pat . ' && bufname(v:val.bufnr) !~ ' . s:pat)) |
      \ call setqflist([], 'a', {'title': 'Cdelete ' . s:pat}) |
      \ if <bang>v:true |
      \   sil!uns cfirst |
      \ endif |
      \ unlet s:pat

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

augroup filemarks
  autocmd!
  autocmd BufLeave * call util#mark_file_context()
augroup END

augroup lsp
  autocmd!
  autocmd FileType java lua require'jdtls'.start_or_attach({cmd={'jdtls.bat'}, on_attach=require'lsputil'.attach})
augroup END

lua << EOF
local lsputil = require'lsputil'
require'lspconfig'.pyright.setup{on_attach=lsputil.attach}
require'lspconfig'.vimls.setup{on_attach=lsputil.attach}
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

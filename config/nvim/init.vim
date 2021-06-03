let $RTP = stdpath('config')
let g:textobj_sandwich_no_default_key_mappings = 1
let g:user_emmet_leader_key = '<M-a>'
let g:vsnip_snippet_dir = stdpath('config') . '/vsnip'

call plug#begin(stdpath('data') . '/plugged')
Plug 'AndrewRadev/splitjoin.vim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'machakann/vim-sandwich'
Plug 'mattn/emmet-vim'
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-jdtls'
Plug 'neovim/nvim-lspconfig'
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-repeat'
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
set completeopt=menuone,noselect
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
set pumheight=15
set shortmess+=c
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
nnoremap <C-j> <Cmd>lua require('skippi.picker').tags{}<CR>
nnoremap <C-p> <C-i>
nnoremap <C-q> <Cmd>Telescope quickfix<CR>
nnoremap <C-w>S <Cmd>sp +Scratch<CR>
nnoremap <Tab> :buffer *
nnoremap S <Cmd>Scratch<CR>
nnoremap U <C-r>
nnoremap Y y$
nnoremap y"% <Cmd>call setreg(v:register, @%)<CR>
nnoremap yp <Cmd>call setreg(v:register, expand("%:p"))<CR>
noremap # ?\<<C-r><C-w>\><CR>
noremap ' `
noremap * /\<<C-r><C-w>\><CR>
noremap <expr> j (v:count ? 'm`' . v:count . 'j' : 'gj')
noremap <expr> k (v:count ? 'm`' . v:count . 'k' : 'gk')

nmap <Space>P "+P
nmap <Space>Y "+yg_
nmap <Space>p "+p
nmap <Space>y "+y
nnoremap <Space> <Nop>
nnoremap <Space>d <Cmd>Kwbd<CR>
nnoremap <Space>f <Cmd>Telescope find_files<CR>
nnoremap <Space>g <Cmd>Telescope git_files<CR>
nnoremap <Space>h <Cmd>Telescope oldfiles<CR>
nnoremap <Space>j :TJump<Space>*
nnoremap <Space>q <Cmd>q<CR>
nnoremap <Space>t <Cmd>tab sb<CR>
vmap <Space>P "+P
vmap <Space>Y "+yg_
vmap <Space>p "+p
vmap <Space>y "+y

nmap m, #NcgN
nmap m; *Ncgn
vnoremap m, y?\V<C-R>=escape(@@,'/\')<CR><CR>NcgN
vnoremap m; y/\V<C-R>=escape(@@,'/\')<CR><CR>Ncgn

nmap gm, g#NcgN
nmap gm; g*Ncgn
nmap gw <C-w>
nnoremap g! <Cmd>lua require("skippi.picker").pkill{}<CR>
nnoremap g. <Cmd>Gvdiffsplit<CR>
nnoremap g/ mS:sil!gr ""<Left>
nnoremap g<C-]> :TJump <C-r><C-w><CR>
nnoremap g<CR> <Cmd>G<CR>
nnoremap g<Space> :G<Space>
nnoremap g> <Cmd>Gvdiffsplit HEAD<CR>
nnoremap gC :cdo<Space>
nnoremap gL <Cmd>Gclog<CR>
nnoremap gW :windo<Space>
nnoremap gb <Cmd>G blame<CR>
nnoremap gs mS:sil!gr "\b<C-r>=escape(expand("<cword>"), "#")<CR>\b"<CR>
nnoremap gy <Cmd>set opfunc=util#yankpastfunc<CR>g@
nnoremap gyy <Cmd>set opfunc=util#yankpastfunc<CR>g@_
noremap g# ?<C-r><C-w><CR>
noremap g* /<C-r><C-w><CR>
noremap gh ^
noremap gl g_
vnoremap gs <Esc><Cmd>call util#grepfunc(visualmode(), 1)<CR>
vnoremap gy <Esc><Cmd>call util#yankpastfunc(visualmode(), 1)<CR>

" PSReadLine bug
tnoremap <M-c> <M-c>
tnoremap <M-h> <M-h>

nnoremap z/ <Cmd>Telescope current_buffer_fuzzy_find<CR>

inoremap <C-k> <Cmd>lua vim.lsp.buf.hover()<CR>
noremap <C-k> <Cmd>lua vim.lsp.buf.hover()<CR>
noremap s <Nop>
noremap sL <Cmd>Telescope lsp_workspace_diagnostics<CR>
noremap s] <Cmd>Telescope lsp_definitions<CR>
noremap sa <Cmd>lua require'jdtls'.code_action()<CR>
noremap sc <Cmd>lua vim.lsp.buf.rename()<CR>
noremap sd <Cmd>lua vim.lsp.buf.declaration()<CR>
noremap si <Cmd>Telescope lsp_implementations<CR>
noremap sl <Cmd>exe "e" v:lua.vim.lsp.get_log_path()<CR>
noremap sr <Cmd>Telescope lsp_references<CR>
noremap ss <Cmd>Telescope lsp_workspace_symbols<CR>

nnoremap <expr> [<M-q> '<Cmd>sil!uns' . v:count1 . 'colder<CR>'
nnoremap <expr> ]<M-q> '<Cmd>sil!uns' . v:count1 . 'cnewer<CR>'

nnoremap <expr> <t '<Cmd>tabmove -' . v:count1 . '<CR>'
nnoremap <expr> >t '<Cmd>tabmove +' . v:count1 . '<CR>'

nmap qq <Cmd>call util#toggleqf()<CR>
nnoremap Q q
nnoremap q <Nop>
nnoremap q/ q/
nnoremap q: q:
nnoremap q? q?

nnoremap '# <Cmd>sil exe "e" "$RTP/after/syntax/" . &filetype . ".vim"<CR>
nnoremap '$ <Cmd>sil exe "e" stdpath('config') . '/init.vim'<CR>
nnoremap '@ <Cmd>sil exe "e" stdpath('config') . '/after/ftplugin/' . &filetype . '.vim'<CR>

inoremap (<CR> (<CR>)<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap {<CR> {<CR>}<Esc>O
inoremap {; {<CR>};<Esc>O

imap <expr> <S-Tab> <SID>imapstab()
imap <expr> <Tab> <SID>imaptab()
smap <expr> <S-Tab> <SID>imapstab()
smap <expr> <Tab> <SID>imaptab()

inoremap <expr> <C-e> compe#close('<C-e>')
inoremap <expr> <CR> compe#confirm('<CR>')

imap <expr> <C-]> pumvisible() ? "\<C-e>\<C-]>" : "\<C-x><C-]>"
imap <expr> <C-_> pumvisible() ? "\<C-e>\<C-f>" : "\<C-x><C-f>"
imap <expr> <C-l> pumvisible() ? "\<C-e>\<C-l>" : "\<C-x><C-l>"
imap <expr> <C-o> pumvisible() ? "\<C-e>\<C-n>" : "\<C-x><C-o>"
smap <expr> <C-]> pumvisible() ? "\<C-e>\<C-]>" : "\<C-x><C-]>"
smap <expr> <C-_> pumvisible() ? "\<C-e>\<C-f>" : "\<C-x><C-f>"
smap <expr> <C-l> pumvisible() ? "\<C-e>\<C-l>" : "\<C-x><C-l>"
smap <expr> <C-o> pumvisible() ? "\<C-e>\<C-n>" : "\<C-x><C-o>"

nnoremap <expr> <C-L>
      \ (v:count ? '<Cmd>edit<CR>' : '')
      \ . '<Cmd>noh<CR>'
      \ . (has('diff') ? '<Cmd>diffupdate<CR>' : '')
      \ . '<Cmd>redraw<CR>'

cnoremap <C-r><C-d> <C-r>=expand("%:p:h")<CR>/
cnoremap <C-r><C-t> <C-r>=expand("%:t")<CR>
cnoremap <expr> <CR> ccr#run()
cnoremap <expr> <S-Tab> <SID>stabsearch(getcmdtype())
cnoremap <expr> <Tab> <SID>tabsearch(getcmdtype())

function! s:choose_ins_complete_key(rev) abort
  let info = complete_info(['mode'])
  if info.mode == 'keyword' || info.mode == ''
    return a:rev ? "\<C-n>" : "\<C-p>"
  else
    return a:rev ? "\<C-p>" : "\<C-n>"
  endif
endfunction

function! s:imaptab() abort
  if pumvisible() | return <SID>choose_ins_complete_key(0) | endif
  if util#ismatchtext('\k+$|\.')
    return <SID>choose_ins_complete_key(0)
  endif
  return "\<Tab>"
endfunction

function! s:imapstab() abort
  if pumvisible() | return <SID>choose_ins_complete_key(1) | endif
  if util#ismatchtext('\k+$|\\.$')
    return <SID>choose_ins_complete_key(1)
  endif
  return "\<S-Tab>"
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

command! Ecode sil exe "!code -nwg" expand("%:p") . ":" . line('.') . ":" . col('.') "."
command! Eidea sil exe "!idea64" expand("%:p") . ":" . line('.')
command! Emacs sil exe '!emacsclientw -a "" +' . line('.') . ":" . col('.') bufname("%")
command! Hitest sil so $VIMRUNTIME/syntax/hitest.vim | set ro
command! -bang Kwbd call kwbd#run(<bang>0)
command! Scratch enew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
command! TrimWS %s/\s\+$//e
command! -nargs=1 -complete=tag_listfiles TJump lua require('skippi.picker').tags{search=<f-args>}

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
  au TextChanged,InsertLeave * nested
        \ if &readonly == 0 && filereadable(bufname('%')) | silent update | endif
  au FocusGained,BufEnter * silent! checktime
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit'|
        \   exe "normal! g`\""|
        \ endif
aug END

aug terminal
  au!
  au TermOpen term://* tnoremap <buffer> <ESC> <C-\><C-n>
  au TermClose term://* exe "Kwbd"
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
require'lspconfig'.pyright.setup{}
require'lspconfig'.vimls.setup{}
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

lua << EOF
require('compe').setup{
  source_timeout = 100,
  throttle_time = 20,
  source = {
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    path = true,
    vsnip = true,
  },
}
EOF

lua << EOF
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-a>"] = require('skippi.actions').toggle_selection_all,
        ["<C-q>"] = require('skippi.actions').send_to_qflist,
      },
    },
  },
  extensions = {
    fzf = {
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  },
}
require('telescope').load_extension('fzf')
require('jdtls.ui').pick_one_async = require('skippi.picker').jdtls_ui_picker
EOF

let g:surround_13 = "\n\r\n"
let g:surround_indent = 1
let g:user_emmet_leader_key = '<C-j>'
let g:vsnip_snippet_dir = stdpath('config') . '/vsnip'
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

call plug#begin(stdpath('data') . '/plugged')
Plug 'AndrewRadev/splitjoin.vim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
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
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'wellle/targets.vim'
Plug 'unblevable/quick-scope'
" Language
Plug 'MTDL9/vim-log-highlighting'
Plug 'pprovost/vim-ps1'
call plug#end()

aug qs_colors
  au!
  au ColorScheme * hi! link QuickScopePrimary ErrorMsg
  au ColorScheme * hi! link QuickScopeSecondary SignColumn
aug END

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

func s:edit_file_by_offset(offset) abort
  let dir = expand("%:h")
  if !isdirectory(dir) | return | endif
  let files = readdir(dir, { f -> !isdirectory(dir . '/' . f) })
  let idx = index(files, expand("%:t")) + a:offset
  if !(0 <= idx && idx < len(files))
    echohl ErrorMsg | echo "No more items" | echohl None
    return
  endif
  exe "edit" dir . '/' . get(files, idx)
endfunc

nnoremap <BS> <C-^>
nnoremap <C-p> <Cmd>Telescope commands<CR>
nnoremap <C-q> <Cmd>Telescope quickfix<CR>
nnoremap <C-s> <Cmd>lua require('skippi.picker').tselect{}<CR>
nnoremap =P P=']
nnoremap =gP gPmz'[=']`z
nnoremap =gp gpmz'[=']`z
nnoremap =p p=']
nnoremap Q <Cmd>call util#toggleqf()<CR>
nnoremap Y y$
nnoremap [<C-q> <Cmd>cpfile<CR>
nnoremap [<M-q> <Cmd>exe "sil!uns colder" v:count1<CR>
nnoremap [f <Cmd>call <SID>edit_file_by_offset(-v:count1)<CR>
nnoremap [q <Cmd>cprev<CR>
nnoremap [t <Cmd>tprev<CR>
nnoremap ]<C-q> <Cmd>cnfile<CR>
nnoremap ]<M-q> <Cmd>exe "sil!uns cnewer" v:count1<CR>
nnoremap ]f <Cmd>call <SID>edit_file_by_offset(v:count1)<CR>
nnoremap ]q <Cmd>cnext<CR>
nnoremap ]t <Cmd>tnext<CR>
nnoremap yp <Cmd>call setreg(v:register, expand("%:p"))<CR>
noremap ' `
noremap <expr> j (v:count ? 'm`' . v:count . 'j' : 'gj')
noremap <expr> k (v:count ? 'm`' . v:count . 'k' : 'gk')
noremap [n <Cmd>for _ in range(v:count1)<CR>call search('^<<<<<<<\\|^=======\\|^>>>>>>>', "bsW")<CR>endfor<CR>
noremap ]n <Cmd>for _ in range(v:count1)<CR>call search('^<<<<<<<\\|^=======\\|^>>>>>>>', "sW")<CR>endfor<CR>
vnoremap =P P=']
vnoremap =gP gPmz'[=']`z
vnoremap =gp gpmz'[=']`z
vnoremap =p p=']

nnoremap s :'{,'}s\M\<<C-r><C-w>\>g<Left><Left>
vnoremap & <Esc><Cmd>'<,'>&<CR>
vnoremap g& <Esc><Cmd>'<,'>&&<CR>
vnoremap s "zy:'{,'}s\M<C-r>zg<Left><Left>

map <Space>P "+P
map <Space>Y "+Y
map <Space>p "+p
map <Space>y "+y
nnoremap <Space> <Nop>
nnoremap <Space>; <Cmd>Telescope lsp_workspace_diagnostics<CR>
nnoremap <Space>? <Cmd>exe "e" v:lua.vim.lsp.get_log_path()<CR>
nnoremap <Space>S <Cmd>Telescope lsp_workspace_symbols<CR>
nnoremap <Space>] <Cmd>Telescope lsp_definitions<CR>
nnoremap <Space>a <Cmd>lua require'jdtls'.code_action()<CR>
nnoremap <Space>d <Cmd>Kwbd<CR>
nnoremap <Space>f <Cmd>Telescope find_files<CR>
nnoremap <Space>g <Cmd>Telescope git_files<CR>
nnoremap <Space>h <Cmd>Telescope oldfiles<CR>
nnoremap <Space>i <Cmd>Telescope lsp_implementations<CR>
nnoremap <Space>j :tag<Space>/
nnoremap <Space>q <Cmd>q<CR>
nnoremap <Space>r <Cmd>Telescope lsp_references<CR>
nnoremap <Space>s <Cmd>lua vim.lsp.buf.rename()<CR>

nnoremap m, #NcgN
nnoremap m; *Ncgn
vnoremap m, "zy?\V<C-R>=escape(@z,'/\')<CR><CR>NcgN
vnoremap m; "zy/\V<C-R>=escape(@z,'/\')<CR><CR>Ncgn

nmap gw <C-w>
nnoremap g! <Cmd>lua require("skippi.picker").pkill{}<CR>
nnoremap g. <Cmd>Gvdiffsplit<CR>
nnoremap g/ :call util#grep_with_tagstack('""')<Left><Left><Left>
nnoremap g<C-_> :call util#grep_with_tagstack('"" --iglob *.<C-r>=expand('%:e')<CR>')<C-b><C-Right><C-Right><Left>
nnoremap g<C-s> <Cmd>call util#grep_with_tagstack('\b' . escape(expand('<cword>'), '%#"') . '\b --iglob *.' . expand('%:e'))<CR>
nnoremap g<CR> <Cmd>G<CR>
nnoremap g<Space> :G<Space>
nnoremap gL <Cmd>G log --first-parent<CR>
nnoremap gb <Cmd>G blame<CR>
nnoremap gs <Cmd>call util#grep_with_tagstack('\b' . escape(expand('<cword>'), '%#"') . '\b')<CR>
noremap gh ^
noremap gl g_
vnoremap gs <Esc><Cmd>call util#grepfunc(visualmode(), 1)<CR>

" PSReadLine bug
tnoremap <M-c> <M-c>
tnoremap <M-h> <M-h>

nnoremap z/ <Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find{previewer=false}<CR>

nnoremap <expr> <M-[> '<Cmd>tabmove -' . v:count1 . '<CR>'
nnoremap <expr> <M-]> '<Cmd>tabmove +' . v:count1 . '<CR>'

nnoremap '<Tab> <Cmd>sil exe "sp " stdpath('config') . '/after/indent/' . &filetype . '.vim'<CR>
nnoremap '# <Cmd>sil exe "sp " stdpath('config') . '/after/syntax/' . &filetype . '.vim'<CR>
nnoremap '$ <Cmd>sil exe "sp " stdpath('config') . '/init.vim'<CR>
nnoremap '@ <Cmd>sil exe "sp " stdpath('config') . '/after/ftplugin/' . &filetype . '.vim'<CR>

for key in ["<Left>", "<Right>", "<C-Left>", "<C-Right>"]
  exe "inoremap" key "<C-g>U" . key
endfor
imap <expr> <S-Tab> <SID>imapstab()
imap <expr> <Tab> <SID>imaptab()
smap <expr> <S-Tab> <SID>imapstab()
smap <expr> <Tab> <SID>imaptab()

inoremap <expr> <C-e> compe#close('<C-e>')
inoremap <expr> <CR> compe#confirm('<CR>')

imap <expr> <C-_> pumvisible() ? "\<C-e>\<C-f>" : "\<C-x><C-f>"
imap <expr> <C-l> pumvisible() ? "\<C-e>\<C-l>" : "\<C-x><C-l>"
smap <expr> <C-_> pumvisible() ? "\<C-e>\<C-f>" : "\<C-x><C-f>"
smap <expr> <C-l> pumvisible() ? "\<C-e>\<C-l>" : "\<C-x><C-l>"

noremap <expr> <C-L>
      \ (v:count ? '<Cmd>edit<CR>' : '')
      \ . '<Cmd>noh<CR>'
      \ . (has('diff') ? '<Cmd>diffupdate<CR>' : '')
      \ . '<Cmd>redraw<CR>'

noremap! <C-r><C-d> <C-r>=expand("%:p:h")<CR>/
noremap! <C-r><C-t> <C-r>=expand("%:t")<CR>
cnoremap <expr> <S-Tab> <SID>jump_to_next_match(0)
cnoremap <expr> <Tab> <SID>jump_to_next_match(1)

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
  if vsnip#available(1) | return "\<Plug>(vsnip-expand-or-jump)" | endif
  return "\<Tab>"
endfunction

function! s:imapstab() abort
  if pumvisible() | return <SID>choose_ins_complete_key(1) | endif
  return "\<S-Tab>"
endfunction

func! s:jump_to_next_match(forward) abort
  if getcmdtype() == '/'
    return a:forward ? "\<C-g>" : "\<C-t>"
  elseif getcmdtype() == '?'
    return a:forward ? "\<C-t>" : "\<C-g>"
  else
    return a:forward ? "\<C-z>" : "\<S-Tab>"
  endif
endfunc

command! Ecode sil exe "!code -nwg" expand("%:p") . ":" . line('.') . ":" . col('.') "."
command! Eidea sil exe "!idea64" expand("%:p") . ":" . line('.')
command! Emacs sil exe '!emacsclientw -a "" +' . line('.') . ":" . col('.') bufname("%")
command! -nargs=1 -complete=dir Files lua require('telescope.builtin').find_files{search_dirs={<q-args>}}
command! Hitest sil so $VIMRUNTIME/syntax/hitest.vim | set ro
command! JdtCompile lua require'jdtls'.compile()
command! JdtUpdateConfig lua require'jdtls'.update_project_config()
command! -bang Kwbd call kwbd#run(<bang>0)
command! Scratch sp +enew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
command! TrimWS %s/\s\+$//e

aug general
  au!
  au TextChanged,InsertLeave * nested
        \ if &readonly == 0 && filereadable(bufname('%')) | call <SID>buf_update_lockmarks() | endif
  au FocusGained,BufEnter * silent! checktime
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit'|
        \   exe "normal! g`\""|
        \ endif
  autocmd TextYankPost * silent! lua require("vim.highlight").on_yank()
  autocmd BufLeave * call util#mark_file_context()
aug END

func s:buf_update_lockmarks() abort
  let marks = [getpos("'["), getpos("']")]
  try
    sil update
  catch
    exe 'echoerr' string(v:exception)
  finally
    call setpos("'[", marks[0])
    call setpos("']", marks[1])
  endtry
endfunc

aug terminal
  au!
  au TermOpen term://* tnoremap <buffer> <ESC> <C-\><C-n>
  au TermClose term://* exe "Kwbd"
aug END

augroup lsp
  autocmd!
  autocmd FileType java lua require'jdtls'.start_or_attach{cmd={'jdtls.bat'},
        \ capabilities=require("skippi.lsp").capabilities}
augroup END

lua << EOF
require'lspconfig'.dartls.setup{capabilities=require("skippi.lsp").capabilities}
require'lspconfig'.pyright.setup{capabilities=require("skippi.lsp").capabilities}
require'lspconfig'.vimls.setup{capabilities=require("skippi.lsp").capabilities}
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
        ["<C-r><C-w>"] = require('skippi.actions').insert_cword,
        ["<C-r><C-a>"] = require('skippi.actions').insert_cWORD,
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

for tabnr in range(1, 9)
  exe 'noremap <M-' . tabnr . '> <Esc>' . tabnr . 'gt'
  exe 'noremap! <M-' . tabnr . '> <Esc>' . tabnr . 'gt'
  exe 'tnoremap <M-' . tabnr . '> <C-\><C-n>' . tabnr . 'gt'
endfor

inoremap {; {<CR>};<Esc>O
inoremap (<CR> (<CR>)<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap {<CR> {<CR>}<Esc>O

call targets#mappings#extend({'r': {'pair': [{'o':'[', 'c':']'}]}})

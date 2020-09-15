let $FZF_DEFAULT_COMMAND = 'rg --files --follow --hidden --glob !.git'
let g:fzf_layout = { 'window': { 'width': 0.5461, 'height': 0.6, 'yoffset': 0.5, 'border': 'sharp' } }
let g:lightline = {}
let g:lightline.active = {}
let g:lightline.active.left = [['mode'], ['gitbranch', 'filepath', 'modified']]
let g:lightline.colorscheme = 'codedark'
let g:lightline.component_function = { 'gitbranch': 'status#gitbranch', 'filepath': 'status#filepath' }
let g:netrw_altfile = 1
let g:netrw_fastbrowse = 0
let g:prosession_dir = stdpath('data') . '/session'

call plug#begin(stdpath('data') . '/plugged')
" Function
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'machakann/vim-sandwich'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'wellle/targets.vim'
" Visual
Plug 'itchyny/lightline.vim'
Plug 'tomasiser/vim-code-dark'
call plug#end()

silent! colorscheme codedark

set fileformat=unix
set fileformats=unix,dos
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set inccommand=nosplit
set lazyredraw
set mouse=
set noequalalways
set noruler
set splitbelow
set splitright
set termguicolors
set wildmode=list:longest,full

nnoremap <BS> <C-^>
nnoremap <Tab> :ls<CR>:b<Space>

nmap <silent> <Space>re <Plug>(coc-rename)
" nnoremap <silent> - :Ex %:h<CR>
nnoremap <silent> - :call <SID>openfm(expand("%:h"))<CR>
nnoremap <silent> <Space>fd :<C-u>Kwbd<CR>
nnoremap <silent> <Space>fl :e %<CR>
nnoremap <silent> <Space>fm :silent! make %:S<CR>
nnoremap <silent> <Space>fo :Files<CR>
nnoremap <silent> <Space>gd :Gdiff<CR>
nnoremap <silent> <Space>gl :Glog<CR>
nnoremap <silent> <Space>gs :Gedit :<CR>
nnoremap <silent> <Space>q :q<CR>
nnoremap <silent> <Space>w :w<CR>
nnoremap <silent> _ :Ex .<CR>
nnoremap g/ :silent!<Space>grep!<Space>""<Left>
nnoremap z/ :g//#<Left><Left>

cnoremap <expr> <CR> ccr#run()

command! Echrome silent !chrome "file://%:p"
command! Ecode silent exec "!start /B code --goto " . bufname("%") . ":" . line('.') . ":" . col('.')
command! Eftp silent exe "e $RTP/after/ftplugin/" . &filetype . ".vim"
command! Eidea silent exec "!start /B idea64 " . bufname("%") . ":" . line('.')
command! Emacs silent exec "!start /B emacsclientw +" . line('.') . ":" . col('.') . " " . bufname("%")
command! Ertp silent Ex $RTP
command! Kwbd call kwbd#run(1)

command! -nargs=* Flake8 call <SID>flake8(<q-args>)
func! s:flake8(args) abort
  let oldmake = &l:makeprg
  let olderr = &l:errorformat
  let &l:makeprg = get(g:, "flake8_path", "flake8")
  setlocal errorformat=%f:%l:%c:\ %t%n\ %m
  exe "silent make! " . a:args
  let &l:makeprg = oldmake
  let &l:errorformat = olderr
endfunc

func! s:openfm(path) abort
  let cwd = getcwd()
  exe "lcd " . a:path
  terminal wsl
  exe "lcd " . cwd
endfunc

let g:usercmd = 0
augroup usercmd
  au!
  au FileType *
        \ if empty(&buftype) && !mapcheck("<CR>")|
        \   nnoremap <buffer> <CR> :let g:usercmd=1<CR>:|
        \ endif
  au CmdlineEnter *
        \ if g:usercmd |
        \   cnoremap <buffer> d D|
        \   cnoremap <buffer> e E|
        \   cnoremap <buffer> f F|
        \   cnoremap <buffer> g G|
        \   cnoremap <buffer> p P|
        \ endif
  au CmdlineChanged,CmdlineLeave *
        \ if g:usercmd |
        \   silent! cunmap <buffer> d|
        \   silent! cunmap <buffer> e|
        \   silent! cunmap <buffer> f|
        \   silent! cunmap <buffer> g|
        \   silent! cunmap <buffer> p|
        \   let g:usercmd = 0|
        \ endif
augroup END

augroup general 
  au!
  au FocusGained,BufEnter * silent! checktime
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit'|
        \   exe "normal! g`\"" |
        \ endif
augroup END

augroup quickfix
  au!
  au QuickFixCmdPost [^l]* cwindow
  au QuickFixCmdPost l* lwindow
augroup END

augroup terminal
  au!
  " Automatically quit terminal after exit
  au TermClose term://*
        \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "coc") |
        \   call nvim_feedkeys("\<ESC>", 'n', v:true)|
        \ endif
  " Remap <ESC> to allow terminal escaping
  au TermOpen * tnoremap <buffer> <ESC> <C-\><C-n>
augroup END

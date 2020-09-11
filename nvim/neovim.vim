let $FZF_DEFAULT_COMMAND = 'rg --files --follow --hidden --glob !.git'
let $RTP = stdpath('config')
let g:fzf_layout = { 'window': { 'width': 0.5461, 'height': 0.6, 'yoffset': 0.5, 'border': 'sharp' } }
let g:lightline = {}
let g:lightline.active = {}
let g:lightline.active.left = [['mode'], ['gitbranch', 'filepath', 'modified']]
let g:lightline.colorscheme = 'codedark'
let g:lightline.component_function = { 'gitbranch': 'status#gitbranch', 'filepath': 'status#filepath' }
let g:netrw_altfile = 1
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
set nosplitright
set splitbelow
set termguicolors
set wildmode=list:longest,full

nnoremap <BS> <C-^>
nnoremap <Tab> :ls<CR>:b<Space>

nmap <silent> <Space>re <Plug>(coc-rename)
nnoremap <silent> ,v :Ex $RTP<CR>
nnoremap <silent> - :Ex %:h<CR>
nnoremap <silent> <Space>fd :<C-u>Kwbd<CR>
nnoremap <silent> <Space>fl :e %<CR>
nnoremap <silent> <Space>fm :make %:S<CR>
nnoremap <silent> <Space>fo :Files<CR>
nnoremap <silent> <Space>gb :GBlame<cr>
nnoremap <silent> <Space>gd :Gdiff<CR>
nnoremap <silent> <Space>gl :Glog<CR>
nnoremap <silent> <Space>gs :Gedit :<CR>
nnoremap <silent> <Space>oc :Code<CR>
nnoremap <silent> <Space>oe :Emacs<CR>
nnoremap <silent> <Space>og :Chrome<CR>
nnoremap <silent> <Space>q :q<CR>
nnoremap <silent> <Space>w :w<CR>
nnoremap <silent> _ :Ex .<CR>
nnoremap g/ :silent!<Space>grep!<Space>""<Left>
nnoremap z/ :g//#<Left><Left>

cnoremap <expr> <CR> ccr#run()

" Abbreviation
cnoreabbrev <expr> git (getcmdtype() ==# ':' && getcmdline() ==# 'git') ? 'Git' : 'git'

command! Chrome silent !chrome "file://%:p"
command! Emacs silent exec "!start /B emacsclientw +" . line('.') . ":" . col('.') . " " . bufname("%")
command! Idea silent exec "!start /B idea64 " . bufname("%") . ":" . line('.')
command! Code silent exec "!start /B code --goto " . bufname("%") . ":" . line('.') . ":" . col('.')
command! Kwbd call kwbd#run(1)

augroup general
  au!
  au FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
  au FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
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
        \   call nvim_input('<CR>')  |
        \ endif
  " Remap <ESC> to allow terminal escaping
  au TermOpen * tnoremap <buffer> <ESC> <C-\><C-n>
augroup END

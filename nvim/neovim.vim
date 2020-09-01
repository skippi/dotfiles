let $FZF_DEFAULT_COMMAND = 'rg --files --follow --hidden --glob !.git'
let g:dirvish_mode = ':sort ,^.*[\/],'
let g:fzf_layout = { 'window': { 'width': 0.5461, 'height': 0.6, 'yoffset': 0.5, 'border': 'sharp' } }
let g:gutentags_cache_dir = stdpath('data') . '/tags'
let g:gutentags_ctags_extra_args = ['--tag-relative=yes', '--fields=+ailmnS']
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_write = 1
let g:lightline = {}
let g:lightline.active = {}
let g:lightline.active.left = [['mode'], ['gitbranch', 'filepath', 'modified']]
let g:lightline.colorscheme = 'codedark'
let g:lightline.component_function = { 'gitbranch': 'status#gitbranch', 'filepath': 'status#filepath' }
let g:prosession_dir = stdpath('data') . '/session'
let g:python_highlight_all = 1
let g:scala_use_default_keymappings = 0

let g:gutentags_ctags_exclude = [
      \ '*-lock.json',
      \ '*.Master',
      \ '*.bak',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.cache',
      \ '*.class',
      \ '*.csproj',
      \ '*.csproj.user',
      \ '*.css',
      \ '*.exe', '*.dll',
      \ '*.git', '*.svg', '*.hg',
      \ '*.json',
      \ '*.less',
      \ '*.lock',
      \ '*.map',
      \ '*.md',
      \ '*.min.*',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.pdb',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ '*.pyc',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.scss',
      \ '*.sln',
      \ '*.swp', '*.swo',
      \ '*.tmp',
      \ '*.zip',
      \ '*/tests/*',
      \ '*build*.js',
      \ '*bundle*.js',
      \ '*sites/*/files/*',
      \ '.*rc*',
      \ 'bin',
      \ 'bower_components',
      \ 'build',
      \ 'bundle',
      \ 'cache',
      \ 'compiled',
      \ 'cscope.*',
      \ 'dist',
      \ 'docs',
      \ 'example',
      \ 'node_modules',
      \ 'tags*',
      \ 'vendor',
      \ ]

call plug#begin(stdpath('data') . '/plugged')
" Function
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'ludovicchabant/vim-gutentags'
Plug 'machakann/vim-sandwich'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'romainl/vim-qf'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'tpope/vim-repeat'
Plug 'wellle/targets.vim'
" Languages
Plug 'LnL7/vim-nix'
Plug 'bfrg/vim-cpp-modern'
Plug 'derekwyatt/vim-scala'
Plug 'elixir-editors/vim-elixir'
Plug 'neovimhaskell/haskell-vim'
Plug 'rust-lang/rust.vim'
Plug 'vim-python/python-syntax'
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
set path+=src/**,test/**
set splitbelow
set termguicolors
set wildmode=list:longest,full

nnoremap <BS> <C-^>
nnoremap <Tab> :ls<CR>:b<Space>

nmap <silent> ,q <Plug>(qf_qf_toggle)
nmap <silent> <Space>re <Plug>(coc-rename)
nnoremap <expr> <A-CR> GuiWindowFullScreen(!g:GuiWindowFullScreen)
nnoremap <silent> ,cd :tcd %:p:h<CR>:echom ":tcd " . expand("%:p:h")<CR>
nnoremap <silent> ,ve :edit $MYVIMRC<CR>
nnoremap <silent> ,vf :exec ":e " . stdpath('config') . '/ftplugin/' . &filetype . '.vim'<CR>
nnoremap <silent> ,vs :source $MYVIMRC<CR>:echom "init.vim reloaded"<CR>
nnoremap <silent> <Space>fd :<C-u>Kwbd<CR>
nnoremap <silent> <Space>fe :Dirvish<CR>
nnoremap <silent> <Space>fl :e %<CR>
nnoremap <silent> <Space>fo :Files<CR>
nnoremap <silent> <Space>gb :GBlame<cr>
nnoremap <silent> <Space>gd :Gdiff<CR>
nnoremap <silent> <Space>gl :Glog<CR>
nnoremap <silent> <Space>gs :Gedit :<CR>
nnoremap <silent> <Space>ld :CocList diagnostics<CR>
nnoremap <silent> <Space>ls :CocList symbols<CR>
nnoremap <silent> <Space>oc :Code<CR>
nnoremap <silent> <Space>oe :Emacs<CR>
nnoremap <silent> <Space>og :Chrome<CR>
nnoremap <silent> <Space>q :q<CR>
nnoremap <silent> <Space>to :call terminus#ToggleTerm()<CR>
nnoremap <silent> <Space>w :w<CR>
nnoremap g/ :silent!<Space>grep!<Space>""<Left>
nnoremap z/ :g//#<Left><Left>

cnoremap <expr> <CR> ccr#run()

" Abbreviation
cnoreabbrev <expr> make (getcmdtype() ==# ':' && getcmdline() ==# 'make') ? 'Make' : 'make'
cnoreabbrev <expr> git (getcmdtype() ==# ':' && getcmdline() ==# 'git') ? 'Git' : 'git'

command! -nargs=* Make silent make <args> | cwindow 3
command! Chrome silent !chrome "file://%:p"
command! Emacs silent exec "!start /B emacsclientw +" . line('.') . ":" . col('.') . " " . bufname("%")
command! Idea silent exec "!start /B idea64 " . bufname("%") . ":" . line('.')
command! Code silent exec "!start /B code --goto " . bufname("%") . ":" . line('.') . ":" . col('.')
command! Kwbd call kwbd#run(1)

augroup FileNeovim
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
  autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

augroup Terminal
  autocmd!
  " Automatically quit terminal after exit
  autocmd TermClose term://*
        \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "coc") |
        \   call nvim_input('<CR>')  |
        \ endif
  " Remap <ESC> to allow terminal escaping
  autocmd TermOpen * tnoremap <buffer> <ESC> <C-\><C-n>
  autocmd FileType fzf tunmap <buffer> <ESC>
augroup END

let $FZF_DEFAULT_COMMAND = 'rg --files --follow --hidden --glob !.git'
let g:coc_global_extensions = ['coc-tsserver', 'coc-python']
let g:fzf_layout = { 'window': { 'width': 0.5461, 'height': 0.6, 'yoffset': 0.5, 'border': 'sharp' } }
let g:netrw_altfile = 1
let g:netrw_fastbrowse = 0
let g:prosession_dir = stdpath('data') . '/session'
let g:user_emmet_leader_key = '<C-z>'

call plug#begin(stdpath('data') . '/plugged')
" Function
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'machakann/vim-sandwich'
Plug 'mattn/emmet-vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
Plug 'wellle/targets.vim'
" Language
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'peitalin/vim-jsx-typescript'
" Visual
Plug 'tomasiser/vim-code-dark'
call plug#end()

silent! colorscheme codedark

set cmdwinheight=10
set fileformat=unix
set fileformats=unix,dos
set grepprg=rg\ --follow\ --hidden\ --vimgrep\ --glob\ !.git
set inccommand=nosplit
set lazyredraw
set mouse=
set noruler
set splitright
set splitbelow
set termguicolors
set wildmode=list:longest,full

set statusline=
set statusline+=%(\ %{toupper(mode(0))}%)
set statusline+=%(\ @%{fugitive#head()}%)
set statusline+=%(\ %<%f%)
set statusline+=\ %h%m%r%w
set statusline+=%=
set statusline+=%([%n]%)
set statusline+=%(%<\ [%{&ff}]\ %p%%\ %l:%c\ %)

nmap <silent> <Space>re <Plug>(coc-rename)
nnoremap <BS> <C-^>
nnoremap <Tab> :ls<CR>:b<Space>
nnoremap <silent> - :call nnn#bufopen()<CR>
nnoremap <silent> <Space>fd :Kwbd<CR>
nnoremap <silent> <Space>fl :e%<CR>
nnoremap <silent> <Space>fm :silent! make %:S<CR>
nnoremap <silent> <Space>fo :Files<CR>
nnoremap <silent> <Space>gb :Gblame<CR>
nnoremap <silent> <Space>gd :Gdiff<CR>
nnoremap <silent> <Space>gl :Glog<CR>
nnoremap <silent> <Space>gs :Gedit :<CR>
nnoremap <silent> <Space>q :q<CR>
nnoremap <silent> <Space>w :w<CR>
nnoremap <silent> _ :call nnn#open(".")<CR>
nnoremap <silent> gd :call <SID>fsearchdecl(expand("<cword>"))<CR>
nnoremap g/ :sil!gr!<Space>
nnoremap z/ :g//#<Left><Left>

cnoremap <expr> <CR> ccr#run()

command! Echrome silent !chrome "file://%:p"
command! Ecode silent exe "!code --goto " . bufname("%") . ":" . line('.') . ":" . col('.')
command! Edata call nnn#open(stdpath('data'))
command! Eftp silent exe "e $RTP/after/ftplugin/" . &filetype . ".vim"
command! Eidea silent exec "!start /B idea64 " . bufname("%") . ":" . line('.')
command! Emacs silent exec "!start /B emacsclientw +" . line('.') . ":" . col('.') . " " . bufname("%")
command! Ertp call nnn#open(expand("$RTP"))
command! Esyn silent exe "e $RTP/after/syntax/" . &filetype . ".vim"
command! Hitest silent so $VIMRUNTIME/syntax/hitest.vim | set ro
command! Kwbd call kwbd#run(1)

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
  let @/ = '\V\<' . a:name . '\>'
  norm [[{
  let row = search(@/, 'cW')
  while row && s:iscomment(".", ".")
    let row = search(@/, 'cW')
  endwhile
  if &hls
    set hls
  endif
  redraw!
endfunc

func! s:iscomment(line, col) abort
  return synIDattr(synIDtrans(synID(line(a:line), col(a:col), 1)), "name") == "Comment"
endfunc

let g:usercmd = 0
augroup usercmd
  au!
  au FileType *
        \ if empty(&buftype) && !mapcheck("<CR>") && &ft != "netrw"|
        \   nnoremap <buffer> <CR> :let g:usercmd=1<CR>:|
        \ endif
  au CmdlineEnter *
        \ if g:usercmd |
        \   cnoremap <buffer> d D|
        \   cnoremap <buffer> e E|
        \   cnoremap <buffer> f F|
        \   cnoremap <buffer> g G|
        \   cnoremap <buffer> h H|
        \   cnoremap <buffer> p P|
        \   cnoremap <buffer> s S|
        \ endif
  au CmdlineChanged,CmdlineLeave *
        \ if g:usercmd |
        \   silent! cunmap <buffer> d|
        \   silent! cunmap <buffer> e|
        \   silent! cunmap <buffer> f|
        \   silent! cunmap <buffer> g|
        \   silent! cunmap <buffer> h|
        \   silent! cunmap <buffer> p|
        \   silent! cunmap <buffer> s|
        \   let g:usercmd = 0|
        \ endif
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

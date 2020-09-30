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
set statusline+=%(%<\ [%{&ff}]\ %y\ %l:%c\ %)

nmap <silent> gC <Plug>(coc-rename)
nmap <silent> gr <Plug>(coc-references)
nnoremap <BS> <C-^>
nnoremap <Tab> :ls<CR>:b<Space>
nnoremap <silent> - <Cmd>call nnn#bufopen()<CR>
nnoremap <silent> <Space>fd <Cmd>Kwbd<CR>
nnoremap <silent> <Space>fl <Cmd>e%<CR>
nnoremap <silent> <Space>fm <Cmd>sil! mak %:S<CR>
nnoremap <silent> <Space>fo <Cmd>Files<CR>
nnoremap <silent> <Space>gb <Cmd>Gblame<CR>
nnoremap <silent> <Space>gd <Cmd>Gdiff<CR>
nnoremap <silent> <Space>gl <Cmd>Glog<CR>
nnoremap <silent> <Space>gs <Cmd>Gedit :<CR>
nnoremap <silent> <Space>q <Cmd>q<CR>
nnoremap <silent> <Space>w <Cmd>w<CR>
nnoremap <silent> [q <Cmd>exe v:count1 . 'cp'<CR>
nnoremap <silent> ]q <Cmd>exe v:count1 . 'cn'<CR>
nnoremap <silent> _ <Cmd>call nnn#open(".")<CR>
nnoremap <silent> gd <Cmd>call <SID>fsearchdecl(expand("<cword>"))<CR>
nnoremap g/ :sil!gr!<Space>
nnoremap z/ :g//#<Left><Left>

cnoremap <expr> <CR> ccr#run()

command! Echrome sil !chrome "file://%:p"
command! Ecode sil exe "!code -nwg" expand("%:p") . ":" . line('.') . ":" . col('.') "."
command! Edata call nnn#open(stdpath('data'))
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
  if CocHasProvider('definition') && CocAction("jumpDefinition")
  else
    norm [[{
    let row = search(@/, 'cW')
    while row && s:iscomment(".", ".")
      let row = search(@/, 'cW')
    endwhile
  endif
  if &hls
    set hls
  endif
  redraw
endfunc

func! s:iscomment(line, col) abort
  return synIDattr(synIDtrans(synID(line(a:line), col(a:col), 1)), "name") == "Comment"
endfunc

augroup usercmd
  au!
  au FileType *
        \ if empty(&buftype) && !mapcheck("<CR>") && &ft != "netrw"|
        \   nnoremap <buffer> <CR> <Cmd>let g:usercmd=1<CR>:|
        \ endif
  au CmdlineEnter * call usercmd#map()
  au CmdlineChanged,CmdlineLeave * call usercmd#unmap()
augroup END

augroup general 
  au!
  au FocusGained,BufEnter * silent! checktime
  au CmdlineEnter * set ssl
  au CmdlineLeave * set nossl
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

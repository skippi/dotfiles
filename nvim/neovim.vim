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

nmap <silent> <Space>re <Plug>(coc-rename)
nnoremap <BS> <C-^>
nnoremap <Tab> :ls<CR>:b<Space>
" nnoremap <silent> - :tab sp +lcd%:p:h\|Bash\|lcd-<CR>
nnoremap <silent> - :call <SID>open_nnn(expand("%:p:h"))<CR>
nnoremap <silent> <Space>fd :Kwbd<CR>
nnoremap <silent> <Space>fl :e%<CR>
nnoremap <silent> <Space>fm :silent! make %:S<CR>
nnoremap <silent> <Space>fo :Files<CR>
nnoremap <silent> <Space>gb :Gblame<CR>
nnoremap <silent> <Space>gl :Glog<CR>
nnoremap <silent> <Space>gs :Gedit :<CR>
nnoremap <silent> <Space>ob :tab sp +Tex\ bash\ -c\ "tig\ blame\ %"<CR>
nnoremap <silent> <Space>ot :tab sp +Tex\ bash\ -c\ tig<CR>
nnoremap <silent> <Space>q :q<CR>
nnoremap <silent> <Space>w :w<CR>
nnoremap <silent> _ :call <SID>open_nnn(expand("."))<CR>
nnoremap g/ :silent!<Space>grep!<Space>""<Left>
nnoremap z/ :g//#<Left><Left>

cnoremap <expr> <CR> ccr#run()

command! Echrome silent !chrome "file://%:p"
command! Hitest silent so $VIMRUNTIME/syntax/hitest.vim | set ro
command! Ecode silent exec "!code.exe --goto " . bufname("%") . ":" . line('.') . ":" . col('.')
command! Eftp silent exe "e $RTP/after/ftplugin/" . &filetype . ".vim"
command! Eidea silent exec "!start /B idea64 " . bufname("%") . ":" . line('.')
command! Emacs silent exec "!start /B emacsclientw +" . line('.') . ":" . col('.') . " " . bufname("%")
command! Ertp silent Ex $RTP
command! Esyn silent exe "e $RTP/after/syntax/" . &filetype . ".vim"
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

command! -bar -nargs=* Bash Tex bash <args>
command! -nargs=+ Tex
      \ call <SID>texpre()|
      \ set ssl|
      \ exe "terminal" '<args>'|
      \ set nossl
func! s:texpre() abort
  aug temp
    au! BufEnter * startinsert | sil! au! temp
  aug END
endfunc

func! s:open_nnn(cwd) abort
  set ssl
  let s:nnn_tempfile = expand(tempname())
  " let clipath = s:vim_to_cli(s:nnn_tempfile)
  let clipath = s:nnn_tempfile
  let cmd = 'lf -selection-path "' . clipath . '"'
  let opts = {'on_exit': funcref('s:nnn_exit'), 'cwd': a:cwd}
  tabe
  set ft=nnn
  call termopen(cmd, opts)
  set nossl
endfunc

func! s:nnn_exit(...) abort
  if filereadable(s:nnn_tempfile)
    let paths = readfile(s:nnn_tempfile)
    if !empty(paths)
      bd!
      for path in paths
        exe "e" fnamemodify(fnameescape(path), ":~:.")
      endfor
    endif
  endif
endfunc

func! s:vim_to_cli(path)
  if has("win32")
    return "/mnt/c" . split(a:path, ":")[1]
  else
    return a:path
  endif
endfunc

func! s:cli_to_vim(path)
  if has("win32")
    return "C:" . a:path[6:]
  else
    return a:path
  endif
endfunc

command! -nargs=0 Syn call s:syn()
function! s:syn()
  for id in synstack(line("."), col("."))
    echo synIDattr(id, "name")
  endfor
endfunction

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

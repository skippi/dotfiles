let g:do_filetype_lua = 1

lua require('impatient')
lua require('plugins')
lua require('init')

set statusline=
set statusline+=%(\ %{toupper(mode(0))}%)
set statusline+=%(\ @%{FugitiveHead()}%)
set statusline+=%(\ %<%f%)
set statusline+=\ %h%m%r%w
set statusline+=%=
set statusline+=%([%n]%)
set statusline+=%(%<\ [%{&ff}]\ %y\ %l:%c\ %p%%\ %)

set wildignore+=*/.elixir_ls/*
set wildignore+=*/node_modules/*
set wildignore+=Session.vim

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

nnoremap [<C-q> <Cmd>cpfile<CR>
nnoremap [<M-q> <Cmd>exe "sil!uns colder" v:count1<CR>
nnoremap [q <Cmd>cprev<CR>
nnoremap [t <Cmd>tprev<CR>
nnoremap ]<C-q> <Cmd>cnfile<CR>
nnoremap ]<M-q> <Cmd>exe "sil!uns cnewer" v:count1<CR>
nnoremap ]q <Cmd>cnext<CR>
nnoremap ]t <Cmd>tnext<CR>
noremap <expr> j (v:count ? 'm`' . v:count . 'j' : 'gj')
noremap <expr> k (v:count ? 'm`' . v:count . 'k' : 'gk')
noremap [n <Cmd>for _ in range(v:count1)<CR>call search('^<<<<<<<\\|^=======\\|^>>>>>>>', "bsW")<CR>endfor<CR>
noremap ]n <Cmd>for _ in range(v:count1)<CR>call search('^<<<<<<<\\|^=======\\|^>>>>>>>', "sW")<CR>endfor<CR>

" search and replace
nnoremap <Space><Space> :'{,'}s\M\<<C-r><C-w>\>g<Left><Left>
xnoremap <Space><Space> "zy:'{,'}s\M<C-r>zg<Left><Left>
xnoremap & <Esc><Cmd>'<,'>&<CR>
xnoremap g& <Esc><Cmd>'<,'>&&<CR>

" operating system
nnoremap [f <Cmd>call <SID>edit_file_by_offset(-v:count1)<CR>
nnoremap ]f <Cmd>call <SID>edit_file_by_offset(v:count1)<CR>

" PSReadLine bug
tnoremap <M-c> <M-c>
tnoremap <M-h> <M-h>

nnoremap <expr> <M-[> '<Cmd>tabmove -' . v:count1 . '<CR>'
nnoremap <expr> <M-]> '<Cmd>tabmove +' . v:count1 . '<CR>'

nnoremap '<Tab> <Cmd>sil exe "e " stdpath('config') . '/after/indent/' . &filetype . '.vim'<CR>
nnoremap '# <Cmd>sil exe "e " stdpath('config') . '/after/syntax/' . &filetype . '.vim'<CR>
nnoremap '$ <Cmd>sil exe "e " stdpath('config') . '/init.vim'<CR>
nnoremap '@ <Cmd>sil exe "e " stdpath('config') . '/after/ftplugin/' . &filetype . '.vim'<CR>

for key in ["<Left>", "<Right>", "<C-Left>", "<C-Right>"]
  exe "inoremap" key "<C-g>U" . key
endfor

imap <expr> <C-_> pumvisible() ? "\<C-e>\<C-f>" : "\<C-x><C-f>"
smap <expr> <C-_> pumvisible() ? "\<C-e>\<C-f>" : "\<C-x><C-f>"

noremap <expr> <C-L>
      \ (v:count ? '<Cmd>edit<CR>' : '')
      \ . '<Cmd>noh<CR>'
      \ . (has('diff') ? '<Cmd>diffupdate<CR>' : '')
      \ . '<Cmd>redraw<CR>'

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

func! s:jump_to_next_match(forward) abort
  if getcmdtype() == '/'
    return a:forward ? "\<C-g>" : "\<C-t>"
  elseif getcmdtype() == '?'
    return a:forward ? "\<C-t>" : "\<C-g>"
  else
    return a:forward ? "\<C-z>" : "\<S-Tab>"
  endif
endfunc

command! EditCode sil exe "!code -nwg" expand("%:p") . ":" . line('.') . ":" . col('.') "."
command! EditIdea sil exe "!idea64" expand("%:p") . ":" . line('.')
command! EditEmacs sil exe '!emacsclientw -a "" +' . line('.') . ":" . col('.') bufname("%")
command! HighlightTest sil so $VIMRUNTIME/syntax/hitest.vim | set ro
command! -bang Kwbd call kwbd#run(<bang>0)
command! Scratch sp +enew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
command! TrimWS %s/\s\+$//e

aug general
  au!
  au TextChanged,InsertLeave *
        \ if &readonly == 0 && filereadable(bufname('%')) && &ft !~ "gitcommit" | call <SID>buf_update_lockmarks() | endif
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit'|
        \   exe "normal! g`\""|
        \ endif
  autocmd TextYankPost * silent! lua require("vim.highlight").on_yank()
  autocmd BufLeave * call util#mark_file_context()
aug END

func! s:buf_update_lockmarks() abort
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

augroup colors
  autocmd!
  autocmd ColorScheme * hi GitSignsAdd guifg=#5D7D20
        \ | hi GitSignsChange guifg=#37718C
        \ | hi GitSignsDelete guifg=#95161B
augroup END

for tabnr in range(1, 9)
  exe 'noremap <M-' . tabnr . '> <Esc>' . tabnr . 'gt'
  exe 'noremap! <M-' . tabnr . '> <Esc>' . tabnr . 'gt'
  exe 'tnoremap <M-' . tabnr . '> <C-\><C-n>' . tabnr . 'gt'
endfor

silent! colorscheme codedark

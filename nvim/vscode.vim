let g:textobj_sandwich_no_default_key_mappings = 1

call plug#begin(stdpath('data') . '/plugged')
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'
call plug#end()

sil! call operator#sandwich#set('all', 'all', 'highlight', 0)
runtime macros/sandwich/keymap/surround.vim

set ignorecase
set nojoinspaces
set smartcase
set timeoutlen=500
set updatetime=100

map [[ ?{<CR>w99[{
map [] k$][%?}<CR>
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
nnoremap ,, #``cgN
nnoremap ,; *``cgn
nnoremap - <Cmd>call VSCodeCall('workbench.view.explorer')<CR>
nnoremap <BS> <Cmd>call VSCodeCall('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup') <bar> call VSCodeCall('list.select')<CR>
nnoremap <C-p> <C-i>
nnoremap <Space> <Nop>
nnoremap <Space>fd <Cmd>Quit<CR>
nnoremap <Space>fo <Cmd>Find<CR>
nnoremap <Space>q <Cmd>Quit<CR>
nnoremap <Space>w <Cmd>Write<CR>
nnoremap <Tab> <Cmd>Find<CR>
nnoremap U <C-r>
nnoremap Y y$
nnoremap _ <Cmd>call VSCodeCall('workbench.view.explorer')<CR>
noremap ' `
vnoremap ,, y?\V<C-R>=escape(@",'/\')<CR><CR>``cgN
vnoremap ,; y/\V<C-R>=escape(@",'/\')<CR><CR>``cgn

" nnoremap gws <Cmd>Split<CR>
" nnoremap gwv <Cmd>Vsplit<CR>
map gs <Plug>(room_grep)
map gw <C-w>
nnoremap <silent> g/ m'<Cmd>call VSCodeCall('workbench.action.findInFiles')<CR>
noremap gh ^
noremap gl g_

nnoremap Q q
nnoremap q <Nop>
nnoremap q/ q/
nnoremap q: q:
nnoremap q? q?
nnoremap q] m'<Cmd>call VSCodeCall('editor.action.revealDefinition')<CR>
nnoremap qc m'<Cmd>call VSCodeCall('editor.action.rename')<CR>

nnoremap <expr> <C-L> (v:count ? '<Cmd>Edit<CR>' : '')
      \ . '<Cmd>noh<CR>'
      \ . (has('diff') ? '<Cmd>diffupdate<CR>' : '')

nnoremap <silent> <Space>lf <Cmd>call VSCodeCall('leetcode.searchProblem') <bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>ll <Cmd>call VSCodeCall('leetcode.switchDefaultLanguage')<bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>ls <Cmd>call VSCodeCall('leetcode.submitSolution')<bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>lt <Cmd>call VSCodeCall('leetcode.testSolution')<bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>

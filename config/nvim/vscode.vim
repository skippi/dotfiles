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
nnoremap - <Cmd>call VSCodeCall('workbench.view.explorer')<CR>
nnoremap <BS> <Cmd>call VSCodeCall('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup') <bar> call VSCodeCall('list.select')<CR>
nnoremap <C-p> <C-i>
nnoremap <Tab> <Cmd>Find<CR>
nnoremap U <C-r>
nnoremap Y y$
nnoremap _ <Cmd>call VSCodeCall('workbench.view.explorer')<CR>
noremap ' `

nnoremap <Space> <Nop>
nnoremap <Space>d <Cmd>Quit<CR>
nnoremap <Space>e <Cmd>call VSCodeCall('workbench.action.quickOpen')<CR>
nnoremap <Space>f <Cmd>Find<CR>
nnoremap <Space>q <Cmd>Quit<CR>
nnoremap <Space>w <Cmd>Write<CR>

nnoremap m, #``cgN
nnoremap m; *``cgn
vnoremap m, "hy?\V<C-R>=escape(@h,'/\')<CR><CR>``cgN
vnoremap m; "hy/\V<C-R>=escape(@h,'/\')<CR><CR>``cgn

map gw <C-w>
nnoremap g/ m'<Cmd>call VSCodeCall('workbench.action.findInFiles')<CR>
nnoremap gs <Cmd>set opfunc=util#grepfunc<CR>g@
noremap gh ^
noremap gl g_
vnoremap gs <Esc><Cmd>call util#grepfunc(visualmode(), 1)<CR>

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

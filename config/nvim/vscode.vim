call plug#begin(stdpath('data') . '/plugged')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
call plug#end()

set ignorecase
set nojoinspaces
set smartcase
set timeoutlen=500
set updatetime=100

nnoremap - <Cmd>call VSCodeCall('workbench.view.explorer')<CR>
nnoremap <BS> <Cmd>call VSCodeCall('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup') <bar> call VSCodeCall('list.select')<CR>
nnoremap U <C-r>
nnoremap Y y$
noremap ' `

nnoremap <Space> <Nop>
nnoremap <Space>d <Cmd>Quit<CR>
nnoremap <Space>f <Cmd>Find<CR>
nnoremap <Space>q <Cmd>Quit<CR>

nnoremap m, #``cgN
nnoremap m; *``cgn
vnoremap m, "hy?\V<C-R>=escape(@h,'/\')<CR><CR>``cgN
vnoremap m; "hy/\V<C-R>=escape(@h,'/\')<CR><CR>``cgn

map gw <C-w>
nnoremap g/ m'<Cmd>call VSCodeCall('workbench.action.findInFiles')<CR>
nnoremap gs <Cmd>call VSCodeCall('workbench.action.findInFiles', {"query": expand("<cword>")})<CR>
noremap gh ^
noremap gl g_
vnoremap gs <Esc><Cmd>call util#grepfunc(visualmode(), 1)<CR>

nnoremap <expr> <C-L> (v:count ? '<Cmd>Edit<CR>' : '')
      \ . '<Cmd>noh<CR>'
      \ . (has('diff') ? '<Cmd>diffupdate<CR>' : '')

nnoremap <silent> <Space>lf <Cmd>call VSCodeCall('leetcode.searchProblem') <bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>ll <Cmd>call VSCodeCall('leetcode.switchDefaultLanguage')<bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>ls <Cmd>call VSCodeCall('leetcode.submitSolution')<bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
nnoremap <silent> <Space>lt <Cmd>call VSCodeCall('leetcode.testSolution')<bar>sl 250m<bar>call VSCodeCall('workbench.action.focusFirstEditorGroup')<CR>
